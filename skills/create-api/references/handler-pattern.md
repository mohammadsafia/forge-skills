# Handler Pattern Reference

## Standard Handler Template

```typescript
// src/api/handlers/entity-name.ts

import { ApiEndpoints, HttpClient } from '@api/config';
import { pathBuilder } from '@utils';

import type {
  EntityNameForReadDto,
  EntityNameForCreateDto,
  EntityNameForUpdateDto,
  EntityNameListResponseDto,
} from '@app-types';

const URL = ApiEndpoints.ENTITY_NAME;

// Request functions defined ABOVE the handler object

function getEntityList(queryString?: string): Promise<EntityNameListResponseDto> {
  const url = queryString ? `${URL.LIST}?${queryString}` : URL.LIST;
  return HttpClient.get<EntityNameListResponseDto>(url);
}

function getEntityDetails(id: string): Promise<EntityNameForReadDto> {
  const path = pathBuilder({ path: URL.DETAILS, pathParams: { id } });
  return HttpClient.get<EntityNameForReadDto>(path);
}

function createEntity(payload: EntityNameForCreateDto): Promise<EntityNameForReadDto> {
  return HttpClient.post<EntityNameForReadDto>(URL.CREATE, payload);
}

function updateEntity(payload: { id: string; data: EntityNameForUpdateDto }): Promise<EntityNameForReadDto> {
  const path = pathBuilder({ path: URL.UPDATE, pathParams: { id: payload.id } });
  return HttpClient.put<EntityNameForReadDto>(path, payload.data);
}

function deleteEntity(id: string): Promise<void> {
  const path = pathBuilder({ path: URL.DELETE, pathParams: { id } });
  return HttpClient.delete<void>(path);
}

// Handler object: queryKey is STRING, request is REFERENCE

export const EntityNameHandler = {
  list: {
    queryKey: 'entity-name/list',
    request: getEntityList,
  },
  details: {
    queryKey: 'entity-name/details',
    request: getEntityDetails,
  },
  create: {
    mutationKey: 'entity-name/create',
    request: createEntity,
  },
  update: {
    mutationKey: 'entity-name/update',
    request: updateEntity,
  },
  delete: {
    mutationKey: 'entity-name/delete',
    request: deleteEntity,
  },
} as const;
```

## Naming Conventions

| Concept | Convention | Example |
|---------|-----------|---------|
| Handler export | PascalCase + `Handler` | `OrderHandler` |
| Request function | camelCase verb + entity | `getOrders`, `createProvider` |
| Query key | kebab-case + slash | `'orders/list'`, `'providers/details'` |
| Mutation key | kebab-case + slash | `'orders/create'` |
| File name | kebab-case `.ts` | `order.ts`, `provider.ts` |
