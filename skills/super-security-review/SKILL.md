---
name: forge:super-security-review
description: "On-demand deep frontend security review for React + TypeScript. Run ONLY when the user explicitly invokes it by name or explicitly asks for a security review — e.g. 'run forge:super-security-review', 'super security review this', 'do a security pass'. Does NOT auto-trigger during normal coding, editing, or generic 'review this' requests. Reviews code for XSS, secrets in the client bundle, insecure token storage, dependency/supply-chain risk, CORS vs CSP confusion, client-only validation/authorization, production source maps, postMessage/window.opener, prototype pollution and unsafe JSON parsing, and clickjacking. Flags findings with severity (low/medium/high) and a concrete fix — never blocks code generation."
---

# Super Security Review (React + TypeScript)

A deep, on-demand frontend security pass — run it explicitly when you want a focused security review of React/TypeScript code. Findings are surfaced the way a careful senior dev surfaces them in a PR: **inline, with severity, with a fix — never blocking.**

Full risk catalog with vulnerable/fixed examples and grep patterns: `references/security-checks.md`.

## When to Run

This skill is **manual / on-demand only**. Run it when the user:

- Invokes it by name (`forge:super-security-review`, "super security review", "run the security skill")
- Explicitly asks for a security review, security audit, or security pass on some code

**Do not** auto-activate it during normal writing/editing, or on a generic "review this" / "check my code" request — that's what `forge:review-code` is for. This skill is the deeper, security-only pass you reach for deliberately.

Scope it like any review: specific files if named; otherwise `git diff --name-only` (and `--staged`) for working changes, or `git diff main...HEAD --name-only` for a branch/PR.

## How to Behave

**Flag, don't block.** Never refuse or withhold code over a finding. Report the issue with a concrete fix and move on.

**Be practical, not alarmist.** Most findings are "worth knowing," not catastrophic. Reserve urgency for the two things that usually are: real secrets in client code, and unsanitized HTML/URL injection. Frame the rest as hardening.

**Every finding gets three things:**
1. **Severity** — `low` / `medium` / `high` (see the catalog for defaults; adjust to real impact)
2. **What & where** — the risk in one sentence, with `file:line`
3. **A concrete fix** — the corrected pattern, not just "this is unsafe"

## Workflow

### Step 1 — Detect

Scan the code in scope for these patterns. Read `references/security-checks.md` for the full risk/fix detail on any that match.

| # | Topic | Grep / look for | Default severity |
|---|-------|-----------------|------------------|
| 1 | **XSS** | `dangerouslySetInnerHTML`, `.innerHTML =`, `document.write`, `href={`/`src={` from user data, `javascript:` | High |
| 2 | **Secrets in bundle** | `VITE_*SECRET/KEY/TOKEN`, `REACT_APP_*`, `NEXT_PUBLIC_*` secrets, `sk_live_`, `AKIA`, `-----BEGIN`, token in `console.log` | High (real secret) |
| 3 | **Token storage** | `localStorage.setItem('...token...')`, `sessionStorage` + token, JS-read `Authorization` header | Medium |
| 4 | **Supply chain** | new `package.json` deps (new/obscure/typosquat), `postinstall`/`preinstall` scripts | Medium |
| 5 | **CORS vs CSP** | `Access-Control-Allow-Origin: *` + credentials, no `Content-Security-Policy`, CORS used as XSS defense | Medium |
| 6 | **Client-only auth** | `role ===`, `isAdmin`, `hasPermission`, client-computed price/quantity trusted by a request | High |
| 7 | **Source maps** | `sourcemap: true`, `GENERATE_SOURCEMAP=true`, `.map` in `dist/` | Low–Medium |
| 8 | **postMessage / opener** | `addEventListener('message'` w/o `origin` check, `postMessage(..., '*')`, `target="_blank"` w/o `rel` | Medium |
| 9 | **Proto pollution / JSON** | `__proto__`, hand-rolled `merge`/`deepMerge`, `JSON.parse` of external data w/o `try/catch` | Medium |
| 10 | **Clickjacking** | no `X-Frame-Options` / `frame-ancestors` on sensitive UI | Medium |

### Step 2 — Verify Before Flagging

- Confirm the value is actually user/external-controlled (not a static, trusted constant) before flagging XSS or open-redirect.
- Confirm an env var holds a *secret* — publishable/public keys (`pk_live_`, public API base URLs) are fine in the client.
- For client-only auth, the question is "is this the *only* enforcement?" — a render gate is fine if the backend re-checks. Flag it as "confirm backend enforces this," not as a definite hole.
- Don't report a line you haven't read. No guessed line numbers.

### Step 3 — Report

Group by severity, lead with the highest:

```markdown
## Security Review

### High
- `src/components/Comment.tsx:14` — `dangerouslySetInnerHTML` renders `body` (from the API) unsanitized → XSS. Wrap in `DOMPurify.sanitize(body)` before injecting, or render as text.
- `.env:3` — `VITE_STRIPE_SECRET_KEY` ships to the browser in plaintext. Move the secret server-side; the client only needs `pk_live_...`.

### Medium
- `src/auth/store.ts:8` — auth token in `localStorage` is readable by any XSS. Prefer an httpOnly cookie, or keep the access token in memory. (Acceptable if XSS is well-hardened — noting the tradeoff.)
- `src/widgets/Embed.tsx:22` — `message` listener has no `event.origin` check → trusts any frame. Compare `event.origin` against your trusted origin before using `event.data`.

### Low
- `vite.config.ts:6` — `build.sourcemap: true` exposes source in production. Set `false`, or upload maps privately to your error tracker.

### Summary
2 high, 2 medium, 1 low across 4 files. _Flagged, not blocking._
```

## Checklist

- [ ] Every `dangerouslySetInnerHTML` / `innerHTML` on external content is sanitized (or rendered as text)
- [ ] User-controlled `href`/`src` validated against an allow-list of schemes (no `javascript:`/`data:`)
- [ ] No real secrets in `VITE_*`/`REACT_APP_*`/`NEXT_PUBLIC_*` env vars or hardcoded in client code
- [ ] No tokens/secrets/full-user objects in `console.log` or analytics calls
- [ ] Auth token storage choice (localStorage vs httpOnly cookie vs memory) is deliberate and its tradeoff noted
- [ ] New dependencies vetted (maintenance, downloads, typosquat); `postinstall` scripts inspected; `npm audit` suggested
- [ ] CORS and CSP not conflated; permissive CORS (`*` + credentials) flagged; CSP suggested if absent
- [ ] No access-control or business rule enforced *only* on the client — backend enforcement confirmed/flagged
- [ ] Production source maps disabled or shipped privately
- [ ] `postMessage` listeners check `event.origin`; `postMessage` sends target a specific origin (not `'*'`)
- [ ] All `target="_blank"` links have `rel="noopener noreferrer"`
- [ ] No prototype pollution via hand-rolled merge; external `JSON.parse` guarded with `try/catch` (ideally schema-validated)
- [ ] Sensitive UI has anti-framing awareness (`frame-ancestors`/`X-Frame-Options` at the deploy layer)
- [ ] Every finding has severity + `file:line` + a concrete fix; nothing blocked or refused
