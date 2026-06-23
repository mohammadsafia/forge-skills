> Rules: see `_shared/code-standards.md`. This file contains code examples only.

# Naming Conventions — Code Examples

## Folder Naming

```
src/views/communities/community-card/     CORRECT
src/views/Communities/CommunityCard/      WRONG

src/components/shared/prime-dialog/       CORRECT
src/components/shared/PrimeDialog/        WRONG

src/pages/user-profile/                   CORRECT
src/pages/UserProfile/                    WRONG
```

## DTO Naming

```typescript
// CORRECT
type CommunityMetadataDto = { ... };
type CommunityForReadDto = {
  metadata: CommunityMetadataDto;
};

// WRONG — anonymous inline
type CommunityForReadDto = {
  metadata: { weight: number; dimensions: string };
};
```

## Hook Naming

```typescript
// CORRECT
useCommunityQuery
useCreateOrderMutation
useDebounce
useAppTranslation

// WRONG
use-community-query     // kebab-case
UseCommunityQuery       // PascalCase
communityQuery          // missing use prefix
```

## Handler queryKey Naming

```typescript
// CORRECT
queryKey: 'communities/list'
queryKey: 'communities/detail'
mutationKey: 'communities/create'

// WRONG
queryKey: 'communitiesList'        // camelCase
queryKey: 'communities_list'       // snake_case
queryKey: ['communities', 'list']  // array (must be string)
```

## Event Handler Naming

```typescript
// CORRECT
handleSubmit
handleDelete
handleSearchChange

// WRONG
onSubmit           // on* is for props, not internal handlers
deleteItem         // missing handle prefix
```

## API Endpoint Naming

```typescript
export const ApiEndpoints = {
  COMMUNITIES: {
    LIST: '/communities',
    BY_ID: '/communities/:id',
    CREATE: '/communities',
    UPDATE: '/communities/:id',
    DELETE: '/communities/:id',
  },
} as const;
```

## Translation Key Naming

```json
{
  "communities": {
    "title": "Communities",
    "create": "Create Community",
    "fields": {
      "name": "Community Name",
      "description": "Description"
    }
  }
}
```
