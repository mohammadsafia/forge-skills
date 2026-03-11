# DTO Naming Conventions

## Standard DTO Suffixes

| Suffix | Purpose | Example |
|--------|---------|---------|
| `ForReadDto` | GET response shape | `UserForReadDto`, `ProductForReadDto` |
| `ForCreateDto` | POST payload | `UserForCreateDto`, `OrderForCreateDto` |
| `ForUpdateDto` | PUT/PATCH payload | `UserForUpdateDto`, `OrderForUpdateDto` |
| `ListDto` | Single item in a list | `OrderListDto`, `BookmarkListItemDto` |
| `ListResponseDto` | Paginated list wrapper | `OrderListResponseDto`, `ProductListResponseDto` |
| `ParamsDto` | Query/filter parameters | `UsersListParamsDto`, `ProductsListParamsDto` |

## Shared API Types

Reuse these instead of redefining per feature:

```typescript
// Generic paginated response wrapper
type ResultDto<T> = {
  items: T[];
  page: number;
  pageSize: number;
  totalCount: number;
  lastPage: number;
};

// Common nested types
type PrimaryImageForReadDto = {
  contentUrl: string;
  contentValue: string;
  encodingFormat: string;
  id: number;
  sizeInBytes: number;
  title: string;
};

type EntityStatusForReadDto = {
  code: number;
  label: string;
  label_i18n: string;
};

type CreatorForReadDto = {
  additionalName: string;
  familyName: string;
  givenName: string;
  id: number;
  name: string;
  profileURL: string;
};

type PicklistValueDto = {
  key: string;
  name: string;
  name_i18n: string;
};
```

## Rules

- Use `type` not `interface`
- Mark truly optional fields with `?` — don't make everything optional
- Nested sub-objects get their own type: `ProductMetadataDto`, `ProviderFinancialDetails`
- Map snake_case BE fields to camelCase in the DTO
- Always `import type` when importing DTOs in components
- Export every DTO through the barrel: `src/types/api/index.ts`

## Template

```typescript
// src/types/api/EntityNameDto.ts

type EntityNameForReadDto = {
  id: number;
  name: string;
  status: EntityStatusForReadDto;
  creator: CreatorForReadDto;
  dateCreated: string;
  dateModified: string;
};

type EntityNameForCreateDto = {
  name: string;
  description?: string;
};

type EntityNameForUpdateDto = {
  name?: string;
  description?: string;
};

type EntityNameListDto = {
  id: number;
  name: string;
  status: EntityStatusForReadDto;
};

type EntityNameListResponseDto = ResultDto<EntityNameListDto>;

type EntityNameListParamsDto = {
  page?: number;
  pageSize?: number;
  search?: string;
  sort?: string;
  filter?: string;
};

export type {
  EntityNameForReadDto,
  EntityNameForCreateDto,
  EntityNameForUpdateDto,
  EntityNameListDto,
  EntityNameListResponseDto,
  EntityNameListParamsDto,
};
```
