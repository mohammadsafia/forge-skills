---
name: forge:refactor-to-standards
description: "Refactor existing code to comply with project coding standards — fix imports, types, patterns, and styling. Use when the user wants to bring code into compliance, fix violations, standardize code, or says 'refactor to standards', 'fix this file', 'make this compliant', 'clean up this code', 'standardize imports', 'apply conventions'. Triggers whenever existing code needs to be brought in line with project rules."
---

# Refactor to Standards

Systematically transform code to comply with project conventions.

## Step 1 — Identify Scope

Determine what to refactor:
- A single file
- A feature directory
- A specific violation type across the codebase

## Step 2 — Scan for Violations

Scan each file in scope against `_shared/code-standards.md` (all 12 categories).
Use `references/transformation-catalog.md` for before/after code examples of common transformations.

Check categories:
1. Imports (aliases, barrels, ordering)
2. Types (type vs interface, DTOs, any)
3. API layer (handlers, queryKeys)
4. React Query hooks (return types, invalidation)
5. Components (pages vs views, compound pattern, size)
6. Conditional rendering (Conditional.If)
7. Forms (FormProvider, field wrappers)
8. Styling (tokens, cn(), scale values)
9. File organization (kebab-case folders, barrels)
10. Component internal order (hooks → state → memo → callbacks → effects → JSX)
11. Date/time & i18n (useDate, useAppTranslation)
12. General (no TODOs, handle* naming, lazy routes)

## Step 3 — Apply Transformations

See `references/transformation-catalog.md` for before/after examples of each transformation.

Apply changes in this order (to minimize cascading issues):
1. Fix imports first (reordering, barrels, aliases)
2. Fix types (interface → type, add missing types)
3. Fix patterns (Conditional.If, FormProvider, hooks)
4. Fix styling (tokens, spacing, cn())
5. Fix structure (rename folders, update barrels)

## Step 4 — Verify

After refactoring:
- Run `npm run build` to verify TypeScript compilation
- Run `npm run lint` to verify ESLint compliance
- Ensure no functional changes were introduced

## Rules

See `_shared/code-standards.md` for the complete rule set. Refactoring-specific rules:

- Fix violations in priority order: Errors first, then Warnings
- Preserve existing behavior — refactoring must not change functionality
- Run the build after changes to verify no regressions
- Use `references/transformation-catalog.md` for correct before/after patterns

## Reference Files

- `references/transformation-catalog.md` — Before/after for each transformation
