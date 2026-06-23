# RTL Rules

Single source of truth for right-to-left (RTL) directional styling. Referenced by
`forge:audit-rtl`, `forge:review-code`, `forge:create-component`, and `forge:figma-to-code`.

## The Rule

Directional styling must use logical properties (`ms`/`me`, `ps`/`pe`, `start`/`end`,
`rounded-s`/`rounded-e`, `border-s`/`border-e`, `text-start`/`text-end`) **or** an explicit
`rtl:` counterpart — never a bare directional class. For things with no logical equivalent
(icon flips, flex visual ordering, transform origins), use the `rtl:` variant.

A bare `ml-4` / `rounded-l-lg` / `text-left` with **neither** a logical property nor an
`rtl:` counterpart is the violation. Both fixes below are correct — pick one per project's
existing convention.

## Find → Fix

| Bare (violation) | Logical fix | `rtl:` fix |
|---|---|---|
| `ml-4` | `ms-4` | `rtl:mr-4 rtl:ml-0` |
| `mr-4` | `me-4` | `rtl:ml-4 rtl:mr-0` |
| `pl-4` | `ps-4` | `rtl:pr-4 rtl:pl-0` |
| `pr-4` | `pe-4` | `rtl:pl-4 rtl:pr-0` |
| `rounded-l-lg` | `rounded-s-lg` | `rtl:rounded-l-none rtl:rounded-r-lg` |
| `rounded-r-lg` | `rounded-e-lg` | `rtl:rounded-r-none rtl:rounded-l-lg` |
| `rounded-tl-lg` | `rounded-ss-lg` | `rtl:rounded-tl-none rtl:rounded-tr-lg` |
| `rounded-tr-lg` | `rounded-se-lg` | `rtl:rounded-tr-none rtl:rounded-tl-lg` |
| `rounded-bl-lg` | `rounded-es-lg` | `rtl:rounded-bl-none rtl:rounded-br-lg` |
| `rounded-br-lg` | `rounded-ee-lg` | `rtl:rounded-br-none rtl:rounded-bl-lg` |
| `left-0` | `start-0` | `rtl:left-auto rtl:right-0` |
| `right-0` | `end-0` | `rtl:right-auto rtl:left-0` |
| `text-left` | `text-start` | `rtl:text-right` |
| `text-right` | `text-end` | `rtl:text-left` |
| `border-l` | `border-s` | `rtl:border-l-0 rtl:border-r` |
| `border-r` | `border-e` | `rtl:border-r-0 rtl:border-l` |
| `border-l-2` | `border-s-2` | `rtl:border-l-0 rtl:border-r-2` |

> The logical fix auto-flips with `dir="rtl"` and needs no counterpart. The `rtl:` fix must
> include **both** halves (the reset + the mirrored value); omitting one silently breaks one
> direction.

## `rtl:`-Only (No Logical Equivalent)

These have no logical property — always use the `rtl:` variant:

- **Directional icons** (arrows, chevrons): `rtl:rotate-180`
  ```tsx
  <ChevronRight className="h-4 w-4 rtl:rotate-180" />
  <ArrowLeft className="h-4 w-4 rtl:rotate-180" />
  ```
- **Flex visual ordering** (when content order is directional): `rtl:flex-row-reverse`
  ```tsx
  className="flex flex-row rtl:flex-row-reverse"
  ```
- **Transform origins**: `origin-left` → add `rtl:origin-right`; `origin-right` → add `rtl:origin-left`

## Safe Patterns (No Fix Needed)

- `mx-*`, `px-*` (both sides equal)
- `mt-*`, `mb-*`, `pt-*`, `pb-*` (vertical, not directional)
- `rounded-t-*`, `rounded-b-*` (vertical)
- `text-center` (no direction)
- Flexbox `gap-*` and CSS Grid gaps (handled by the browser)
