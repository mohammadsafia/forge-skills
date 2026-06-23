---
name: forge:create-api
description: "Create a full API integration pipeline — endpoint, DTOs, handler, and React Query hook. Use when the user wants to add a new API endpoint, integrate a backend endpoint, create an API handler, set up a query/mutation hook, or says things like 'add endpoint for', 'create API for', 'integrate this endpoint', 'wire up the backend', 'add a new query hook'. Triggers whenever new backend integration work is needed."
---

# Create API

Generate the complete API integration chain: endpoint → DTOs → handler → React Query hook.

## Step 1 — Gather Information

Ask the user if not provided:
- **Entity name** (e.g., "Order", "Product", "Community")
- **HTTP methods** needed (GET list, GET by ID, POST create, PUT update, DELETE)
- **Endpoint URL pattern** (e.g., `/api/v1/orders`)
- **Request/response shape** (fields and types)

## Step 2 — Scan Existing Patterns

Before writing code, read:
1. Endpoint config: `src/api/config/ApiEndpoints.ts`
2. An existing handler in `src/api/handlers/` for the handler pattern
3. Query hooks in `src/lib/hooks/queries/` for the query hook pattern
4. Mutation hooks in `src/lib/hooks/mutations/` for the mutation hook pattern
5. DTO files in `src/types/api/` for naming conventions

See `references/handler-pattern.md` for the handler template.
See `references/query-hook-pattern.md` for the hook template.
See `references/dto-conventions.md` for DTO naming.
See `_shared/code-standards.md` for all project rules (sections 3, 4).

## Step 3 — Generate Files

### 3a. Add Endpoint to ApiEndpoints.ts

Plain strings only, no function callbacks:
```typescript
ENTITY_NAME: {
  LIST: '/api/v1/entity-name',
  DETAILS: '/api/v1/entity-name/:id',
  CREATE: '/api/v1/entity-name',
  UPDATE: '/api/v1/entity-name/:id',
  DELETE: '/api/v1/entity-name/:id',
},
```

### 3b. Create DTOs in `src/types/api/`

File: `src/types/api/EntityNameDto.ts`
- Use `type` not `interface`
- Follow naming: `ForReadDto`, `ForCreateDto`, `ForUpdateDto`, `ListDto`, `ListResponseDto`, `ParamsDto`
- Mark truly optional fields with `?`
- Reuse shared types: `ResultDto<T>`, `PrimaryImageForReadDto`, `PicklistValueDto`
- Export through barrel `src/types/api/index.ts`

### 3c. Create Handler in `src/api/handlers/`

File: `src/api/handlers/entity-name.ts`
- Import `ApiEndpoints`, `HttpClient` from `@api/config`
- Import `pathBuilder` from `@utils`
- Define request functions ABOVE handler object
- Handler uses string `queryKey`, function REFERENCE for `request`
- Export with `as const`

### 3d. Create React Query Hooks

Queries: `src/lib/hooks/queries/useEntityQuery.ts`
```typescript
export const useEntityListQuery = (params = {}) => {
  return useQuery({
    queryKey: [EntityHandler.list.queryKey, params],
    queryFn: () => EntityHandler.list.request(buildQueryString(params)),
  });
};
```

Mutations: `src/lib/hooks/mutations/useEntityMutation.ts`
```typescript
export const useCreateEntityMutation = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationKey: [EntityHandler.create.mutationKey],
    mutationFn: (data) => EntityHandler.create.request(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: [EntityHandler.list.queryKey] });
    },
  });
};
```

No explicit return types — let TypeScript infer.

### 3e. Update Barrel Exports

Add exports to:
- `src/types/api/index.ts`
- `src/api/handlers/index.ts`
- Hook barrel files if they exist

## Checklist

- [ ] Endpoint in ApiEndpoints.ts as plain string
- [ ] DTOs with correct naming conventions
- [ ] DTOs exported through barrel
- [ ] Handler: request functions above, string queryKey, function reference
- [ ] Query hook: queryKey wrapped in array, no explicit return type
- [ ] Mutation hook: invalidates correct queries, handles errors with toast
- [ ] All imports use path aliases and `import type` for types
