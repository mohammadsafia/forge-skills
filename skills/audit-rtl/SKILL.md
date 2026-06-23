---
name: forge:audit-rtl
description: "Audit components for RTL (right-to-left) support — find directional styling issues. Use when the user mentions RTL, Arabic, bidirectional layout, or says 'check RTL', 'does this work in Arabic', 'fix RTL', 'audit bidirectional'. Important for projects supporting Arabic or Hebrew."
---

# Audit RTL

Scan components for directional styling that breaks in RTL mode and suggest fixes.

## Preferred Fix: Logical Properties (Tailwind v4)

Tailwind v4 ships **logical-property utilities** that resolve to start/end based on
text direction, so they work in both LTR and RTL with a *single* class. **Always
prefer these over `rtl:` overrides** — they are shorter, self-mirroring, and the
idiomatic fix. Reach for an explicit `rtl:` override only when no logical utility
exists (e.g. `rtl:rotate-180` for icons).

| Physical (breaks in RTL) | Logical (auto-mirrors) | Maps to |
|--------------------------|------------------------|---------|
| `ml-*` | `ms-*` | margin-inline-start |
| `mr-*` | `me-*` | margin-inline-end |
| `pl-*` | `ps-*` | padding-inline-start |
| `pr-*` | `pe-*` | padding-inline-end |
| `left-*` | `start-*` | inset-inline-start |
| `right-*` | `end-*` | inset-inline-end |
| `text-left` | `text-start` | text-align: start |
| `text-right` | `text-end` | text-align: end |
| `border-l` / `border-l-*` | `border-s` / `border-s-*` | border-inline-start |
| `border-r` / `border-r-*` | `border-e` / `border-e-*` | border-inline-end |
| `rounded-l-*` | `rounded-s-*` | start corners |
| `rounded-r-*` | `rounded-e-*` | end corners |
| `rounded-tl-*` | `rounded-ss-*` | top-start corner |
| `rounded-tr-*` | `rounded-se-*` | top-end corner |
| `rounded-bl-*` | `rounded-es-*` | bottom-start corner |
| `rounded-br-*` | `rounded-ee-*` | bottom-end corner |
| `scroll-ml-*` / `scroll-pl-*` | `scroll-ms-*` / `scroll-ps-*` | scroll margin/padding start |
| `scroll-mr-*` / `scroll-pr-*` | `scroll-me-*` / `scroll-pe-*` | scroll margin/padding end |

> Logical utilities require `dir="rtl"` (or `dir="ltr"`) to be set on an ancestor —
> usually the `<html>` element, toggled by the i18n layer. If `dir` is never set,
> neither logical utilities nor `rtl:` variants do anything. Confirm it's wired up
> before reporting fixes as effective.

## What to Scan For

### Directional Spacing, Position, Text, Borders, Radius
Flag any physical-side utility from the table above that has no `rtl:` counterpart,
and replace it with the logical equivalent:

```typescript
// Find → Replace (preferred)
ml-4         → ms-4
pr-6         → pe-6
left-0       → start-0
text-left    → text-start
border-l     → border-s
rounded-l-lg → rounded-s-lg

// Legacy fallback (only if logical utility unavailable / overrides needed)
ml-4 → ml-4 rtl:ml-0 rtl:mr-4
```

### Directional Icons
Icons with directional meaning (arrows, chevrons) must mirror in RTL. There is no
logical utility for this — use an explicit `rtl:` transform:

```typescript
// CORRECT — mirror horizontally (preserves vertical orientation)
<ChevronRight className="h-4 w-4 rtl:-scale-x-100" />
<ArrowLeft className="h-4 w-4 rtl:-scale-x-100" />

// Acceptable for visually symmetric glyphs
<ChevronRight className="h-4 w-4 rtl:rotate-180" />

// WRONG — no flip
<ChevronRight className="h-4 w-4" />
```

Prefer `rtl:-scale-x-100` over `rtl:rotate-180`: rotation also flips the icon
vertically, which is wrong for glyphs with vertical asymmetry. Decorative,
non-directional icons (close, search, settings) must NOT flip.

### Transform Origins
```typescript
// Find → Fix (no logical utility — use rtl: override)
origin-left  → add rtl:origin-right
origin-right → add rtl:origin-left
```

## Common Mistakes (Do NOT Flag / Do NOT "Fix")

- **`rtl:flex-row-reverse` is almost always wrong.** When `dir="rtl"` is set, a
  `flex flex-row` row *already* lays its children out right-to-left. Adding
  `rtl:flex-row-reverse` double-reverses it back to LTR order — a bug, not a fix.
  Plain `flex-row` is correct in both directions. Only consider `flex-row-reverse`
  when the visual order must intentionally differ from source order in one direction
  — rare, and verify against the design before suggesting it.
- Do not "fix" `gap-*` — flex/grid gaps follow direction automatically.

## Safe Patterns (No Fix Needed)

These are fine without RTL counterparts:
- `mx-*`, `px-*` (both sides equal)
- `mt-*`, `mb-*`, `pt-*`, `pb-*` (vertical, not directional)
- `rounded-t-*`, `rounded-b-*` (vertical)
- `text-center` (no direction)
- `top-*`, `bottom-*` (vertical positioning)
- Flexbox `gap-*` and CSS Grid gaps (handled by browser)
- `flex-row` / `flex-col` (follow document direction automatically)

## How to Scan

Grep the component tree for physical-side utilities, then triage each hit against the
tables above. Useful starting patterns (scope to `.tsx`/`.jsx` in `src/`):

```bash
# Spacing, position, text, borders, radius — physical sides
\b(ml|mr|pl|pr|left|right|border-l|border-r|rounded-l|rounded-r|rounded-tl|rounded-tr|rounded-bl|rounded-br)-
\btext-(left|right)\b
\borigin-(left|right)\b

# Likely bugs
\brtl:flex-row-reverse\b      # usually a double-reversal mistake

# Directional icons that may need a flip
Chevron(Left|Right)|Arrow(Left|Right)|Caret(Left|Right)
```

For each match, decide: replace with a logical utility (preferred), add a `rtl:`
override (only when no logical utility exists), or mark safe.

## Report Format

```markdown
## RTL Audit

### Issues
- `Component.tsx:15` — `ml-4` → use logical `ms-4`
- `Component.tsx:28` — `rounded-l-lg` → use logical `rounded-s-lg`
- `Component.tsx:42` — `ChevronRight` not flipping → add `rtl:-scale-x-100`
- `Component.tsx:55` — `text-left` → use logical `text-start`
- `Component.tsx:60` — `rtl:flex-row-reverse` double-reverses an already-mirrored row → remove it

### Summary
X directional issues found (Y auto-fixable via logical-property swap)
```

## Auto-Fix

When the user confirms, apply the swaps automatically:
1. Replace physical-side utilities with their logical equivalents (table above).
2. Add `rtl:-scale-x-100` to directional icons that lack a flip.
3. Add `rtl:` overrides only where no logical utility exists (transform origins).
4. Remove erroneous `rtl:flex-row-reverse` on rows that should follow direction.

Before reporting fixes as effective, verify `dir` is set on `<html>` by the i18n
layer — logical utilities and `rtl:` variants are inert without it.
