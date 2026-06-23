> Rules: see `_shared/code-standards.md`. This file contains code examples only.

# Correctness Rules — Code Examples

## React Query Correctness

### enabled flag missing

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

```typescript
// WRONG — manual refetch instead of cache invalidation
const handleDelete = async (id: string) => {
  await deleteMutation.mutateAsync(id);
  ordersQuery.refetch(); // NO — use invalidation
};

// CORRECT — invalidation in the mutation hook itself
```

## Zod / Form Correctness

### Schema vs API mismatch

```typescript
// Schema
const communitySchema = z.object({
  name: z.string().min(1),       // matches DTO
  description: z.string(),       // matches DTO
  category: z.string(),          // DTO has category: CommunityCategory (enum)
  memberCount: z.string(),       // DTO has memberCount: number (type mismatch)
});

// DTO
type CommunityForCreateDto = {
  name: string;
  description: string;
  category: CommunityCategory;   // enum, not string
  memberCount: number;           // number, not string
};
```

## Routing Correctness

### Param name mismatch

Route defines `:communityId` but page destructures `const { id } = useParams()` — `id` will be `undefined`.

## UX Completeness

### Form submit without loading state

```typescript
// WRONG — button stays clickable during submission
<Button onClick={handleSubmit}>Save</Button>

// CORRECT — button shows loading state
<Button onClick={handleSubmit} loading={createMutation.isPending}>Save</Button>
```

## API Contract

### pathBuilder without matching placeholder

```typescript
// Endpoint: '/communities/:id'
pathBuilder(ApiEndpoints.COMMUNITIES.BY_ID, { id })         // CORRECT — matches :id
pathBuilder(ApiEndpoints.COMMUNITIES.BY_ID, { communityId }) // WRONG — no :communityId placeholder
```

### GET request with body

```typescript
// WRONG — GET with body payload
HttpClient.get(endpoint, payload);

// CORRECT — GET with query params
HttpClient.get(endpoint, { params });

// CORRECT — POST with body
HttpClient.post(endpoint, payload);
```
