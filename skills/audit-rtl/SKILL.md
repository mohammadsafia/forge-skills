---
name: forge:audit-rtl
description: "Audit components for RTL (right-to-left) support — find directional styling issues. Use when the user mentions RTL, Arabic, bidirectional layout, or says 'check RTL', 'does this work in Arabic', 'fix RTL', 'audit bidirectional'. Important for projects supporting Arabic or Hebrew."
---

# Audit RTL

Find what breaks when the interface runs right-to-left: directional styling, text whose direction comes from its
content, and icons. A code scan finds only part of it; say what was not seen rendered.

## Step 1 — Read the Project's Direction Setup

- How direction is set (often `dir` on `<html>` from the language) and whether the styling uses logical utilities.
- If `kit.lock.json` exists at the repository root, the app is built on the RSK kit: read `../_shared/rsk-kit.md`
  section 7 and the kit's `src/component-docs/guides/rtl-i18n.mdx`. The kit's components are already direction-aware;
  audit the app's own code (`src/pages`, `src/views`, `src/layouts`) and do not override kit components.

## Step 2 — Directional Styling

Fix a physical class by replacing it with its logical one. Do not add `rtl:` overrides beside a physical class: that
doubles the rules and drifts.

| Physical | Logical |
|---|---|
| `ml-*`, `mr-*`, `pl-*`, `pr-*` | `ms-*`, `me-*`, `ps-*`, `pe-*` |
| `left-*`, `right-*` | `start-*`, `end-*` |
| `text-left`, `text-right` | `text-start`, `text-end` |
| `border-l*`, `border-r*` | `border-s*`, `border-e*` |
| `rounded-l*`, `rounded-r*`, `rounded-tl*` … | `rounded-s*`, `rounded-e*`, `rounded-ss*` … |
| `origin-left`, `origin-right` | no logical utility exists: here only, add the mirror (`origin-left rtl:origin-right`) |
| `flex-row-reverse` used to mirror | remove it: `flex-row` already follows the direction |

Report an existing `rtl:` override that fights a logical class (for example `ms-4 rtl:me-4`, which moves the space to
the wrong side in Arabic) as a defect.

Safe without change: `mx-*`, `px-*`, vertical spacing, `gap-*`, `text-center`, grid and flex gaps.

## Step 3 — Icons

Icons that mean back, forward, next or previous mirror in RTL. Use the project's way (RSK: `rtl:-scale-x-100`). Icons
without a direction (search, bell, check, a clock) must not mirror. A chevron that opens a menu downwards is not
directional.

## Step 4 — Text Whose Direction Comes From Its Content

Layout direction comes from the language; the direction of a value comes from the value. Check each place where text
the app did not write appears:

| Content | Do |
|---|---|
| Input a person types in either language (names, company, notes) | `dir="auto"` on the `input`/`textarea`, so typing Arabic in the English UI (and the reverse) reads correctly |
| A value from data shown inside a translated sentence (`"{{name}} was added"`) | wrap the value in `<bdi>` (or a `span` with `dir="auto"`), so a Latin name does not reorder the Arabic sentence around it |
| A list or table cell holding such a value | `dir="auto"` on the cell content |
| Identifiers, codes, emails, URLs, phone numbers, amounts, dates, times | `dir="ltr"` (RSK: also `tabular-nums`); digits stay Western in both languages when the project says so |
| Text whose language is known and differs from the page | `lang` on the element (`lang="en"` on an English-only field on an Arabic page) |

## Step 5 — The Project's Own Guards

Run the project's checks rather than repeating them by hand. In RSK: `vp test tests/design-system` (forbidden patterns,
code standards) and `tests/i18n/parity.test.ts`. Note when the code you audit is outside the code-standards test's
`SCOPE` list.

## Step 6 — What a Scan Cannot See

A code scan does not show: popovers and menus that open on the wrong side, a picker whose columns read in the wrong
order, text that overflows because Arabic runs longer, numbers that reorder, or truncation that cuts the wrong end. When
a browser is available, open each changed screen in Arabic at desktop and phone width and look. When it is not, list
the screens a person must check in Arabic.

## Report Format

```markdown
## RTL Audit

### Defects
- `OrderPage.tsx:15` — `ml-4` → `ms-4`
- `OrderPage.tsx:30` — `ms-2 rtl:me-2` fights the logical class → keep `ms-2`
- `GuestList.tsx:42` — guest name inside a translated sentence without `<bdi>`
- `NoteField.tsx:12` — free-text field without `dir="auto"`

### Checked by the project's tests
- forbidden patterns, code standards (in SCOPE: yes/no), locale parity

### Not seen rendered (check in Arabic at desktop and phone width)
- …

### Summary
X defects
```
