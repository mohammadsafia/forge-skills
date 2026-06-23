# Component Rules Reference

## Conditional Rendering

Always use the `Conditional` component — never `&&` or ternary for show/hide:

```typescript
// CORRECT
<Conditional.If condition={isVisible}>
  <MyComponent />
</Conditional.If>

<Conditional.If condition={hasData} fallback={<EmptyState />}>
  <DataList items={items} />
</Conditional.If>

// WRONG
{isVisible && <MyComponent />}
{hasData ? <DataList /> : <EmptyState />}
{isVisible ? <MyComponent /> : null}
```

## cn() for Conditional Classes

Use `cn()` utility — never template literal concatenation:

```typescript
// CORRECT
className={cn('base-class', isActive && 'active-class', size === 'lg' && 'text-lg')}

// WRONG
className={`base-class ${isActive ? 'active-class' : ''}`}
className={'base-class ' + (isActive ? 'active-class' : '')}
```

## Event Handler Naming

All event handlers must use `handle*` prefix:

```typescript
// CORRECT
const handleSubmit = () => { ... };
const handleDelete = (id: string) => { ... };
const handleSearchChange = (query: string) => { ... };

// WRONG
const onSubmit = () => { ... };
const deleteItem = () => { ... };
const submit = () => { ... };
```

## Component Internal Code Order

```typescript
function MyComponent() {
  // 1. Core hooks (navigate, params, location)
  const navigate = useNavigate();
  const { id } = useParams();

  // 2. Context hooks
  const { theme } = useTheme();
  const { user } = useAuth();

  // 3. Shared utility hooks
  const { toast } = useToast();
  const { t } = useAppTranslation('feature');

  // 4. Query/mutation hooks
  const ordersQuery = useOrdersQuery();
  const createOrderMutation = useCreateOrderMutation();

  // 5. Component state
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState('');

  // 6. Memo/computed values
  const filteredItems = useMemo(() => data?.filter(...), [data]);

  // 7. Callbacks (handle* prefix)
  const handleSubmit = useCallback(() => { ... }, []);

  // 8. Effects
  useEffect(() => { ... }, []);

  // 9. JSX return
  return <div>...</div>;
}
```

## Page vs View

- Pages (`src/pages/`) are route-level and contain logic directly
- Views (`src/views/`) are for reusable feature components used across multiple pages
- Never create a View just to wrap a page

```typescript
// CORRECT — logic in page
function OrdersPage() {
  const ordersQuery = useOrdersQuery();
  return <div>...</div>;
}

// WRONG — View wrapper
function OrdersPage() {
  return <OrdersView />; // Unnecessary wrapping
}
```

## View Component Organization

Each view component must be in its own folder with an `index.ts`:

```
views/
└── communities/
    ├── community-card/
    │   ├── CommunityCard.tsx
    │   └── index.ts              # export { default as CommunityCard } from './CommunityCard'
    ├── community-list/
    │   ├── CommunityList.tsx
    │   └── index.ts
    ├── CommunitiesView.tsx        # Main view (can be at root level)
    └── index.ts                   # export * from './community-card'; etc.
```

## Component Size Limits

- If JSX exceeds ~150 lines, break into sub-components
- Extract repeated JSX blocks (3+ usages) into their own component
- Prefer composition (children/slots) over configuration (many boolean props)

## Folder Naming

All folders use kebab-case:

```
views/communities/community-card/    CORRECT
views/Communities/CommunityCard/     WRONG (PascalCase)
```

## No Separator Comments

Code should be self-organizing. Never use visual dividers:

```typescript
// WRONG
// ──────────────────────────
// ============================
// ---------------------
```

## data-slot Attributes

Add `data-slot` attributes to semantic elements in shared components:

```typescript
<header data-slot="card-header" className={cn('p-4', className)}>
  {children}
</header>
```

## Routing Patterns

- Use `React.lazy` for lazy-loaded pages
- Route constants must use `as const`
- Use `AuthGuard` to wrap protected routes
- Nested route structure with layout components (`MainLayout`, `DashboardLayout`)
