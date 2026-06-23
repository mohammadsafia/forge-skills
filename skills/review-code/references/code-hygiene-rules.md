> Rules: see `_shared/code-standards.md`. This file contains code examples only.

# Code Hygiene — Code Examples

## Console Statements

```typescript
// WRONG — left in production code
console.log('data:', data);
console.warn('deprecated usage');
console.error('something went wrong', error);
debugger;

// CORRECT — use toast for user-facing errors, remove the rest
```

## Commented-Out Code

```typescript
// WRONG — dead code, not an explanation
// const handleOldSubmit = () => {
//   apiClient.post('/v1/orders', data);
// };

// CORRECT — an explanation IS a valid comment
// Skip validation for draft orders — they save without required fields
if (order.status === 'draft') return;
```

## @ts-ignore / @ts-expect-error

```typescript
// WRONG — suppressing without explanation
// @ts-ignore
const value = someUntypedLib.getData();

// ACCEPTABLE — with clear reason and plan
// @ts-expect-error — library types are wrong, fix tracked in DM-456
const value = someUntypedLib.getData();
```

## Type Assertions (as)

```typescript
// WRONG — bypassing the type system
const user = response.data as UserForReadDto;

// CORRECT — type the function properly so inference works
async function getUser(id: string): Promise<ResultDto<UserForReadDto>> {
  return HttpClient.get<ResultDto<UserForReadDto>>(pathBuilder(endpoint, { id }));
}

// CORRECT — if assertion is truly needed, narrow first
if (isUserDto(response.data)) {
  const user = response.data; // properly narrowed
}
```

## Non-null Assertions (!)

```typescript
// WRONG — hides a null check bug
const name = user!.name;
const ref = containerRef.current!;

// CORRECT — handle the null case
if (!user) return null;
const name = user.name;

// CORRECT — for refs, assert after mount check
useEffect(() => {
  if (!containerRef.current) return;
  containerRef.current.focus();
}, []);
```

## Unused Exports

```typescript
// WRONG — exported but no file imports it
export function formatLegacyDate(date: string): string { ... }
export type OldOrderDto = { ... };
```

## Unreachable Code

```typescript
// WRONG — code after early return
function getStatus(order: Order): string {
  if (!order) return 'unknown';
  return order.status;
  const fallback = 'pending'; // unreachable
}
```

## Magic Numbers & Strings

```typescript
// WRONG — what does 5 mean? what does 'active' mean?
if (retryCount > 5) return;
if (user.role === 'operator') showDashboard();
const pageSize = 10;

// CORRECT — named constants
const MAX_RETRY_COUNT = 5;
if (retryCount > MAX_RETRY_COUNT) return;

if (user.role === ROLES.OPERATOR) showDashboard();

const DEFAULT_PAGE_SIZE = 10;
```

## Async Consistency

```typescript
// WRONG — mixed styles in same file
async function createOrder(data: OrderForCreateDto) {
  const result = await orderHandler.create.request(data);
  return result;
}

function deleteOrder(id: string) {
  return orderHandler.delete.request(id).then(res => res.data);
}

// CORRECT — pick one style (prefer async/await)
async function createOrder(data: OrderForCreateDto) {
  const result = await orderHandler.create.request(data);
  return result;
}

async function deleteOrder(id: string) {
  const res = await orderHandler.delete.request(id);
  return res.data;
}
```

## Hardcoded User-Facing Strings

```typescript
// WRONG — hardcoded English strings
<Button>Delete</Button>
<p>No orders found</p>
<Dialog.Title>Confirm Action</Dialog.Title>
toast({ title: 'Order created successfully' });

// CORRECT — translated
<Button>{t('common.delete')}</Button>
<p>{t('orders.emptyState')}</p>
<Dialog.Title>{t('common.confirmAction')}</Dialog.Title>
toast({ title: t('orders.createSuccess') });
```
