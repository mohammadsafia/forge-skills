# Code Hygiene Rules Reference

## Debug Artifacts

### Console Statements

Remove all console statements from production code:

```typescript
// WRONG — left in production code
console.log('data:', data);
console.warn('deprecated usage');
console.error('something went wrong', error);
debugger;

// CORRECT — use toast for user-facing errors, remove the rest
// For development debugging, use React DevTools or breakpoints
```

**Exceptions**: `console.error` inside a top-level error boundary or global error handler is acceptable.

### Commented-Out Code

Dead code disguised as comments must be deleted — version control preserves history:

```typescript
// WRONG — dead code, not an explanation
// const handleOldSubmit = () => {
//   apiClient.post('/v1/orders', data);
// };

// CORRECT — an explanation IS a valid comment
// Skip validation for draft orders — they save without required fields
if (order.status === 'draft') return;
```

**Rule**: If the comment contains executable code, it should be deleted. If it explains WHY something is the way it is, it should stay.

## TypeScript Escape Hatches

### @ts-ignore / @ts-expect-error

```typescript
// WRONG — suppressing without explanation
// @ts-ignore
const value = someUntypedLib.getData();

// ACCEPTABLE — with clear reason and plan
// @ts-expect-error — library types are wrong, fix tracked in DM-456
const value = someUntypedLib.getData();
```

Every `@ts-ignore` or `@ts-expect-error` MUST have an explanation of why the type system can't handle this case. Prefer `@ts-expect-error` over `@ts-ignore` — it fails if the error is fixed, preventing stale suppressions.

### Type Assertions (as)

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

**When `as` is acceptable**: JSON parsing results, event targets (`e.target as HTMLInputElement`), and discriminated union narrowing where TypeScript can't infer.

### Non-null Assertions (!)

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

## Dead Code

### Unused Exports

Functions, types, or constants that are exported but never imported anywhere:

```typescript
// WRONG — exported but no file imports it
export function formatLegacyDate(date: string): string { ... }
export type OldOrderDto = { ... };
```

**How to check**: Search the entire `src/` directory for imports of the export name. If zero results, it's dead code.

### Unreachable Code

```typescript
// WRONG — code after early return
function getStatus(order: Order): string {
  if (!order) return 'unknown';
  return order.status;
  const fallback = 'pending'; // unreachable
}
```

## Magic Numbers & Strings

Unexplained literal values that should be named constants:

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

**Exceptions**: 0, 1, -1, empty string `''`, and boolean values are generally self-explanatory.

## Async Consistency

Don't mix `async/await` with `.then()` chains in the same file:

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

## i18n Completeness

### Hardcoded User-Facing Strings

Every string visible to the user must go through `t()`:

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

**Exceptions**: Technical strings not shown to users (log messages, error codes, query keys).

### Missing Translation Keys

If code uses `t('orders.newField')` but the key doesn't exist in `en.json` or `ar.json`, it will render the raw key string to the user.

**How to check**: Search locale files for every `t('...')` key used in the reviewed files.

### Orphaned Translation Keys

Keys that exist in locale files but are no longer referenced in any component. These add translation burden for no value.

**How to check**: For each key in the translation namespace, search `src/` for usage.

## Commit Hygiene (PR Reviews Only)

When reviewing a PR (not a single file), also check:

- Each commit has the Jira ticket number: `DM-XXX: imperative description`
- One logical change per commit — don't mix unrelated fixes
- No `Co-Authored-By` lines
- No `fixup!` or `squash!` commits left unrebased
- No commits that only fix lint/type errors from a previous commit in the same PR (should be squashed)
