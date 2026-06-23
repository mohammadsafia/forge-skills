> Rules: see `_shared/code-standards.md`. This file contains code examples only.

# Type Rules — Code Examples

## type vs interface

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

```typescript
// CORRECT
function processData(data: unknown): void { ... }
function getItem<T>(key: string): T | null { ... }

// WRONG
function processData(data: any): void { ... }
```

## Return Types

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

## DTO Quality

```typescript
// CORRECT — nested sub-objects get their own named type
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

## snake_case to camelCase mapping

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

## Status/Type Fields

```typescript
// CORRECT
type OrderStatus = 'pending' | 'approved' | 'rejected' | 'cancelled';

type OrderDto = {
  status: OrderStatus;
};

// WRONG
type OrderDto = {
  status: string; // Never raw string for status
};
```

## import type

```typescript
// CORRECT
import type { OrderForReadDto, OrderListDto } from '@app-types';

// WRONG
import { OrderForReadDto, OrderListDto } from '@app-types';
```
