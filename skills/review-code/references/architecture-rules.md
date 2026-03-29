# Architecture Rules Reference

These checks verify that the code is well-structured — proper separation of concerns, clean abstractions, correct data flow, and resilience.

## IMPORTANT: Verification Method

For every check below, you MUST read the actual code to verify. Count real lines, read real implementations, check real imports. Do NOT estimate or assume — if you cannot verify, state "could not verify."

---

## 1. Separation of Concerns

### Business logic inside JSX return

**How to detect:**
1. Read the component's `return (...)` JSX block
2. Look for inline expressions that compute, transform, or filter data:
   - `.filter(...)`, `.map(...)` with transformation logic, `.reduce(...)`
   - Ternary chains longer than a simple condition
   - Math operations, string formatting, date calculations
3. These should be extracted to `useMemo`, `useCallback`, or a `const` above the return

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

```
Warning: Business logic (filter + sort + format) inline in JSX return at `OrdersPage.tsx:45-52` — extract to useMemo/const above the return
```

### API response transformation in component

**How to detect:**
1. Find places where query `data` is transformed before rendering
2. If the transformation is non-trivial (more than a simple `.map` to JSX), it should be:
   - In the handler's request function (transform before returning)
   - In a `select` option on the query
   - In a dedicated mapper utility

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

```
Warning: Non-trivial API response transformation at `OrdersPage.tsx:18-23` — move to query `select` option or handler
```

### Duplicated validation logic

**How to detect:**
1. Find manual validation in components (e.g., `if (value.length > 50)`, `if (!email.includes('@'))`)
2. Check if the same field is already validated by a Zod schema
3. If yes, the manual check is redundant and can diverge from the schema

```
Warning: Manual validation `value.length > 50` at `CommunityForm.tsx:32` duplicates Zod schema `name: z.string().max(50)` — remove manual check, rely on schema
```

### Mixed concerns in useEffect

**How to detect:**
1. Read each `useEffect` in the component
2. Check if a single `useEffect` does multiple unrelated things (e.g., fetches data AND sets up event listeners AND updates document title)
3. Each `useEffect` should have one clear purpose

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

```
Warning: `useEffect` at `OrdersPage.tsx:30` handles 3 unrelated concerns (document title, resize listener, filter) — split into separate effects
```

---

## 2. Abstraction Quality

### Too many boolean props (flag component)

**How to detect:**
1. Read the component's prop type definition
2. Count boolean props (`showHeader`, `hideFooter`, `isCompact`, `withIcon`, `noActions`, etc.)
3. If 5+ boolean props, the component is a "flag component" — it should be a compound component or separate components

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

```
Warning: `OrderCard` at `OrderCard.tsx:8` has 6 boolean props — consider compound component pattern or breaking into separate components
```

### Too many function parameters

**How to detect:**
1. Find function declarations with 4+ parameters
2. Should use an options/config object instead

```typescript
// WRONG — 5 positional parameters
function createOrder(name: string, status: string, total: number, userId: string, note?: string) {}

// CORRECT — options object
type CreateOrderOptions = { name: string; status: OrderStatus; total: number; userId: string; note?: string };
function createOrder(options: CreateOrderOptions) {}
```

```
Warning: `createOrder` at `OrdersPage.tsx:20` has 5 parameters — use an options object
```

### Passthrough wrapper component

**How to detect:**
1. Find components whose JSX return is just a single child component with all props forwarded
2. If the wrapper adds no logic, no styling, and no structure — it's unnecessary

```typescript
// WRONG — wrapper adds nothing
function OrderCardWrapper(props: OrderCardProps) {
  return <OrderCard {...props} />;
}
```

```
Suggestion: `OrderCardWrapper` at `OrderCardWrapper.tsx` passes all props through to `OrderCard` — unnecessary wrapper, use `OrderCard` directly
```

### God component

**How to detect:**
1. Check if a single component handles multiple modes/screens via flags or state
2. Signs: `mode === 'create'`, `mode === 'edit'`, `mode === 'view'`, `isListView && ...`, `isDetailView && ...`
3. Each mode should typically be a separate component

```
Warning: `CommunityPage.tsx` handles list, detail, create, and edit modes in a single component (detected mode flags at lines 15, 42, 68, 95) — split into separate page components
```

---

## 3. Data Flow Architecture

### Child directly accessing queryClient

**How to detect:**
1. Search reviewed component files for `useQueryClient()` imports
2. If a child component (not a page) calls `queryClient.invalidateQueries()` directly, it's breaking encapsulation
3. The parent or the mutation hook should handle invalidation

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

```
Warning: `OrderCard.tsx:12` calls `useQueryClient()` and invalidates queries directly — invalidation should be in the mutation hook, not the view component
```

### Cross-feature handler import

**How to detect:**
1. Read import statements in each reviewed file
2. A component in `views/orders/` should NOT import handlers from `src/api/handlers/community.ts` directly
3. It should go through a hook: `useCommunityQuery` (which internally uses the handler)

```
Warning: `OrderDetail.tsx:5` imports `communityHandler` directly from `@api/handlers` — use `useCommunityQuery` hook instead of accessing another feature's handler
```

### Circular dependencies

**How to detect:**
1. For each reviewed file, read its imports
2. Then read the imported file's imports
3. If file A imports from file B and file B imports from file A (directly or through barrels), it's circular

```
Error: Circular dependency detected — `OrderCard.tsx` imports from `CommunityCard.tsx` which imports from `OrderCard.tsx`
```

### Context provider scope too wide

**How to detect:**
1. Find Context providers in the reviewed files
2. Check how high in the component tree they're placed
3. If a provider wraps the entire app but only 1-2 components consume it, it's over-scoped

```
Suggestion: `CommunityFilterContext.Provider` wraps the entire `DashboardLayout` but only `CommunitiesPage` consumes it — move the provider closer to its consumers
```

---

## 4. Error Resilience

### Unguarded JSON.parse / localStorage

**How to detect:** Search reviewed files for:
- `JSON.parse(` without surrounding `try/catch`
- `localStorage.getItem(` where the result is used without null check
- `sessionStorage.getItem(` same as above
- `JSON.parse(localStorage.getItem(...))` — double risk (getItem can be null, parse can throw)

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

```
Error: `JSON.parse(localStorage.getItem('settings'))` at `ThemeContext.tsx:15` — will crash if value is null or malformed JSON. Wrap in try/catch.
```

### Deep optional chaining hiding structural problems

**How to detect:**
1. Search for optional chaining chains with 3+ `?.` operators
2. If accessing `data?.result?.items?.[0]?.metadata?.title`, the DTO is probably incorrectly typed — most of these fields shouldn't be optional

```
Warning: Deep optional chain `data?.result?.items?.[0]?.metadata?.title` at `OrderDetail.tsx:28` — 5 levels of optional access suggests the DTO types are too loose. Review which fields are truly optional.
```

### Async in useEffect without error handling

**How to detect:**
1. Find `useEffect` blocks that contain async operations
2. Check if the async operation has `.catch()` or is inside `try/catch`
3. Unhandled async errors in effects become unhandled promise rejections

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

```
Error: Async call `fetchInitialData()` in useEffect at `OrdersPage.tsx:25` has no `.catch()` or try/catch — unhandled promise rejection
```

### mutateAsync without try/catch

**How to detect:**
1. Search for `mutateAsync(` calls in components
2. `mutateAsync` returns a promise that rejects on error
3. If called without `try/catch` or `.catch()`, errors crash the handler (even if the hook has `onError`, `mutateAsync` still throws)

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

```
Error: `mutateAsync(data)` at `CommunityForm.tsx:44` called without try/catch — will throw unhandled error on failure. Use try/catch or switch to `mutate()`.
```

---

## 5. Bundle & Performance Architecture

### Heavy library imported at top level

**How to detect:**
1. Check imports for known heavy libraries used conditionally:
   - Chart libraries (`recharts`, `chart.js`) imported but only rendered in one tab/modal
   - Rich text editors (`lexical`, `@lexical/*`) imported but only shown on edit pages
   - PDF generators, date picker libraries, drag-and-drop libraries
2. If the import is at the top of a component that isn't always rendered, it should be `React.lazy` or dynamic `import()`

```
Suggestion: `recharts` imported at top of `DashboardPage.tsx:3` but chart only renders in analytics tab — consider lazy-loading the chart component
```

### Entire icon library imported

**How to detect:** Search for:
- `import * as Icons from 'lucide-react'`
- `import * as LucideIcons from 'lucide-react'`
- Any star import from an icon library

```
Error: `import * as Icons from 'lucide-react'` at `Sidebar.tsx:2` imports the entire icon library — import individual icons: `import { Home, Settings } from 'lucide-react'`
```

### Large constant inside component

**How to detect:**
1. Find arrays or objects with 10+ items defined inside a component function body (not at module level)
2. These are recreated on every render

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

```
Warning: Array with 10 items defined inside component body at `CommunitiesPage.tsx:15-28` — move to module level or useMemo to avoid recreation on every render
```

### Images without optimization

**How to detect:**
1. Find `<img>` tags in reviewed files
2. Check for:
   - Missing `width` and `height` attributes (causes layout shift)
   - Missing `loading="lazy"` for images below the fold
   - Very large images imported directly (check file extension and import path)

```
Warning: `<img>` at `CommunityCard.tsx:35` missing `width` and `height` — causes cumulative layout shift (CLS)
Warning: `<img>` at `CommunityCard.tsx:35` missing `loading="lazy"` — consider lazy loading for list item images
```

---

## 6. Testing Readiness

These checks don't require writing tests — they flag code that would be difficult or impossible to test.

### Hard dependency on browser APIs

**How to detect:** Search reviewed files for direct usage of:
- `window.location` (use `useNavigate` or `useLocation` instead)
- `window.innerWidth` (use a hook or media query)
- `document.getElementById` (use refs)
- `document.title =` (use a hook like `useDocumentTitle`)
- `window.addEventListener` directly in component body (not in useEffect)

```
Warning: `window.location.href = '/login'` at `AuthGuard.tsx:12` — use `useNavigate()` for testability and SPA routing
```

### Side effects at module scope

**How to detect:**
1. Read the top of each file (outside any function/component/hook)
2. Flag any code that runs on import:
   - API calls
   - `localStorage` reads
   - DOM manipulation
   - `console.log`
   - Anything other than: imports, type definitions, constants, function declarations

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

```
Error: `localStorage.getItem('settings')` executed at module scope in `config.ts:5` — moves to a hook or function for testability and SSR safety
```

### Untestable component logic

**How to detect:**
1. Find components where complex business logic (calculations, state machines, multi-step flows) is deeply nested inside JSX callbacks or effects
2. If the logic can't be extracted into a pure function or custom hook and tested independently, it's untestable

```
Suggestion: Complex filtering + sorting + grouping logic at `OrdersPage.tsx:30-55` is embedded in the component — extract to a `useFilteredOrders` hook or pure `filterOrders()` utility for independent testability
```

---

## 7. Backwards Compatibility

These checks apply when **modifying existing code** (not creating new files). Skip if the review scope is all new files.

### Exported type removed or renamed

**How to detect:**
1. Run `git diff main..HEAD` on type files
2. For any removed or renamed `export type`, search the entire `src/` for imports of the old name
3. If any file still imports the old name, it will break

```
Error: `OrderStatusDto` was renamed to `OrderStatus` in `OrderDto.ts` but `src/views/orders/OrderCard.tsx:3` still imports `OrderStatusDto`
```

### Prop removed from shared component

**How to detect:**
1. Run `git diff main..HEAD` on shared component files
2. For any removed prop from the type definition, search `src/` for usages of that prop on the component
3. Check both `<Component removedProp={...} />` and destructured usage

```
Error: Prop `showAvatar` removed from `CommunityCard` but `src/pages/communities/CommunitiesPage.tsx:45` still passes `showAvatar={true}`
```

### Handler queryKey changed

**How to detect:**
1. Run `git diff main..HEAD` on handler files
2. If a `queryKey` string was changed (e.g., `'communities/list'` → `'community/list'`)
3. Search `src/` for the old queryKey string — any remaining reference will break invalidation/caching

```
Error: queryKey changed from `'communities/list'` to `'community/list'` in handler but `useCommunityMutation.ts:15` still invalidates `'communities/list'`
```

### Context value shape changed

**How to detect:**
1. Run `git diff main..HEAD` on context files
2. If properties were removed or renamed in the context value type
3. Search `src/` for all consumers (`useContextName()`) and verify they don't access removed properties

```
Error: `AuthContext` no longer provides `userRole` (renamed to `role`) but `Sidebar.tsx:12` destructures `const { userRole } = useAuth()`
```

### Route path changed without redirect

**How to detect:**
1. Run `git diff main..HEAD` on route files
2. If a route path was changed, check if a redirect from the old path exists
3. Users may have bookmarked the old URL

```
Warning: Route changed from `/communities/:id` to `/community/:id` — add a redirect from the old path so bookmarks don't break
```
