# Runtime Safety Rules Reference

## Loading / Empty / Error State Coverage

Every page or view that fetches data must handle **all three states**. Missing any of them creates a broken user experience.

### Missing Loading State

```typescript
// WRONG — data accessed before it's loaded, crashes on undefined
function OrdersPage() {
  const ordersQuery = useOrdersQuery();
  return <DataTable data={ordersQuery.data.items} />; // data is undefined during loading
}

// CORRECT — show loading indicator
function OrdersPage() {
  const ordersQuery = useOrdersQuery();

  if (ordersQuery.isLoading) return <PageLoader />;

  return <DataTable data={ordersQuery.data.items} />;
}
```

### Missing Empty State

```typescript
// WRONG — no feedback when list is empty, user sees blank screen
function OrdersPage() {
  const ordersQuery = useOrdersQuery();

  if (ordersQuery.isLoading) return <PageLoader />;

  return <DataTable data={ordersQuery.data.items} />;
}

// CORRECT — show empty state
function OrdersPage() {
  const ordersQuery = useOrdersQuery();

  if (ordersQuery.isLoading) return <PageLoader />;

  return (
    <Conditional.If condition={ordersQuery.data.items.length > 0} fallback={<EmptyState />}>
      <DataTable data={ordersQuery.data.items} />
    </Conditional.If>
  );
}
```

### Missing Error State

```typescript
// WRONG — error silently ignored, user sees blank or stale data
function OrdersPage() {
  const ordersQuery = useOrdersQuery();

  if (ordersQuery.isLoading) return <PageLoader />;

  return <DataTable data={ordersQuery.data.items} />;
}

// CORRECT — show error state
function OrdersPage() {
  const ordersQuery = useOrdersQuery();

  if (ordersQuery.isLoading) return <PageLoader />;
  if (ordersQuery.isError) return <ErrorState message={ordersQuery.error.message} />;

  return <DataTable data={ordersQuery.data.items} />;
}
```

### Checklist for Every Data-Fetching Component

| State | What to show |
|-------|-------------|
| `isLoading` | Skeleton, spinner, or `<PageLoader />` |
| `isError` | Error message, retry button, or `<ErrorState />` |
| `data` is empty | Empty state illustration, "No results" message |
| `data` is populated | The actual content |

## Security

### XSS via dangerouslySetInnerHTML

```typescript
// WRONG — unsanitized HTML from user or API
<div dangerouslySetInnerHTML={{ __html: userComment }} />

// CORRECT — sanitize first (e.g., DOMPurify)
import DOMPurify from 'dompurify';
<div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userComment) }} />

// BEST — avoid dangerouslySetInnerHTML entirely if possible
// Use a safe rich text renderer (e.g., Lexical's read-only mode)
```

Flag **every** usage of `dangerouslySetInnerHTML`. If the content comes from user input or an API, it MUST be sanitized.

### Open Redirect

```typescript
// WRONG — user-controlled value used in navigation without validation
const redirectUrl = searchParams.get('redirect');
navigate(redirectUrl); // attacker can set redirect=https://evil.com

// CORRECT — validate against allowlist
const redirectUrl = searchParams.get('redirect');
if (redirectUrl?.startsWith('/')) {
  navigate(redirectUrl); // only allow relative paths
}
```

### Hardcoded Secrets

Flag any of these patterns in source files:

```typescript
// WRONG — all of these
const API_KEY = 'sk-abc123...';
const token = 'Bearer eyJhbG...';
headers: { Authorization: 'Basic dXNlcjpwYXNz' }
const password = 'admin123';
```

Secrets must come from environment variables, never committed to source.

### Sensitive Data in Console

```typescript
// WRONG — logging sensitive data
console.log('User token:', authToken);
console.log('Payment response:', paymentData);

// CORRECT — don't log sensitive data, or redact it
console.log('Payment completed for order:', orderId);
```

## Null Safety

### Non-null Assertion Abuse

The `!` operator tells TypeScript "trust me, this isn't null" — it hides bugs:

```typescript
// WRONG — will crash at runtime if user is undefined
const userName = user!.name;
const firstItem = items![0].title;

// CORRECT — proper narrowing
if (!user) return <Redirect to="/login" />;
const userName = user.name; // TypeScript knows it's defined

// CORRECT — optional chaining
const userName = user?.name ?? 'Unknown';
```

### Optional Chaining Without Fallback

```typescript
// RISKY — renders nothing if data is missing, no user feedback
<span>{order?.customer?.name}</span>

// BETTER — provide fallback
<span>{order?.customer?.name ?? t('common.unknown')}</span>
```
