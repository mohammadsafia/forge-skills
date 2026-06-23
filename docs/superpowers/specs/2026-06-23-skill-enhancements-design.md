# Skill Enhancements Design

**Date:** 2026-06-23
**Branch:** skill-enhancements
**Author:** [Osama Al-Kanash]
**Reviewer:** Mohammad Safia

## Overview

Reviewed all 23 forge-skills for correctness, consistency, and completeness. Found 45 issues across 3 severity levels. This document describes every proposed change grouped into categories for lead approval.

## Already Applied: BUG Fixes (7 items)

These fixes correct patterns that would produce broken or non-compliant code. They are already applied to the working tree.

| # | Skill | File | Fix |
|---|-------|------|-----|
| 1 | create-api | `references/query-hook-pattern.md` | Toast messages now use `t()` translation keys instead of hardcoded English + added missing `import type` for DTOs |
| 2 | create-component | `references/cva-pattern.md` | Replaced hardcoded palette colors (`bg-blue-50`, `text-blue-700`, `bg-error-600`) with project semantic tokens (`bg-destructive`, `text-destructive-foreground`) + renamed `error` variant to `destructive` |
| 3 | create-form | `references/form-pattern.md` | Added `Conditional.If` guard around Edit Form's optional Cancel button (matching the Create Form pattern in the same file) |
| 4 | create-form | `references/validation-patterns.md` | All Zod validation messages now use `t()` translation keys + added i18n guidance note at top of section |
| 5 | scaffold-feature | `references/folder-structure.md` | Fixed handler export casing from `camelCase` (`communityHandler`) to `PascalCase` (`CommunityHandler`) — now matches create-api's handler-pattern.md |
| 6 | review-code | `references/api-rules.md` | Added `onError` + `toast` + `useAppTranslation` to the "CORRECT" mutation example — it no longer contradicts its own rule on line 116 |
| 7 | figma-to-code | `references/design-tokens.md` | Added dark-mode safety caveat to gray scale section + "Preferred Semantic Alternative" column |
| 8 | create-table | `SKILL.md` + all references | Kept columns as plain `const` array (hooks like `useDate` go in small cell components like `DateCell`), fixed hooks violation in date column, replaced placeholder comments with real skeleton/empty state, added `data-slot`, fixed `text-error-600` to `text-destructive`, changed `mr-2` to `me-2` for RTL, added `aria-label` on search |

## Category 1: Consistency Fixes (14 items) — Needs Lead Approval

These fix cases where two skills contradict each other or a skill contradicts its own reference files.

| # | Skills Involved | Conflict | Proposed Fix |
|---|----------------|----------|-------------|
| 1 | figma-to-code `SKILL.md:114` vs `component-checklist.md:39` | Component code order: SKILL.md has 9 steps, checklist collapses to 6 | Align checklist to the full 9-step order (hooks → context → shared hooks → queries → state → memo → callbacks → effects → JSX) |
| 2 | figma-to-code `SKILL.md:127` + `checklist:56` vs `design-tokens.md` | `ring-tokens-primary` used in skill and checklist but not listed in token table | Add `ring-tokens-primary` entry to design-tokens.md token system table |
| 3 | refactor-to-standards `transformation-catalog.md` | Import order example shows only 4 groups instead of full 8 | Expand example to all 8 import groups (React → third-party → UI → shared → contexts/hooks → utils → icons → types) |
| 4 | audit-dark-mode `SKILL.md:35-36` | Doesn't distinguish Tailwind's built-in `gray-*` from project's custom `gray-*` | Add explicit note: "The project defines its own `gray-*` scale in `src/index.css` — these are NOT Tailwind's default gray palette" |
| 5 | audit-rtl `SKILL.md:15-18` | Logical properties (`ms-*`/`me-*`) and `rtl:` overrides presented as equal options | Mark logical properties as the primary fix, `rtl:` overrides as fallback only |
| 6 | audit-rtl `SKILL.md:24-29` | Border-radius fix uses Tailwind 3 pattern (`rtl:rounded-l-none`) | Update to Tailwind 4 logical utilities (`rounded-ss-*`, `rounded-se-*`, `rounded-es-*`, `rounded-ee-*`) |
| 7 | audit-rtl `SKILL.md:95` | Report example shows redundant `rtl:ml-0` alongside `ms-4` | Remove the redundant `rtl:` fallback from the example output |
| 8 | review-code `SKILL.md:99` vs `api-rules.md` state table | SKILL.md mentions `nuqs` for URL state, api-rules.md state management table omits it | Add `URL state → nuqs` row to api-rules.md state management table |
| 9 | review-code `SKILL.md:384` | Example report shows flat path `src/components/shared/OrderBadge.tsx` | Fix to `src/components/shared/order-badge/OrderBadge.tsx` per naming rules |
| 10 | create-api `SKILL.md` inline snippet | Mutation snippet in SKILL.md body has no `onError`, contradicting its own reference | Add `onError` to the inline snippet to match query-hook-pattern.md |
| 11 | create-page `routing-patterns.md` vs create-api `handler-pattern.md` | Two URL-building patterns: `.replace(':id', entityId)` vs `pathBuilder()` | Change routing-patterns.md to use `pathBuilder` consistently |
| 12 | debug-build `SKILL.md:73` | States `no-explicit-any` is "intentionally disabled" in ESLint — contradicts repo-wide `no any` standard in CLAUDE.md | Add caveat: "ESLint allows it, but the project standard still forbids `any` — fix types rather than relying on this escape hatch" |
| 13 | forge `SKILL.md` | `extract-component` placed in Layer 3 (creation skills) but is a refactoring skill | Move `extract-component` from the Skill Catalog to the Excluded Skills table with description: "Refactoring skill — invoke `forge:extract-component` directly" |
| 14 | forge `SKILL.md` | `migrate-endpoint` placed in Layer 1 (infrastructure) but is a refactoring skill per CLAUDE.md categories | Move `migrate-endpoint` from Layer 1 to the Excluded Skills table with description: "Refactoring skill — invoke `forge:migrate-endpoint` directly" |

**Decision needed:** Approve or reject this entire category.

## Category 2: Gap Fills (23 items) — Needs Lead Approval

These add missing guidance that the project standards require. No existing code is wrong — it's just absent.

### data-slot gaps (4 items)

| # | Skill | Gap | Proposed Fix |
|---|-------|-----|-------------|
| 1 | refactor-to-standards | `data-slot` not in the 20-item violation checklist | Add as violation #21: "Missing `data-slot` → add `data-slot` attribute to semantic elements" |
| 2 | extract-component | No `data-slot` on extracted component template | Add `data-slot` to the template's root element |
| 3 | add-icon | SVG template missing `data-slot="icon"` | Add `data-slot="icon"` to the `<svg>` element in the template |
| 4 | document-component | No prompt to document `data-slot` values | Add "Document available `data-slot` values for style targeting" to Guidelines template |

### i18n gaps (6 items)

| # | Skill | Gap | Proposed Fix |
|---|-------|-----|-------------|
| 5 | refactor-to-standards | Missing i18n violation category entirely | Add "Hardcoded English string → wrap with `t()`" to violations list |
| 6 | extract-component | No mention of i18n for extracted components | Add rule: "Ensure all visible strings in extracted component use `t()`" |
| 7 | figma-to-code | No instruction to wrap visible strings in `t()` | Add i18n step to the workflow: "Wrap all user-visible text with `t()` keys" |
| 8 | scaffold-feature | i18n marked "if needed", no checklist item | Make i18n step mandatory in Layer 6 + add "Translation keys added to en.json and ar.json" checklist item |
| 9 | migrate-endpoint | No mention of updating i18n keys when fields change | Add step: "Update translation keys in en.json/ar.json if renamed fields are used as i18n keys" |
| 10 | document-component | No prompt to document i18n behavior | Add "Note whether strings are pre-translated or use `t()` internally" to Guidelines template |

### a11y gaps (4 items)

| # | Skill | Gap | Proposed Fix |
|---|-------|-----|-------------|
| 11 | extract-component | No concrete `aria-*` guidance | Add: "Interactive extracted components must include `aria-label` or `aria-labelledby`" |
| 12 | add-icon | No `aria-hidden`/`aria-label` guidance for icon usage | Add usage section: decorative icons get `aria-hidden="true"`, standalone interactive icons get `aria-label` |
| 13 | create-page | No landmark roles in page template | Add `<main>` wrapper to page template's content area |
| 14 | document-component | No prompt to document aria props | Add `aria-label` / `aria-describedby` rows to the props table template |

### RTL gaps (2 items)

| # | Skill | Gap | Proposed Fix |
|---|-------|-----|-------------|
| 15 | refactor-to-standards | `mr-*`/`ml-*` → `me-*`/`ms-*` not in violation list | Add as RTL violation: "`mr-*`/`ml-*` → use logical `me-*`/`ms-*`" |
| 16 | figma-to-code `spacing-scale.md` | No logical-property reminder alongside spacing examples | Add note: "For directional spacing, use `ms-*`/`me-*`/`ps-*`/`pe-*` instead of `ml-*`/`mr-*`/`pl-*`/`pr-*`" |

### Incomplete template gaps (7 items)

| # | Skill | Gap | Proposed Fix |
|---|-------|-----|-------------|
| 17 | create-page `page-template.md` | 5 `Conditional.If` blocks contain only placeholder comments | Fill with real loading skeleton (`animate-pulse` divs), content wrapper, and empty state (icon + message) |
| 18 | create-form `form-pattern.md` | Both form templates have `{/* Use project's reusable form components here */}` | Add 2-3 example field components showing the FormField pattern |
| 19 | create-form `form-pattern.md` | Edit Form has no loading state while data fetches | Add `Conditional.If condition={!entity}` with loading skeleton before the form |
| 20 | migrate-endpoint `SKILL.md:34-38` | DTO update step is prose only — no code template | Add before/after DTO code example showing field rename/type change |
| 21 | scaffold-feature `folder-structure.md` | Called "complete scaffold template" but has only a folder tree | Change heading from "Complete Scaffold" to "Folder Structure" |
| 22 | document-component `SKILL.md:84-90` | Guidelines section is entirely placeholder bullets | Add concrete example of a completed Guidelines section with real content |
| 23 | audit-dark-mode `SKILL.md:41-43` | Inline style violations (`rgb()`, hex) shown without concrete replacement | Add specific mappings: `rgb(255,255,255)` → `bg-background`, `#000` → `text-foreground` |

**Decision needed:** Approve or reject this entire category.

## Delivery Plan

1. Lead reviews this document
2. Lead approves/rejects Category 1 (Consistency) and Category 2 (Gaps) independently
3. Approved changes are implemented on the `skill-enhancements` branch
4. One PR with all changes (BUG fixes + approved categories) for final review
