# React Query Hook Patterns

## Query Hook (GET)

```typescript
// src/lib/hooks/queries/useEntityNameQuery.ts

import { useQuery } from '@tanstack/react-query';

import { EntityNameHandler } from '@api/handlers';

// List query — no explicit return type (let TypeScript infer)
export const useEntityNameListQuery = (queryString?: string, enabled = true) => {
  return useQuery({
    queryKey: [EntityNameHandler.list.queryKey, queryString],
    queryFn: () => EntityNameHandler.list.request(queryString),
    enabled,
  });
};

// Detail query — parameterized
export const useEntityNameDetailsQuery = (id: string, enabled = true) => {
  return useQuery({
    queryKey: [EntityNameHandler.details.queryKey, id],
    queryFn: () => EntityNameHandler.details.request(id),
    enabled: enabled && !!id,
  });
};
```

## Mutation Hook (POST/PUT/DELETE)

```typescript
// src/lib/hooks/mutations/useEntityNameMutation.ts

import { useMutation, useQueryClient } from '@tanstack/react-query';

import { EntityNameHandler } from '@api/handlers';

import type { EntityNameForCreateDto, EntityNameForUpdateDto } from '@app-types';

export const useCreateEntityNameMutation = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationKey: [EntityNameHandler.create.mutationKey],
    mutationFn: (data: EntityNameForCreateDto) => EntityNameHandler.create.request(data),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: [EntityNameHandler.list.queryKey] }),
  });
};

export const useUpdateEntityNameMutation = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationKey: [EntityNameHandler.update.mutationKey],
    mutationFn: (payload: { id: string; data: EntityNameForUpdateDto }) => EntityNameHandler.update.request(payload),
    onSuccess: (_result, { id }) => {
      queryClient.invalidateQueries({ queryKey: [EntityNameHandler.list.queryKey] });
      queryClient.invalidateQueries({ queryKey: [EntityNameHandler.details.queryKey, id] });
    },
  });
};
```

## Feedback Belongs to the Page

The hook reconciles the cache; the page decides what the person sees. In an RSK app (`toast` from `useToast()`,
`errorMessage` from `@utils`):

```typescript
const { toast } = useToast();
const createEntity = useCreateEntityNameMutation();

const handleSubmit = (values: EntityNameForCreateDto) =>
  createEntity.mutateAsync(values).then(
    () => toast({ title: t('created'), tone: 'success' }),
    (error: unknown) => form.setError('root', { message: errorMessage(error, t('createFailed')) }),
  );
```

Choose per screen: an inline error next to the form is usually clearer than a toast, and a toast is only visible where a
toaster is mounted.

## Rules

- **No explicit return types** — let TypeScript infer from the handler
- **queryKey wrapped in array**: `[handler.queryKey]` not just `handler.queryKey`
- **Parameterized queries** add params to the array: `[handler.queryKey, id]`
- **Invalidate correct queries** after mutations
- **No toast inside a hook**: the page shows success and failure (inline message, toast or redirect)
- **Use `enabled` flag** to conditionally run queries
- **Use `import type`** for DTO imports in the hook file

## React Query Defaults

Read the project's query client before relying on defaults. The RSK kit's `createQueryClient` sets `retry: false`,
`refetchOnWindowFocus: false` and `staleTime: 0`.
