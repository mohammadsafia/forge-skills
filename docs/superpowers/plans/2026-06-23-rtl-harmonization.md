# RTL Guidance Harmonization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make RTL guidance consistent across forge-skills by adding a single source-of-truth reference file and aligning every skill that mentions RTL to one canonical rule.

**Architecture:** Content-only markdown changes. Create one shared reference (`skills/audit-rtl/references/rtl-rules.md`), rewrite `audit-rtl/SKILL.md` to present both fix strategies consistently and point at the reference, then align four consumer touchpoints (`figma-to-code`, `CLAUDE.md`, `review-code`, `create-component`) to the same wording.

**Tech Stack:** Markdown only. No build, no tests, no runtime. Verification is by `grep` and visual review. Target stack the content describes: React 19, TypeScript 5, Tailwind CSS 4.

## Global Constraints

- All skill `name:` fields keep the `forge:` namespace prefix — copied verbatim, never altered.
- All examples must be generic — no project-specific names, paths, or references.
- Both RTL strategies stay valid: logical properties **and** `rtl:` counterparts. Do not crown a single winner.
- Reference files hold factual/templated content (tables, rules); procedural workflow stays in SKILL.md.
- The canonical rule statement (defined in Task 1) is reused verbatim where practical across all files.

---

### Task 1: Create the shared RTL reference

**Files:**
- Create: `skills/audit-rtl/references/rtl-rules.md`

**Interfaces:**
- Produces: a reference file at `skills/audit-rtl/references/rtl-rules.md` containing (a) the canonical rule statement, (b) a complete find→fix table with `Bare | Logical fix | rtl: fix` columns, (c) an `rtl:`-only section, (d) a safe-patterns list. Tasks 2–3 link to this path.

- [ ] **Step 1: Create the reference file**

Create `skills/audit-rtl/references/rtl-rules.md` with this exact content:

```markdown
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
```

- [ ] **Step 2: Verify the file exists and the table is complete**

Run: `grep -c "rtl:" skills/audit-rtl/references/rtl-rules.md`
Expected: a count of 15 or more (every find→fix row plus the `rtl:`-only section).

Run: `grep -E "rounded-ss-lg|border-s-2|text-start" skills/audit-rtl/references/rtl-rules.md`
Expected: all three logical-property classes are present (one per matching line).

- [ ] **Step 3: Commit**

```bash
git add skills/audit-rtl/references/rtl-rules.md
git commit -m "Add shared rtl-rules reference for audit-rtl"
```

---

### Task 2: Rewrite audit-rtl SKILL.md

**Files:**
- Modify: `skills/audit-rtl/SKILL.md` (full body replacement below the frontmatter)

**Interfaces:**
- Consumes: `references/rtl-rules.md` from Task 1 (linked inline).
- Produces: an `audit-rtl` SKILL.md that presents both fix strategies for every directional category and points at the reference. Task 3's `review-code` report example stays consistent with this skill's report format.

- [ ] **Step 1: Replace the SKILL.md body**

Replace the entire contents of `skills/audit-rtl/SKILL.md` with this exact content (frontmatter unchanged):

```markdown
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
```

- [ ] **Step 2: Verify both strategies appear and the reference is linked**

Run: `grep -n "references/rtl-rules.md" skills/audit-rtl/SKILL.md`
Expected: at least one match (the inline pointer).

Run: `grep -E "rounded-s-\*|text-start|border-s" skills/audit-rtl/SKILL.md`
Expected: logical-property fixes now appear for radius, text, and border categories (not just margin/padding).

Run: `grep -n "name: forge:audit-rtl" skills/audit-rtl/SKILL.md`
Expected: 1 match (frontmatter prefix preserved).

- [ ] **Step 3: Commit**

```bash
git add skills/audit-rtl/SKILL.md
git commit -m "Rewrite audit-rtl to present both RTL fix strategies consistently"
```

---

### Task 3: Align consumer touchpoints to the canonical rule

**Files:**
- Modify: `skills/figma-to-code/SKILL.md:122`
- Modify: `CLAUDE.md` (Key Standards section — "RTL via `rtl:` prefix" line)
- Modify: `skills/review-code/SKILL.md:290-293`
- Modify: `skills/create-component/references/quality-checklist.md:25`

**Interfaces:**
- Consumes: `skills/audit-rtl/references/rtl-rules.md` (Task 1) — linked from `figma-to-code` and `review-code`.
- Produces: consistent "logical properties or `rtl:` prefix" wording across all four files. No behavioral change to `review-code`'s scan list beyond wording + a pointer.

- [ ] **Step 1: Update figma-to-code**

In `skills/figma-to-code/SKILL.md`, replace line 122:

```markdown
- Add `rtl:` prefix for directional styles
```

with:

```markdown
- Use logical properties (`ms`/`me`, `start`/`end`, …) or an `rtl:` prefix for directional styles (see `audit-rtl/references/rtl-rules.md`)
```

- [ ] **Step 2: Update CLAUDE.md**

In `CLAUDE.md`, find this fragment inside the "Key Standards Enforced Across Skills" section:

```markdown
Theme-aware tokens only (no hardcoded colors like `bg-white`); Tailwind spacing scale; mobile-first; RTL via `rtl:` prefix
```

Replace the `RTL via `rtl:` prefix` portion so the line reads:

```markdown
Theme-aware tokens only (no hardcoded colors like `bg-white`); Tailwind spacing scale; mobile-first; RTL via logical properties (`ms`/`me`, `start`/`end`, …) or `rtl:` prefix
```

- [ ] **Step 3: Update review-code scan list**

In `skills/review-code/SKILL.md`, replace lines 290–293:

```markdown
   - Directional border-radius without RTL mirroring
   - `left-*`/`right-*` positioning without RTL counterpart
   - `text-left`/`text-right` without RTL counterpart
   - Directional borders without RTL counterpart
```

with:

```markdown
   - Directional border-radius without RTL handling (logical `rounded-s-*`/`rounded-e-*` or `rtl:` mirroring)
   - `left-*`/`right-*` positioning without RTL handling (logical `start-*`/`end-*` or `rtl:` counterpart)
   - `text-left`/`text-right` without RTL handling (logical `text-start`/`text-end` or `rtl:` counterpart)
   - Directional borders without RTL handling (logical `border-s`/`border-e` or `rtl:` counterpart)
```

Then, on the `forge:audit-rtl` heading line (`3. **RTL audit** (`forge:audit-rtl`):`), append a reference pointer at the end so it reads:

```markdown
3. **RTL audit** (`forge:audit-rtl`) — see `audit-rtl/references/rtl-rules.md`:
```

- [ ] **Step 4: Update create-component checklist**

In `skills/create-component/references/quality-checklist.md`, replace line 25:

```markdown
- [ ] Border radius uses `rtl:` mirroring where directional
```

with:

```markdown
- [ ] Directional border radius uses logical properties (`rounded-s-*`/`rounded-e-*`) or `rtl:` mirroring
```

- [ ] **Step 5: Verify the canonical wording landed in all four files**

Run: `grep -rn "logical propert" CLAUDE.md skills/figma-to-code/SKILL.md skills/review-code/SKILL.md skills/create-component/references/quality-checklist.md`
Expected: at least one match in each of the four files.

Run: `grep -rn "rtl-rules.md" skills/figma-to-code/SKILL.md skills/review-code/SKILL.md`
Expected: one pointer match in each of the two files.

Run: `grep -n "RTL via .rtl: prefix$" CLAUDE.md`
Expected: no match (the bare-prefix wording is gone).

- [ ] **Step 6: Commit**

```bash
git add CLAUDE.md skills/figma-to-code/SKILL.md skills/review-code/SKILL.md skills/create-component/references/quality-checklist.md
git commit -m "Align RTL wording across skills and CLAUDE.md to canonical rule"
```

---

## Self-Review

**Spec coverage** (checked against `2026-06-23-audit-rtl-harmonization-design.md`):

- Canonical rule → Task 1 (defined) + Tasks 2–3 (propagated). ✓
- New `references/rtl-rules.md` → Task 1. ✓
- `audit-rtl` rewrite with both fixes per category → Task 2. ✓
- `figma-to-code` line 122 → Task 3 Step 1. ✓
- `CLAUDE.md` Key Standards → Task 3 Step 2. ✓
- `review-code` wording + pointer → Task 3 Step 3. ✓
- `create-component` checklist → Task 3 Step 4. ✓
- Verification by review/grep (content-only repo) → each task's verify step. ✓
- Non-goals respected: both strategies stay valid; no target-app code touched; no unrelated refactor. ✓

**Placeholder scan:** No TBD/TODO/"handle appropriately" — every edit shows exact before/after content. ✓

**Type/name consistency:** Logical-property class names (`rounded-ss/se/es/ee`, `border-s/border-e`, `text-start/text-end`, `start-*/end-*`) are identical between the reference (Task 1), the SKILL rewrite (Task 2), and the consumer edits (Task 3). The reference path `skills/audit-rtl/references/rtl-rules.md` is linked consistently as `references/rtl-rules.md` (from audit-rtl) and `audit-rtl/references/rtl-rules.md` (from sibling skills). ✓
```

