---
name: forge:migrate-endpoint
description: "Update an existing API endpoint — change URL, update DTOs, fix handler, and propagate through hooks and components. Use when the user needs to update an API endpoint, change an endpoint URL, migrate API response shape, or says 'update endpoint', 'API changed', 'backend changed the response', 'migrate endpoint', 'endpoint URL changed'. Triggers whenever an existing API integration needs to be updated due to backend changes."
---

# Migrate Endpoint

Update an existing API endpoint and propagate changes through the entire chain.

## Step 1 — Understand the Change

Ask the user:
- **What changed?** URL path, request payload, response shape, HTTP method
- **Which endpoint?** Entity name and operation (list, detail, create, update, delete)
- **New contract**: updated URL, fields added/removed/renamed, type changes

## Step 2 — Trace the Chain

Find all files that need updating by tracing the dependency chain:

```
ApiEndpoints.ts → handler → query/mutation hook → component/page
```

1. `src/api/config/ApiEndpoints.ts` — endpoint URL
2. `src/types/api/EntityDto.ts` — DTO types
3. `src/api/handlers/entity.ts` — handler request functions
4. `src/lib/hooks/queries/` — query hooks
5. `src/lib/hooks/mutations/` — mutation hooks
6. `src/pages/` and `src/views/` — consuming components

## Step 3 — Apply Changes (Bottom-Up)

### 3a. Update DTOs

If the response shape changed:
- Update or add fields in the DTO types
- Update the barrel export if new types were added
- Mark removed fields as optional first, then remove after verifying no consumers depend on them

### 3b. Update ApiEndpoints

If the URL changed:
```typescript
// Before
ENTITY: { LIST: '/api/v1/old-path' }

// After
ENTITY: { LIST: '/api/v1/new-path' }
```

### 3c. Update Handler

If request/response types changed:
- Update function signatures
- Update generic type parameters on HttpClient calls

### 3d. Update Hooks

If the handler interface changed:
- Update queryFn/mutationFn parameters
- Check if queryKey needs updating
- Verify invalidation still targets correct queries

### 3e. Update Consumers

If DTO field names changed:
- Find all components using the old field names
- Update property access
- Check conditional rendering that depends on these fields

## Step 4 — Verify

- Run `npm run build` to catch type errors
- Search for old field names / URLs to ensure nothing was missed
- Check that list, detail, create, update, and delete still work

## Rules

- Always update bottom-up (types → handler → hooks → UI)
- Never skip the DTO update — type safety catches consumer issues
- If a field was removed, search the entire codebase for references
- If a field was renamed, use find-and-replace scoped to the entity
- Keep backward compatibility notes if the migration is gradual
