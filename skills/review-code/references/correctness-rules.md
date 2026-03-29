# Correctness Rules Reference

These checks verify that features actually work correctly — not just that they follow conventions, but that they won't break at runtime.

## IMPORTANT: Verification Method

For every check below, you MUST read the actual code and verify the condition. Do NOT assume behavior from function names alone — read the implementation. If you cannot verify a condition, state "could not verify" — never guess.

---

## 1. React Query Correctness

### enabled flag missing

When a query depends on a parameter that might be undefined (e.g., from `useParams()` or parent state), the `enabled` flag must prevent the query from firing with undefined.

**How to detect:**
1. Find all query hooks called with a parameter: `useSomethingQuery(id)`, `useSomethingQuery(params)`
2. Read the hook definition
3. Check if `enabled` includes a truthiness check for the parameter

```typescript
// WRONG — fires with undefined id on first render
export const useCommunityByIdQuery = (id: string) => {
  return useQuery({
    queryKey: [handler.getById.queryKey, id],
    queryFn: () => handler.getById.request(id),
  });
};

// CORRECT — waits until id exists
export const useCommunityByIdQuery = (id: string, enabled = true) => {
  return useQuery({
    queryKey: [handler.getById.queryKey, id],
    queryFn: () => handler.getById.request(id),
    enabled: enabled && !!id,
  });
};
```

### Stale invalidation after mutation

**How to detect:**
1. Read each mutation hook's `onSuccess`
2. Find the `invalidateQueries` call
3. Verify the queryKey being invalidated matches the correct list/detail query for the same entity
4. Common mistake: invalidating the detail query but not the list query (or vice versa)

```typescript
// WRONG — only invalidates detail, list is stale
onSuccess: () => {
  queryClient.invalidateQueries({ queryKey: [handler.getById.queryKey] });
},

// CORRECT — invalidates the list so it refetches
onSuccess: () => {
  queryClient.invalidateQueries({ queryKey: [handler.getList.queryKey] });
},
```

### Using refetch() instead of invalidation

**How to detect:** Search reviewed files for `.refetch()` calls after mutations.

```typescript
// WRONG — manual refetch instead of cache invalidation
const handleDelete = async (id: string) => {
  await deleteMutation.mutateAsync(id);
  ordersQuery.refetch(); // NO — use invalidation
};

// CORRECT — invalidation in the mutation hook itself
// The mutation's onSuccess handles invalidation
```

### Multiple components calling same query differently

**How to detect:** Search for the same query hook imported in multiple files within the same page/route. If two sibling components call `useOrdersQuery()` with different params, they get different cache entries — but if they call it identically, it's fine (React Query deduplicates).

Flag only when the same hook is called with conflicting parameters in components that render on the same page.

---

## 2. Zod / Form Correctness

### Schema ↔ API mismatch

**How to detect:**
1. Read the Zod schema in `views/<feature>/schemas.ts`
2. Read the corresponding `ForCreateDto` or `ForUpdateDto` in `src/types/api/`
3. Compare field by field:
   - Every required field in the DTO should be required in the schema (no `.optional()`)
   - Field names must match exactly
   - Types must be compatible (`z.string()` ↔ `string`, `z.number()` ↔ `number`, `z.enum([...])` ↔ union type)

```typescript
// Schema
const communitySchema = z.object({
  name: z.string().min(1),       // ✓ matches DTO
  description: z.string(),       // ✓ matches DTO
  category: z.string(),          // ✗ DTO has category: CommunityCategory (enum)
  memberCount: z.string(),       // ✗ DTO has memberCount: number (type mismatch)
});

// DTO
type CommunityForCreateDto = {
  name: string;
  description: string;
  category: CommunityCategory;   // enum, not string
  memberCount: number;           // number, not string
};
```

### Form fields not in schema

**How to detect:**
1. Read the form component JSX
2. Find all `name` props on form inputs (e.g., `<FormInput name="email" />`)
3. Read the Zod schema
4. Verify every `name` value exists as a field in the schema
5. Fields in the form but not in the schema are silently ignored by React Hook Form

```
Error: Form field `name="nickname"` in `CommunityForm.tsx:34` has no matching field in `communitySchema` — value will be silently dropped on submit
```

### Required fields without required indicator

**How to detect:**
1. Read the Zod schema — find all fields WITHOUT `.optional()` (they are required)
2. Read the form JSX — find the corresponding form input
3. Verify the input has the `required` prop

```
Warning: `communitySchema.name` is required (no `.optional()`) but `<FormInput name="name" />` at `CommunityForm.tsx:22` is missing `required` prop — user won't see the required indicator
```

### Default values don't match schema

**How to detect:**
1. Read the form setup — find `defaultValues` in `useForm()` or the form component
2. Read the Zod schema
3. Verify:
   - Every required schema field has a default value (otherwise form starts invalid)
   - Default value types match schema types (not `undefined` for required `z.string()`)

```
Error: `communitySchema.name` is `z.string().min(1)` but `defaultValues.name` is `undefined` — form starts in invalid state
```

---

## 3. Routing Correctness

### Protected route without AuthGuard

**How to detect:**
1. Read the route config
2. For each route, check if it's wrapped in `AuthGuard`
3. Pages in `DashboardLayout` should always be protected
4. Pages in `MainLayout` may be public — but verify intent

```
Error: Route `/dashboard/communities` renders inside `DashboardLayout` but is not wrapped in `AuthGuard`
```

### Orphaned routes

**How to detect:**
1. Read the route config — collect all route paths
2. For each path, search the entire `src/` for:
   - `<Link to="...">` or `<NavLink to="...">` pointing to it
   - `navigate('...')` or `navigate(\`...\`)` pointing to it
   - Route constants referencing it
3. If no navigation points to a route, it's orphaned (unreachable by user)

```
Warning: Route `/communities/archive` defined in routes but no `<Link>` or `navigate()` points to it — orphaned route
```

### Hardcoded route paths

**How to detect:** Search reviewed files for:
- `navigate('/some/path')` with a string literal
- `<Link to="/some/path">` with a string literal
- `<NavLink to="/some/path">` with a string literal

These should use route constants instead.

```
Warning: `navigate('/communities')` at `CommunityCard.tsx:28` — use route constant `ROUTES.COMMUNITIES.LIST` instead of hardcoded path
```

### Param name mismatch

**How to detect:**
1. Read the route config — find routes with params (`:id`, `:communityId`)
2. Read the corresponding page component
3. Find `useParams()` destructuring
4. Verify the destructured names match the route param names exactly

```
Error: Route defines `:communityId` but `CommunityDetailPage.tsx:5` destructures `const { id } = useParams()` — `id` will be `undefined`
```

---

## 4. UX Completeness

### Delete without confirmation

**How to detect:**
1. Find all delete handlers (`handleDelete`, `deleteMutation`, `useDelete*Mutation`)
2. Trace the call — does it go through a confirmation dialog before executing?
3. A direct call to `mutateAsync` or `mutate` in an `onClick` without a confirmation step is a violation

```
Warning: `handleDelete` at `CommunityCard.tsx:35` calls `deleteMutation.mutateAsync(id)` directly — no confirmation dialog. User can accidentally delete with one click.
```

### Form submit without loading state

**How to detect:**
1. Find form submit buttons in the review scope
2. Check if the button has a `loading` or `disabled` prop tied to mutation state
3. `isPending` or `isLoading` from the mutation hook should disable the submit button

```typescript
// WRONG — button stays clickable during submission
<Button onClick={handleSubmit}>Save</Button>

// CORRECT — button shows loading state
<Button onClick={handleSubmit} loading={createMutation.isPending}>Save</Button>
```

```
Warning: Submit button at `CommunityForm.tsx:88` has no loading state — user can double-submit
```

### Success action without toast

**How to detect:**
1. Read mutation hooks' `onSuccess` callbacks
2. Verify a `toast()` call exists with a success message
3. Or verify a navigation occurs (redirect to list page is also valid feedback)

```
Warning: `useCreateCommunityMutation.onSuccess` at `useCommunityMutation.ts:18` invalidates queries but shows no toast — user has no confirmation their action succeeded
```

### Long list without pagination

**How to detect:**
1. Find components rendering lists from API data
2. Check if the query passes pagination params (page, limit/pageSize)
3. Check if the UI has pagination controls or infinite scroll
4. Lists that render `data.items.map(...)` without any pagination are unbounded

```
Warning: `CommunitiesPage.tsx:42` renders `data.items.map(...)` without pagination — will be slow with large datasets
```

### Missing debounce on search

**How to detect:**
1. Find `<Input>` or `<SearchInput>` elements with `onChange` handlers
2. Trace what the `onChange` handler does — if it directly sets a query param or triggers an API call, it needs debounce
3. Check for `useDebounce` usage on the search value

```
Warning: Search input at `CommunitiesPage.tsx:30` calls `setGlobalFilter(value)` directly in onChange — add `useDebounce(value, 300)` before passing to the filter
```

---

## 5. API Contract

### pathBuilder without matching placeholder

**How to detect:**
1. Find all `pathBuilder(endpoint, { ... })` calls
2. Read the endpoint string from `ApiEndpoints`
3. Verify each key in the params object has a matching `:key` placeholder in the endpoint string

```typescript
// Endpoint: '/communities/:id'
pathBuilder(ApiEndpoints.COMMUNITIES.BY_ID, { id })         // ✓ matches :id
pathBuilder(ApiEndpoints.COMMUNITIES.BY_ID, { communityId }) // ✗ no :communityId placeholder
```

```
Error: `pathBuilder(ApiEndpoints.COMMUNITIES.BY_ID, { communityId })` at `community.ts:12` — endpoint has `:id` not `:communityId`
```

### Wrong HTTP method for operation

**How to detect:**
1. Read handler request functions
2. Verify the HTTP method matches the operation:

| Operation | Expected Method |
|-----------|----------------|
| List / Get | `HttpClient.get` |
| Create | `HttpClient.post` |
| Full update | `HttpClient.put` |
| Partial update | `HttpClient.patch` |
| Delete | `HttpClient.delete` |

```
Error: `createCommunity` at `community.ts:20` uses `HttpClient.get` — should be `HttpClient.post` for a create operation
```

### GET request with body

**How to detect:** Find `HttpClient.get` calls with a second argument that isn't `{ params: ... }`. GET requests should only have query params, not a body.

```typescript
// WRONG — GET with body payload
HttpClient.get(endpoint, payload);

// CORRECT — GET with query params
HttpClient.get(endpoint, { params });

// CORRECT — POST with body
HttpClient.post(endpoint, payload);
```

### Missing DTO fields

**How to detect:**
1. Read the handler's request function signature — find the DTO type used as parameter
2. Read the DTO definition
3. Find where the handler is called in the component/hook
4. Verify the data being passed includes all required (non-optional) DTO fields

```
Error: `CommunityForCreateDto` requires `category` field but the form submit at `CommunityForm.tsx:55` doesn't include it in the payload
```
