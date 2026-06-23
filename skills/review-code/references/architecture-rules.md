> Rules: see `_shared/code-standards.md`. This file contains code examples only.

# Architecture Rules — Code Examples

## Separation of Concerns

### Business logic inside JSX return

```typescript
// WRONG — filtering and transforming inside JSX
return (
  <div>
    {orders
      .filter(o => o.status === 'active' && o.total > 100)
      .sort((a, b) => b.createdAt - a.createdAt)
      .map(o => (
        <OrderCard key={o.id} order={o} total={`$${(o.total / 100).toFixed(2)}`} />
      ))}
  </div>
);

// CORRECT — logic extracted above JSX
const activeHighValueOrders = useMemo(
  () => orders
    .filter(o => o.status === 'active' && o.total > 100)
    .sort((a, b) => b.createdAt - a.createdAt),
  [orders]
);

const formatTotal = (cents: number): string => `$${(cents / 100).toFixed(2)}`;

return (
  <div>
    {activeHighValueOrders.map(o => (
      <OrderCard key={o.id} order={o} total={formatTotal(o.total)} />
    ))}
  </div>
);
```

### API response transformation in component

```typescript
// WRONG — complex transformation in component
const { data } = useOrdersQuery();
const orders = data?.items.map(item => ({
  ...item,
  fullName: `${item.firstName} ${item.lastName}`,
  formattedDate: new Date(item.createdAt).toLocaleDateString(),
  statusLabel: STATUS_MAP[item.status],
}));

// CORRECT — transformation in the query's select or handler
export const useOrdersQuery = () => {
  return useQuery({
    queryKey: [handler.getList.queryKey],
    queryFn: () => handler.getList.request(),
    select: (data) => ({
      ...data,
      items: data.items.map(transformOrder),
    }),
  });
};
```

### Mixed concerns in useEffect

```typescript
// WRONG — three unrelated concerns in one effect
useEffect(() => {
  document.title = `Orders - ${user.name}`;
  window.addEventListener('resize', handleResize);
  if (filter) setGlobalFilter(filter);
  return () => window.removeEventListener('resize', handleResize);
}, [user.name, filter]);

// CORRECT — separate effects
useEffect(() => {
  document.title = `Orders - ${user.name}`;
}, [user.name]);

useEffect(() => {
  window.addEventListener('resize', handleResize);
  return () => window.removeEventListener('resize', handleResize);
}, [handleResize]);

useEffect(() => {
  if (filter) setGlobalFilter(filter);
}, [filter, setGlobalFilter]);
```

## Abstraction Quality

### Too many boolean props

```typescript
// WRONG — 6 boolean flags
type CardProps = {
  showHeader: boolean;
  showFooter: boolean;
  isCompact: boolean;
  hideActions: boolean;
  withBorder: boolean;
  showAvatar: boolean;
};

// CORRECT — compound pattern or composition
<Card>
  <Card.Header />
  <Card.Content />
  <Card.Footer>
    <Card.Actions />
  </Card.Footer>
</Card>
```

### Too many function parameters

```typescript
// WRONG — 5 positional parameters
function createOrder(name: string, status: string, total: number, userId: string, note?: string) {}

// CORRECT — options object
type CreateOrderOptions = { name: string; status: OrderStatus; total: number; userId: string; note?: string };
function createOrder(options: CreateOrderOptions) {}
```

### Passthrough wrapper component

```typescript
// WRONG — wrapper adds nothing
function OrderCardWrapper(props: OrderCardProps) {
  return <OrderCard {...props} />;
}
```

## Data Flow Architecture

### Child directly accessing queryClient

```typescript
// WRONG — child component directly invalidates cache
function OrderCard({ order }: OrderCardProps) {
  const queryClient = useQueryClient();
  const handleDelete = () => {
    deleteOrder(order.id);
    queryClient.invalidateQueries({ queryKey: ['orders/list'] });
  };
}

// CORRECT — mutation hook handles invalidation, or parent passes callback
function OrderCard({ order, onDelete }: OrderCardProps) {
  const handleDelete = () => onDelete(order.id);
}
```

## Error Resilience

### Unguarded JSON.parse / localStorage

```typescript
// WRONG — crashes if value is null or malformed
const settings = JSON.parse(localStorage.getItem('settings'));

// CORRECT — handle both null and parse failure
function getStoredSettings(): Settings | null {
  try {
    const raw = localStorage.getItem('settings');
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}
```

### Async in useEffect without error handling

```typescript
// WRONG — unhandled rejection
useEffect(() => {
  fetchInitialData(); // async function, no error handling
}, []);

// CORRECT — catch errors
useEffect(() => {
  fetchInitialData().catch((error) => {
    toast({ variant: 'destructive', title: error.message });
  });
}, []);
```

### mutateAsync without try/catch

```typescript
// WRONG — mutateAsync throws on error, unhandled
const handleSubmit = async (data: FormValues) => {
  await createMutation.mutateAsync(data);
  navigate('/communities');
};

// CORRECT — catch the error
const handleSubmit = async (data: FormValues) => {
  try {
    await createMutation.mutateAsync(data);
    navigate('/communities');
  } catch {
    // onError in the hook handles the toast
  }
};

// ALSO CORRECT — use mutate instead (doesn't throw)
const handleSubmit = (data: FormValues) => {
  createMutation.mutate(data, {
    onSuccess: () => navigate('/communities'),
  });
};
```

## Bundle & Performance

### Large constant inside component

```typescript
// WRONG — recreated every render
function CommunitiesPage() {
  const statusOptions = [
    { value: 'active', label: 'Active', color: 'success' },
    { value: 'inactive', label: 'Inactive', color: 'warning' },
    // ... 8 more items
  ];
}

// CORRECT — module-level constant
const STATUS_OPTIONS = [
  { value: 'active', label: 'Active', color: 'success' },
  // ...
] as const;

function CommunitiesPage() {
  // uses STATUS_OPTIONS
}
```

## Testing Readiness

### Side effects at module scope

```typescript
// WRONG — runs on import
const userSettings = JSON.parse(localStorage.getItem('settings')!);
axios.defaults.baseURL = getBaseUrl();

// CORRECT — inside a function/hook/component
function useUserSettings() {
  return useMemo(() => {
    try {
      const raw = localStorage.getItem('settings');
      return raw ? JSON.parse(raw) : DEFAULT_SETTINGS;
    } catch {
      return DEFAULT_SETTINGS;
    }
  }, []);
}
```

## Backwards Compatibility (when modifying existing files)

- Exported type removed/renamed → search `src/` for imports of old name
- Prop removed from shared component → search `src/` for usages
- Handler queryKey string changed → search `src/` for old key references
- Context value property removed/renamed → search for all consumers
- Route path changed → add redirect from old path
