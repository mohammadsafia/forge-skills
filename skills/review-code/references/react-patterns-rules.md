# React Patterns & Performance Rules Reference

## Memoization Issues

### Missing useMemo / useCallback

When a parent re-renders, every inline function or object reference is recreated. If passed as a prop to a child wrapped in `React.memo` or used in a dependency array, this causes unnecessary re-renders or re-runs.

```typescript
// WRONG — new object reference every render, child re-renders needlessly
function OrdersPage() {
  const columns = [{ id: 'name', header: 'Name' }]; // recreated every render
  return <DataTable columns={columns} />;
}

// CORRECT — stable reference
function OrdersPage() {
  const columns = useMemo(() => [{ id: 'name', header: 'Name' }], []);
  return <DataTable columns={columns} />;
}
```

```typescript
// WRONG — new function reference every render
function OrdersPage() {
  const handleDelete = (id: string) => deleteMutation.mutateAsync(id);
  return <OrderList onDelete={handleDelete} />;
}

// CORRECT — stable reference
function OrdersPage() {
  const handleDelete = useCallback(
    (id: string) => deleteMutation.mutateAsync(id),
    [deleteMutation]
  );
  return <OrderList onDelete={handleDelete} />;
}
```

### Inline Objects/Arrays in JSX Props

Objects or arrays created inline in JSX always produce a new reference:

```typescript
// WRONG — new array every render
<Select options={['active', 'inactive', 'pending']} />
<div style={{ marginTop: 8 }} />

// CORRECT — move outside component or memoize
const STATUS_OPTIONS = ['active', 'inactive', 'pending'] as const;

function MyComponent() {
  return <Select options={STATUS_OPTIONS} />;
}
```

## Dependency Array Issues

### Missing Dependencies (Stale Closures)

```typescript
// WRONG — stale `count` value captured in closure
const [count, setCount] = useState(0);
useEffect(() => {
  const interval = setInterval(() => {
    setCount(count + 1); // always uses initial count
  }, 1000);
  return () => clearInterval(interval);
}, []); // missing `count` dependency

// CORRECT — use functional updater
useEffect(() => {
  const interval = setInterval(() => {
    setCount(prev => prev + 1);
  }, 1000);
  return () => clearInterval(interval);
}, []);
```

### Extra Dependencies

```typescript
// WRONG — `navigate` in deps causes re-run on every render in some React Router versions
useEffect(() => {
  if (!user) navigate('/login');
}, [user, navigate]); // navigate can be unstable

// CORRECT — only depend on what actually changes
const navigate = useNavigate();
useEffect(() => {
  if (!user) navigate('/login');
  // eslint-disable-next-line react-hooks/exhaustive-deps
}, [user]);
```

## Derived State Anti-Pattern

Using `useState` + `useEffect` to compute a value from other state/props when `useMemo` or a plain `const` would suffice:

```typescript
// WRONG — unnecessary state + effect for derived value
const [filteredItems, setFilteredItems] = useState<Item[]>([]);
useEffect(() => {
  setFilteredItems(items.filter(item => item.status === filter));
}, [items, filter]);

// CORRECT — compute directly
const filteredItems = useMemo(
  () => items.filter(item => item.status === filter),
  [items, filter]
);

// ALSO CORRECT — if computation is cheap, skip useMemo entirely
const filteredItems = items.filter(item => item.status === filter);
```

**Rule of thumb**: If the value is computed purely from existing state/props and involves no side effects, it should NOT be in `useState`.

## Memory Leaks in Effects

### Uncleaned Timers

```typescript
// WRONG — interval keeps running after unmount
useEffect(() => {
  setInterval(() => fetchStatus(), 5000);
}, []);

// CORRECT — cleanup function clears interval
useEffect(() => {
  const id = setInterval(() => fetchStatus(), 5000);
  return () => clearInterval(id);
}, []);
```

### Uncleaned Event Listeners

```typescript
// WRONG — listener accumulates on every re-render
useEffect(() => {
  window.addEventListener('resize', handleResize);
}, []);

// CORRECT — remove on cleanup
useEffect(() => {
  window.addEventListener('resize', handleResize);
  return () => window.removeEventListener('resize', handleResize);
}, [handleResize]);
```

### Uncleaned Subscriptions

```typescript
// WRONG — subscription never unsubscribed
useEffect(() => {
  const sub = eventBus.subscribe('order-update', handleUpdate);
}, []);

// CORRECT
useEffect(() => {
  const sub = eventBus.subscribe('order-update', handleUpdate);
  return () => sub.unsubscribe();
}, [handleUpdate]);
```

## Key Prop Issues

### Index as Key on Dynamic Lists

```typescript
// WRONG — index as key on a list that can reorder/filter
{orders.map((order, index) => (
  <OrderCard key={index} order={order} />
))}

// CORRECT — use stable unique identifier
{orders.map(order => (
  <OrderCard key={order.id} order={order} />
))}
```

Using index as key is acceptable ONLY for:
- Static lists that never reorder, filter, or insert
- Lists with no component state or uncontrolled inputs

### Missing Key

```typescript
// WRONG — no key at all
{orders.map(order => <OrderCard order={order} />)}

// CORRECT
{orders.map(order => <OrderCard key={order.id} order={order} />)}
```

## Suspense & Error Boundaries

### Lazy Without Suspense

```typescript
// WRONG — lazy component without Suspense fallback
const OrdersPage = React.lazy(() => import('./pages/OrdersPage'));

function App() {
  return <OrdersPage />; // will crash if chunk hasn't loaded
}

// CORRECT
function App() {
  return (
    <Suspense fallback={<PageLoader />}>
      <OrdersPage />
    </Suspense>
  );
}
```

### Missing Error Boundary

Async pages and features that fetch data should have error boundaries to prevent a single failure from crashing the entire app.

## Prop Drilling

When data passes through 3+ component levels without being used by intermediate components, it's prop drilling:

```typescript
// WRONG — theme passed through 3 levels
<OrdersPage theme={theme}>         // passes through
  <OrderList theme={theme}>        // passes through
    <OrderCard theme={theme}>      // actually uses it
```

**Fix**: Use Context, or restructure with composition (render props / children).
