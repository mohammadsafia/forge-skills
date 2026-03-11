---
name: forge:debug-build
description: "Diagnose and fix TypeScript and Vite build failures systematically. Use when the user has a build error, type error, compilation failure, or says 'build failing', 'fix build', 'type error', 'tsc error', 'vite build broken', 'npm run build fails'. Triggers whenever the build process is broken and needs diagnosis."
---

# Debug Build

Systematically diagnose and fix TypeScript and Vite build failures.

## Step 1 — Run the Build

```bash
npm run build
```

This runs `tsc -b` (TypeScript type-check) followed by Vite bundling. Most failures happen at the `tsc -b` stage.

## Step 2 — Categorize Errors

### TypeScript Errors (tsc -b)

| Error Code | Category | Common Fix |
|------------|----------|-----------|
| TS2307 | Cannot find module | Fix import path, add to tsconfig paths |
| TS2339 | Property does not exist | Update DTO type, fix property name |
| TS2345 | Argument not assignable | Fix function argument types |
| TS2322 | Type not assignable | Fix variable/prop type mismatch |
| TS2554 | Expected N args, got M | Fix function call arguments |
| TS7006 | Parameter implicitly has any | Add explicit parameter types |
| TS6133 | Declared but never used | Remove unused import/variable |
| TS2305 | Module has no exported member | Fix barrel export, check export name |
| TS18046 | Variable is of type unknown | Add type assertion or narrowing |

### Vite Errors

| Error | Common Fix |
|-------|-----------|
| Failed to resolve import | Fix path alias in vite.config.ts |
| Module not found | Install missing dependency or fix import |
| Unexpected token | Fix JSX in .ts file (should be .tsx) |

## Step 3 — Fix Strategy

### For import errors (TS2307, TS2305)
1. Check if the module exists at the imported path
2. Verify barrel exports include the symbol
3. Check tsconfig path aliases match vite.config aliases
4. Verify the file extension (.ts vs .tsx)

### For type errors (TS2339, TS2345, TS2322)
1. Read the DTO/type definition
2. Compare with the actual usage
3. Fix the type or the usage (whichever is wrong)
4. Check if a recent API change updated the DTO

### For unused code (TS6133)
1. Remove unused imports
2. Remove unused variables (or prefix with `_` if intentionally unused)
3. Check if the symbol should actually be used somewhere

## Step 4 — Verify Fix

```bash
npm run build && npm run lint
```

Both must pass. Fix errors iteratively — some fixes reveal new errors.

## Common Gotchas

- `tsc -b` must pass before Vite bundles — all type errors first
- Production base path may differ from dev (`/`) — check `vite.config.ts` for `base` setting
- ESLint intentionally disables: `no-explicit-any`, `no-unused-vars`, `no-empty-object-type`, `no-unused-expressions`
- Path aliases must be defined in BOTH `tsconfig.json` and `vite.config.ts`
- `.tsx` extension required for files containing JSX
