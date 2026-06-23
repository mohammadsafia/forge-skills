# Design — Harmonize RTL Guidance Across Skills

**Date:** 2026-06-23
**Topic:** Fix `audit-rtl` inconsistencies and align RTL guidance across all skills
**Status:** Approved (design), pending spec review

## Problem

The `forge:audit-rtl` skill is internally inconsistent and out of step with the rest of
the repo's RTL guidance:

1. **Mixed strategies, inconsistently applied.** The "Find → Fix" tables offer
   *logical-property* fixes (`ms-*`, `me-*`, `ps-*`, `pe-*`) **only** for margins and
   padding. For border-radius, positioning, borders, and text-alignment it forces the
   verbose `rtl:` override pattern — even though Tailwind 4 has logical equivalents for
   all of them (`rounded-s-*`, `start-*`/`end-*`, `border-s`/`border-e`,
   `text-start`/`text-end`).

2. **`rtl:` overrides are bug-prone.** They require writing *both* halves
   (e.g. `rtl:rounded-l-none rtl:rounded-r-*`); forgetting one silently breaks LTR or RTL.

3. **No `references/` file.** Unlike `review-code` and `refactor-to-standards`,
   `audit-rtl` embeds its entire rule book inline, so other skills restate the same
   mappings instead of pointing at one source — which is how the drift started.

Repo-wide, RTL guidance is already mixed (not pure `rtl:` prefix):
- `review-code:289` flags directional classes "without RTL counterpart **or** logical
  properties"; its report example (`:361`) says "→ change to `ms-4`".
- `create-component` checklist (`:24`): "uses `rtl:` prefix **or** logical properties".
- `figma-to-code:122`: "Add `rtl:` prefix" (missing the logical-property half).
- `CLAUDE.md`: "RTL via `rtl:` prefix" (missing the logical-property half).

## Decisions

- **Scope:** Harmonize the whole repo (not just `audit-rtl`).
- **Strategy:** Keep **both** approaches acceptable. The fix is *consistent presentation*,
  not crowning a single winner. This is the lowest-churn option that removes the ambiguity.
- **References:** Add a shared `references/rtl-rules.md` as the single source of truth.

## The Canonical Rule

Every skill repeats this rule (verbatim where practical):

> Directional styling must use logical properties (`ms`/`me`, `ps`/`pe`, `start`/`end`,
> `rounded-s`/`rounded-e`, `border-s`/`border-e`, `text-start`/`text-end`) **or** an
> explicit `rtl:` counterpart — never a bare directional class. For things with no
> logical equivalent (icon flips, flex visual ordering, transform origins), use the
> `rtl:` variant.

A bare `ml-4` / `rounded-l-lg` / `text-left` with **neither** a logical property nor an
`rtl:` counterpart is the violation. Both fixes are correct.

## Changes

### 1. New file: `skills/audit-rtl/references/rtl-rules.md`

Single source of truth. Contains:

- The canonical rule statement.
- A **find → fix** table covering every directional category, showing both fixes:

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

- An **`rtl:`-only (no logical equivalent)** section:
  - Directional icons (arrows/chevrons): `rtl:rotate-180`
  - Flex visual ordering: `rtl:flex-row-reverse`
  - Transform origins: `origin-left` → `rtl:origin-right`, `origin-right` → `rtl:origin-left`
- A **safe patterns** list (no fix needed): `mx-*`, `px-*`, `mt/mb/pt/pb-*`,
  `rounded-t-*`/`rounded-b-*`, `text-center`, flex/grid `gap-*`.

### 2. `skills/audit-rtl/SKILL.md`

- Replace the per-category "Find → Fix" blocks with the canonical rule + a pointer to
  `references/rtl-rules.md`, keeping a condensed find→fix summary inline.
- Every directional category presents **both** fixes (logical + `rtl:`), consistently.
- Keep the "Safe Patterns" and "Report Format" sections; update the report example so each
  issue line shows both fix options (e.g. "`ml-4` → `ms-4` or `rtl:mr-4 rtl:ml-0`").

### 3. `skills/figma-to-code/SKILL.md` (line ~122)

Change "Add `rtl:` prefix for directional styles" → "Use logical properties or an `rtl:`
prefix for directional styles (see `audit-rtl/references/rtl-rules.md`)".

### 4. `CLAUDE.md` (Key Standards section)

Change "RTL via `rtl:` prefix" → "RTL via logical properties (`ms`/`me`, `start`/`end`, …)
or `rtl:` prefix".

### 5. `skills/review-code/SKILL.md` & `skills/create-component/`

Already say "or logical properties" — verify wording matches the canonical rule; add a
pointer to `rtl-rules.md` where mappings are restated. No behavioral change expected.

## Non-Goals

- Not changing the set of accepted approaches (both stay valid).
- Not touching generated/target application code — this is skill-content only.
- No unrelated refactoring of the affected skills.

## Verification

Since this is a content-only repo (no build/test/lint), verification is by review:

- [ ] Canonical rule statement appears consistently in all five touchpoints.
- [ ] `audit-rtl` shows both fix options for every directional category.
- [ ] `rtl-rules.md` find→fix table is complete and the logical/`rtl:` columns are correct.
- [ ] No bare directional class is recommended anywhere as a "fix".
- [ ] All examples remain generic (no project-specific names/paths).
- [ ] `forge:` namespace prefix preserved on all skill names.
