---
name: forge:create-api
description: "Create a full API integration pipeline — endpoint, DTOs, handler, and React Query hook. Use when the user wants to add a new API endpoint, integrate a backend endpoint, create an API handler, set up a query/mutation hook, or says things like 'add endpoint for', 'create API for', 'integrate this endpoint', 'wire up the backend', 'add a new query hook'. Triggers whenever new backend integration work is needed."
---

# Create API

Generate the complete API integration chain: endpoint → DTOs → handler → React Query hook.

## Step 1 — Gather Information

Ask the user if not provided:
- **Entity name** (e.g., "Order", "Product")
- **HTTP methods** needed (GET list, GET by ID, POST create, PUT update, DELETE)
- **Endpoint path** as the API documents it, and the error answers (status codes, error body, error codes)
- **Request/response shape** (fields and types), or the OpenAPI document if the project generates DTOs

## Step 2 — Read the Project's API Layer

1. If `kit.lock.json` exists at the repository root, the app is built on the RSK kit. Read `../_shared/rsk-kit.md`
   sections 1, 2 and 4 and follow them. In particular:
   - the HTTP client is `httpClient` (lower case) from `@api/config/HttpClient`;
   - the base URL already holds the API prefix, so endpoint paths are relative (`'/orders'`, not `'/api/v1/orders'`);
   - a failed request throws the API's error body with `status` added; read it with `errorMessage` from `@utils`.
2. Otherwise read the endpoint registry (if any), an existing handler, a query hook, a mutation hook, and the DTO
   folder. Use the names, client and key style they use.

Before writing the first path, read the client's base URL and check that base URL + path gives the URL the API
documents. A doubled prefix (`/api/api/...`) is the most common fault here.

See `references/handler-pattern.md`, `references/query-hook-pattern.md` and `references/dto-conventions.md` for the
generic templates. See `../_shared/code-standards.md` sections 3 and 4.

## Step 3 — Generate Files

### 3a. Endpoint paths

Add the paths to the project's registry (RSK: `ApiEndpoints` in `src/api/config/ApiEndpoints.ts`, plain strings):

```typescript
ORDERS: {
  LIST: '/orders',
  DETAILS: '/orders/:id',
},
```

### 3b. DTOs

- Generated DTOs (RSK: `pnpm dto:gen` writes `src/types/api/`) are regenerated, never edited by hand.
- Hand-written DTOs follow the project's naming (`ForReadDto`, `ForCreateDto`, `ForUpdateDto`, `ListDto`,
  `ParamsDto`) and are exported through the types barrel (RSK: `src/types/index.ts`, alias `@app-types`).
- Type the error body too when the API documents one (for example `{ status, code, detail }`).

### 3c. Handler

- Request functions above the handler object, referenced by name; string `queryKey` (see
  `references/handler-pattern.md`).
- Use the project's client and path helper (RSK: `httpClient`, `pathBuilder` from `@utils`).

### 3d. Query and mutation hooks

- Query keys include every input that changes the result; parameterised queries are guarded with `enabled`.
- Mutations reconcile the cache (invalidate, or update it directly).
- Hooks do not decide how a result is shown. Do not put a toast in a hook. Return the mutation and let the page choose:
  an inline message, a toast, a redirect, or nothing. A toast is only seen where a toaster is mounted (RSK: only inside
  the signed-in shell).
- Show server messages through `forge:add-translations` rules: map an error code to a translated message; show the
  API's own text only when the API localises it.

### 3e. Barrel exports

Add exports to the handler, DTO and hook barrels the project has. In RSK the hook barrels
`src/lib/hooks/queries/index.ts` and `src/lib/hooks/mutations/index.ts` are kit files that apps are expected to add
to; mention them in the pull request.

## Checklist

- [ ] Layout read first (RSK detected by `kit.lock.json`, or the project's own files)
- [ ] Base URL + path checked: no doubled or missing API prefix
- [ ] DTOs typed, including the error body; generated DTOs not edited by hand
- [ ] Handler uses the project's client and path helper; request functions referenced by name
- [ ] Query keys hold every input; parameterised queries guarded by `enabled`
- [ ] Mutations reconcile the cache; no toast or other display decision inside a hook
- [ ] Imports use path aliases and `import type` for types
