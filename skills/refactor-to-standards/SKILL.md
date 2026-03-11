---
name: refactor-to-standards
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

Read the target file(s) and check against all rules. See `references/common-violations.md` for the top violations.

### Check Categories

1. **Imports** — barrel violations, path aliases, import order, `import type`
2. **Types** — `interface` → `type`, missing types, `any` usage, DTO naming
3. **Patterns** — `&&` → `Conditional.If`, raw RHF → FormProvider, raw date formatting → hooks
4. **Styling** — hardcoded colors → tokens, arbitrary pixels → scale values, template literals → `cn()`
5. **API layer** — inline functions → handler pattern, array queryKeys → strings
6. **Structure** — PascalCase folders → kebab-case, deep imports → barrels

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

- Refactoring must be purely structural — no functional changes
- Every change must be traceable to a specific project rule
- If a change is ambiguous, ask the user
- Do not add features, comments, or documentation during refactoring
- Do not change variable names unless they violate naming conventions

## Reference Files

- `references/transformation-catalog.md` — Before/after for each transformation
- `references/common-violations.md` — Top 20 violations ranked by frequency
