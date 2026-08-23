# Component Rules Reference

> Most patterns here are Forge project conventions, not universal React requirements. Verify adoption in repository instructions or nearby code before reporting them.

## Conditional Rendering

When the project has adopted the `Conditional` component, prefer it for ordinary show/hide branches. Preserve inline conditionals when wrapper semantics would break mounting, focus, or exit animations:

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

When the project uses `cn()`, use it consistently for conditional classes:

```typescript
// CORRECT
className={cn('base-class', isActive && 'active-class', size === 'lg' && 'text-lg')}

// WRONG
className={`base-class ${isActive ? 'active-class' : ''}`}
className={'base-class ' + (isActive ? 'active-class' : '')}
```

## Event Handler Naming

When established locally, use `handle*` for internal handlers and reserve `on*` for callback props:

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

If the repository uses per-component folders and barrels, follow that structure:

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

Prefer meaningful structure over decorative divider comments when that is the local convention:

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
- When the project exposes route constants as literal values, preserve literal inference with `as const` or `satisfies` as appropriate
- Use `AuthGuard` to wrap protected routes
- Nested route structure with layout components (`MainLayout`, `DashboardLayout`)
