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
// Directional icons (arrows, chevrons)
<ChevronRight className="h-4 w-4 rtl:rotate-180" />
<ArrowLeft className="h-4 w-4 rtl:rotate-180" />

// Flex visual ordering, when content order is directional
className="flex flex-row rtl:flex-row-reverse"

// Transform origins
origin-left → add rtl:origin-right
origin-right → add rtl:origin-left
```

## Safe Patterns (No Fix Needed)

These are fine without RTL counterparts:
- `mx-*`, `px-*` (both sides equal)
- `mt-*`, `mb-*`, `pt-*`, `pb-*` (vertical, not directional)
- `rounded-t-*`, `rounded-b-*` (vertical)
- `text-center` (no direction)
- Flexbox `gap-*` (handled by browser)
- CSS Grid gaps (handled by browser)

## Report Format

Each issue shows both fix options so the reader can match their project's convention:

```markdown
## RTL Audit

### Issues
- `Component.tsx:15` — `ml-4` without RTL handling → use `ms-4` or `rtl:mr-4 rtl:ml-0`
- `Component.tsx:28` — `rounded-l-lg` without RTL handling → use `rounded-s-lg` or `rtl:rounded-l-none rtl:rounded-r-lg`
- `Component.tsx:42` — `ChevronRight` icon not flipping in RTL → add `rtl:rotate-180`
- `Component.tsx:55` — `text-left` without RTL handling → use `text-start` or `rtl:text-right`

### Summary
X directional issues found
```
