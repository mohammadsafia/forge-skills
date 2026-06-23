---
name: forge:audit-rtl
description: "Audit components for RTL (right-to-left) support — find directional styling issues. Use when the user mentions RTL, Arabic, bidirectional layout, or says 'check RTL', 'does this work in Arabic', 'fix RTL', 'audit bidirectional'. Important for projects supporting Arabic or Hebrew."
---

# Audit RTL

Scan components for directional styling that breaks in RTL mode and suggest fixes.

## The Rule

Directional styling must use logical properties (`ms`/`me`, `ps`/`pe`, `start`/`end`,
`rounded-s`/`rounded-e`, `border-s`/`border-e`, `text-start`/`text-end`) **or** an explicit
`rtl:` counterpart — never a bare directional class. For things with no logical equivalent
(icon flips, flex visual ordering, transform origins), use the `rtl:` variant.

A bare `ml-4` / `rounded-l-lg` / `text-left` with **neither** is the violation. Both fixes
are correct — recommend the one matching the project's existing convention.

The full find→fix table lives in `references/rtl-rules.md` — treat it as the source of truth.

## What to Scan For

Every directional category has both a logical fix and an `rtl:` fix:

| Bare (violation) | Logical fix | `rtl:` fix |
|---|---|---|
| `ml-*`, `mr-*` | `ms-*`, `me-*` | `rtl:mr-* rtl:ml-0`, `rtl:ml-* rtl:mr-0` |
| `pl-*`, `pr-*` | `ps-*`, `pe-*` | `rtl:pr-* rtl:pl-0`, `rtl:pl-* rtl:pr-0` |
| `rounded-l-*`, `rounded-r-*` | `rounded-s-*`, `rounded-e-*` | `rtl:rounded-l-none rtl:rounded-r-*`, etc. |
| `rounded-tl/tr/bl/br-*` | `rounded-ss/se/es/ee-*` | `rtl:rounded-tl-none rtl:rounded-tr-*`, etc. |
| `left-*`, `right-*` | `start-*`, `end-*` | `rtl:left-auto rtl:right-*`, `rtl:right-auto rtl:left-*` |
| `text-left`, `text-right` | `text-start`, `text-end` | `rtl:text-right`, `rtl:text-left` |
| `border-l`, `border-r` | `border-s`, `border-e` | `rtl:border-l-0 rtl:border-r`, `rtl:border-r-0 rtl:border-l` |

> The logical fix auto-flips with `dir="rtl"`. The `rtl:` fix must include **both** halves
> (reset + mirror); omitting one silently breaks a direction.

## `rtl:`-Only (No Logical Equivalent)

Always use the `rtl:` variant — no logical property exists:

```tsx
// Directional icons (arrows, chevrons) — prefer -scale-x-100 over rotate-180
<ChevronRight className="h-4 w-4 rtl:-scale-x-100" />
<ArrowLeft className="h-4 w-4 rtl:-scale-x-100" />

// Transform origins
origin-left → add rtl:origin-right
origin-right → add rtl:origin-left
```

`rtl:-scale-x-100` mirrors horizontally and preserves vertical orientation; `rtl:rotate-180`
also flips vertically, so reserve it for visually symmetric glyphs. Non-directional icons
(close, search, settings) must **not** flip. See `references/rtl-rules.md` for the full table.

## Common Mistakes (Do NOT Flag / Do NOT "Fix")

- **`rtl:flex-row-reverse` is almost always wrong.** When `dir="rtl"` is set, a `flex flex-row`
  row *already* lays its children out right-to-left. Adding `rtl:flex-row-reverse` double-reverses
  it back to LTR order — a bug, not a fix. Plain `flex-row` is correct in both directions. Only
  consider it when visual order must intentionally differ from source order in one direction (rare).
- Do not "fix" `gap-*`, `flex-row`, or `flex-col` — they follow document direction automatically.

## Safe Patterns (No Fix Needed)

These are fine without RTL counterparts:
- `mx-*`, `px-*` (both sides equal)
- `mt-*`, `mb-*`, `pt-*`, `pb-*` (vertical, not directional)
- `rounded-t-*`, `rounded-b-*` (vertical)
- `text-center` (no direction)
- `top-*`, `bottom-*` (vertical positioning)
- `flex-row` / `flex-col` (follow document direction automatically)
- Flexbox `gap-*` and CSS Grid gaps (handled by the browser)

## How to Scan

Grep the component tree for bare directional utilities, then triage each hit against the table
above and `references/rtl-rules.md`. Useful starting patterns (scope to `.tsx`/`.jsx` in `src/`):

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

For each match decide: swap to a logical utility (preferred), add an `rtl:` counterpart (when no
logical utility exists), or mark safe. Before reporting fixes as effective, confirm `dir` is set on
`<html>` by the i18n layer — logical utilities and `rtl:` variants are both inert without it.

## Report Format

Each issue shows both fix options so the reader can match their project's convention:

```markdown
## RTL Audit

### Issues
- `Component.tsx:15` — `ml-4` without RTL handling → use `ms-4` or `rtl:mr-4 rtl:ml-0`
- `Component.tsx:28` — `rounded-l-lg` without RTL handling → use `rounded-s-lg` or `rtl:rounded-l-none rtl:rounded-r-lg`
- `Component.tsx:42` — `ChevronRight` icon not flipping in RTL → add `rtl:-scale-x-100`
- `Component.tsx:55` — `text-left` without RTL handling → use `text-start` or `rtl:text-right`
- `Component.tsx:60` — `rtl:flex-row-reverse` double-reverses an already-mirrored row → remove it

### Summary
X directional issues found
```

## Auto-Fix

When the user confirms, apply the fixes automatically:
1. Swap bare directional utilities for their logical equivalents (or `rtl:` counterparts to match
   project convention).
2. Add `rtl:-scale-x-100` to directional icons that lack a flip.
3. Add `rtl:` overrides where no logical utility exists (transform origins).
4. Remove erroneous `rtl:flex-row-reverse` on rows that should follow direction.
