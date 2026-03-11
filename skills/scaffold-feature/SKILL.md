---
name: forge:scaffold-feature
description: "Scaffold a complete feature with all necessary files — page, DTOs, handler, hooks, views, routes. Use when the user wants to create a full feature from scratch, scaffold an entire module, bootstrap a new feature, or says 'scaffold feature', 'create full feature', 'bootstrap module', 'new feature for', 'set up everything for'. Triggers when the user needs the complete vertical slice for a new feature."
---

# Scaffold Feature

Generate the complete file structure for a new feature: DTOs → handler → hooks → page → views → routes.

## Step 1 — Gather Information

Ask the user if not provided:
- **Feature name** (e.g., "communities", "orders", "subscriptions")
- **Entity name** (PascalCase: "Community", "Order")
- **API endpoints** (base URL pattern)
- **CRUD operations** needed (list, detail, create, update, delete)
- **Route path** (e.g., `/communities`)
- **Layout**: MainLayout or DashboardLayout
- **Protected?**: AuthGuard roles

## Step 2 — Scan Existing Patterns

Read one complete existing feature to mirror the exact structure:
1. A handler in `src/api/handlers/`
2. Query hooks in `src/lib/hooks/queries/`
3. Mutation hooks in `src/lib/hooks/mutations/`
4. A page in `src/pages/`
5. View components in `src/views/`

See `references/folder-structure.md` for the complete scaffold template.

## Step 3 — Generate Files (in order)

### Layer 1: Types
1. `src/types/api/EntityNameDto.ts` — All DTOs
2. Update `src/types/api/index.ts` — Barrel export

### Layer 2: API
3. Add endpoints to `src/api/config/ApiEndpoints.ts`
4. `src/api/handlers/entity-name.ts` — Handler with typed requests
5. Update `src/api/handlers/index.ts` — Barrel export

### Layer 3: Hooks
6. `src/lib/hooks/queries/useEntityNameQuery.ts` — Query hooks
7. `src/lib/hooks/mutations/useEntityNameMutation.ts` — Mutation hooks

### Layer 4: UI
8. `src/pages/<feature>/<FeaturePage>.tsx` — List page
9. `src/pages/<feature>/<FeatureDetailPage>.tsx` — Detail page (if needed)
10. `src/views/<feature>/` — Reusable view components

### Layer 5: Routing
11. Update `src/routes/index.ts` — Route config + lazy imports

### Layer 6: i18n (if needed)
12. Add translation keys to `src/locales/en.json` and `src/locales/ar.json`

## Rules

- Generate files bottom-up (types → API → hooks → UI → routes)
- Each layer must compile before moving to the next
- All folder names: **kebab-case**
- All component files: **PascalCase**
- Follow every convention from the project's CLAUDE.md
- No placeholders or TODOs — produce complete code
- Run through the checklist at the end

## Checklist

- [ ] DTOs follow naming conventions (ForReadDto, ForCreateDto, etc.)
- [ ] DTOs exported through barrel
- [ ] Endpoints added as plain strings
- [ ] Handler: functions above, string queryKey, function reference
- [ ] Query hooks: no explicit return type, queryKey in array
- [ ] Mutation hooks: invalidate correct queries, toast on success/error
- [ ] Page: follows internal code order
- [ ] Conditional.If used for all conditional rendering
- [ ] Imports follow correct order and use barrels
- [ ] Routes use lazy loading and correct layout/guard

## Reference Files

- `references/folder-structure.md` — Complete feature file structure
