# RSK Skill Extraction Design

**Date:** 2026-06-23
**Branch:** skill-enhancements
**Author:** Osama Al-Kanash
**Reviewer:** Mohammad Safia
**Source repo:** `https://github.com/mohammadsafia/rsk/tree/main` (react-start-kit v2.0.0)

## Overview

Replace forge-skills' reference files with content derived from the lead's production starter kit (`rsk`). Skills stop embedding duplicated rules and code templates. Instead, they point to a shared standards doc and instruct Claude to scan real component code at specific file paths.

## Goals

1. Eliminate the 14 consistency issues caused by rules duplicated across skills
2. Make forge-skills reference the real codebase (rsk) as source of truth
3. Keep skill workflow structure intact — only content changes

## Architecture

### Shared reference
- Copy rsk's `docs/CODE_STANDARDS.md` (12 categories, 171 lines) into `skills/_shared/code-standards.md`
- Every skill's Rules section references this shared file instead of embedding its own rules
- This single file replaces the rules portions of: `api-rules.md`, `component-rules.md`, `styling-rules.md`, `naming-rules.md`, `type-rules.md`, `common-violations.md`, `transformation-catalog.md`

### Scan-the-real-code pattern
- Each SKILL.md's "Scan Existing Patterns" step lists specific file paths in the project for Claude to read before generating code
- Generic quick-reference examples stay in skill-specific reference files for convenience
- But the real component code is the authoritative source

### Skill-specific reference files
- Files with templates/examples unique to a skill domain are kept but slimmed down:
  - `create-table/references/column-types.md` — column type examples (kept)
  - `create-table/references/search-pagination.md` — search/pagination patterns (kept)
  - `create-form/references/form-pattern.md` — form template (kept, updated with real form component names)
  - `create-form/references/validation-patterns.md` — Zod patterns (kept)
  - `create-component/references/cva-pattern.md` — CVA examples (kept)
  - `create-component/references/compound-pattern.md` — compound component examples (kept)
  - `create-api/references/handler-pattern.md` — handler template (kept)
  - `create-api/references/query-hook-pattern.md` — hook template (kept)
  - `create-api/references/dto-conventions.md` — DTO naming (kept)
  - `figma-to-code/references/design-tokens.md` — token mapping (kept)
  - `figma-to-code/references/spacing-scale.md` — spacing table (kept)

## What stays

- All 23 `forge:` skill names and SKILL.md frontmatter
- Skill workflow steps (gather info → scan → generate → checklist)
- Skills with no reference files (changelog, i18n-sync, add-translations, debug-build, etc.)
- The BUG fixes already applied in the previous commit

## What gets removed

Duplicated rules in reference files already covered by CODE_STANDARDS.md:

| File | What's removed |
|------|---------------|
| `review-code/references/api-rules.md` | Rules portion (handler pattern rules, query hook rules, state management rules) |
| `review-code/references/component-rules.md` | Rules portion (component order, conditional rendering rules) |
| `review-code/references/styling-rules.md` | Rules portion (token rules, cn() rules) |
| `review-code/references/naming-rules.md` | Rules portion (file/folder naming) |
| `review-code/references/type-rules.md` | Rules portion (type vs interface, DTO naming) |
| `refactor-to-standards/references/common-violations.md` | Entire file — rebuilt from CODE_STANDARDS.md |
| `refactor-to-standards/references/transformation-catalog.md` | Rules portion |

**Decision per file:**
- If the file is 100% rules with no code templates → delete it entirely (e.g., `naming-rules.md`, `type-rules.md`)
- If the file has rules mixed with code templates → remove the rules, keep only templates/examples (e.g., `api-rules.md` keeps the handler code template, loses the rules table)

## What gets updated

### Every SKILL.md
- Rules section → `See _shared/code-standards.md for all project rules`
- "Scan Existing Patterns" step → add real file paths to read

### Scan paths per skill

| Skill | Real files to scan |
|-------|-------------------|
| create-table | `src/components/tables/data-table/DataTable.tsx`, `DataTableContent.tsx`, `DataTablePagination.tsx`, `DataTableToolbar.tsx`, `data-table-filters/` |
| create-form | `src/components/forms/form-container/FormContainer.tsx`, `form-input/FormInput.tsx`, `form-select/FormSelect.tsx`, `form-checkbox/FormCheckbox.tsx`, `form-date-picker/FormDatePicker.tsx` |
| create-component | `src/components/shared/` — scan for compound pattern: `PrimeCard`, `CollapsibleCard`, `PrimeDialog` |
| create-api | `src/api/handlers/`, `src/api/config/`, `src/lib/hooks/queries/`, `src/lib/hooks/mutations/` |
| create-page | `src/pages/`, `src/routes/` |
| scaffold-feature | All of the above combined |
| figma-to-code | `src/index.css` (tokens), `src/components/ui/` (base components) |
| create-context | `src/lib/contexts/` |
| review-code | `docs/CODE_STANDARDS.md` as the rule source |
| refactor-to-standards | `docs/CODE_STANDARDS.md` as the violation checklist source |
| add-icon | `src/assets/icons/` |
| extract-component | `src/components/shared/` — scan before extracting |

### Skills that need no scan paths (workflow-only)
git-workflow, changelog, i18n-sync, add-translations, debug-build, document-component, audit-a11y, audit-dark-mode, audit-imports, audit-rtl, migrate-endpoint, forge

## Delivery

1. Create `skills/_shared/code-standards.md` from rsk's CODE_STANDARDS.md
2. Update each SKILL.md's scan step and rules section
3. Slim down or remove reference files that duplicate the shared standards
4. One PR on `skill-enhancements` branch for lead review
