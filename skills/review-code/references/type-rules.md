# Type Rules Reference

## type vs interface

Use `type` everywhere. Use `interface` only when extending/merging is absolutely necessary.

```typescript
// CORRECT
type UserProps = {
  name: string;
  email: string;
};

// WRONG
interface UserProps {
  name: string;
  email: string;
}
```

## No any

Never use `any`. Use proper types, generics, or `unknown` if truly needed.

```typescript
// CORRECT
function processData(data: unknown): void { ... }
function getItem<T>(key: string): T | null { ... }

// WRONG
function processData(data: any): void { ... }
```

## Return Types

Exported functions need explicit return types — EXCEPT React Query hooks (let TypeScript infer from handlers).

```typescript
// CORRECT — explicit return type on exported function
export function formatCurrency(amount: number, currency: string): string { ... }

// CORRECT — NO return type on React Query hook (infer from handler)
export const useOrdersQuery = (enabled = true) => {
  return useQuery({ ... });
};

// WRONG — explicit return type on hook
export const useOrdersQuery = (enabled = true): UseQueryResult<...> => { ... }
```

## DTO Naming Conventions

| Suffix | Purpose | Example |
|--------|---------|---------|
| `ForReadDto` | GET response (single item) | `OrderForReadDto` |
| `ForCreateDto` | POST payload | `OrderForCreateDto` |
| `ForUpdateDto` | PUT/PATCH payload | `OrderForUpdateDto` |
| `ListDto` | Single item in list response | `OrderListDto` |
| `ListResponseDto` | Full paginated wrapper | `OrderListResponseDto` |
| `ParamsDto` | Query/filter parameters | `OrderParamsDto` |

## DTO Location & Organization

- All API DTOs live in `src/types/api/` — one file per domain entity
- Every DTO file must be exported through the barrel: `src/types/api/index.ts`
- Liferay-specific types go in `src/types/liferay/`
- Feature-specific Zod schemas go in `src/views/<Feature>/schemas.ts` — NOT in `src/types/`

```typescript
// CORRECT — DTO in types/api/
src/types/api/order.ts → export through src/types/api/index.ts

// WRONG — Zod schema in types/
src/types/order-schema.ts // NO — put in views/<feature>/schemas.ts
```

## DTO Quality Rules

- Nested sub-objects get their own named type — no inline object literals:
```typescript
// CORRECT
type ProductMetadataDto = {
  weight: number;
  dimensions: string;
};

type ProductForReadDto = {
  id: string;
  metadata: ProductMetadataDto;
};

// WRONG — inline nested object
type ProductForReadDto = {
  id: string;
  metadata: { weight: number; dimensions: string }; // NO
};
```

- Map BE snake_case to camelCase — keep FE types idiomatic:
```typescript
// CORRECT
type UserForReadDto = {
  firstName: string;  // BE sends first_name
  lastName: string;   // BE sends last_name
};

// WRONG
type UserForReadDto = {
  first_name: string; // Don't expose snake_case to FE
};
```

- Mark truly optional BE fields with `?` — don't make everything optional out of laziness
- Every API response must be typed — never use `any` or untyped responses

## Shared API Types

Reuse instead of redefining per feature:
- `ResultDto<T>` — Paginated list wrapper
- `PrimaryImageForReadDto` — Image with URL
- `EntityStatusForReadDto` — Status with code/label
- `CreatorForReadDto` — Creator info
- `TranslatedProperty` — i18n fields (`Record<string, string>`)
- `PicklistValueDto` — Picklist value with key/name

## Status/Type Fields

Never use raw `string` for status or type fields. Use type literals or enums:

```typescript
// CORRECT
type OrderStatus = 'pending' | 'approved' | 'rejected' | 'cancelled';

type OrderDto = {
  status: OrderStatus;
};

// ALSO CORRECT
enum OrderStatus {
  Pending = 'pending',
  Approved = 'approved',
}

// WRONG
type OrderDto = {
  status: string; // Never raw string for status
};
```

## import type

Use `import type` when importing only types:

```typescript
// CORRECT
import type { OrderForReadDto, OrderListDto } from '@app-types';

// WRONG
import { OrderForReadDto, OrderListDto } from '@app-types';
```
