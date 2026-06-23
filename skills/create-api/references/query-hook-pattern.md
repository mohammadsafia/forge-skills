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

import { useToast } from '@hooks/shared';
import { useAppTranslation } from '@hooks/shared';

import type { EntityNameForCreateDto, EntityNameForUpdateDto } from '@app-types';

// Create mutation
export const useCreateEntityNameMutation = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { t } = useAppTranslation('entityName');

  return useMutation({
    mutationKey: [EntityNameHandler.create.mutationKey],
    mutationFn: (data: EntityNameForCreateDto) => EntityNameHandler.create.request(data),
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: [EntityNameHandler.list.queryKey],
      });
      toast({ title: t('created_successfully'), variant: 'success' });
    },
    onError: () => {
      toast({ title: t('failed_to_create'), variant: 'destructive' });
    },
  });
};

// Update mutation
export const useUpdateEntityNameMutation = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { t } = useAppTranslation('entityName');

  return useMutation({
    mutationKey: [EntityNameHandler.update.mutationKey],
    mutationFn: (payload: { id: string; data: EntityNameForUpdateDto }) =>
      EntityNameHandler.update.request(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: [EntityNameHandler.list.queryKey],
      });
      toast({ title: t('updated_successfully'), variant: 'success' });
    },
    onError: () => {
      toast({ title: t('failed_to_update'), variant: 'destructive' });
    },
  });
};

// Delete mutation
export const useDeleteEntityNameMutation = () => {
  const queryClient = useQueryClient();
  const { toast } = useToast();
  const { t } = useAppTranslation('entityName');

  return useMutation({
    mutationKey: [EntityNameHandler.delete.mutationKey],
    mutationFn: (id: string) => EntityNameHandler.delete.request(id),
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: [EntityNameHandler.list.queryKey],
      });
      toast({ title: t('deleted_successfully'), variant: 'success' });
    },
    onError: () => {
      toast({ title: t('failed_to_delete'), variant: 'destructive' });
    },
  });
};
```

## Rules

- **No explicit return types** — let TypeScript infer from the handler
- **queryKey wrapped in array**: `[handler.queryKey]` not just `handler.queryKey`
- **Parameterized queries** add params to the array: `[handler.queryKey, id]`
- **Invalidate correct queries** after mutations
- **Toast on success and error** in mutations
- **Use `enabled` flag** to conditionally run queries
- **Use `import type`** for DTO imports in the hook file

## React Query Defaults

```
staleTime: 5 minutes
gcTime: 10 minutes
retry: 1
refetchOnWindowFocus: false
```
