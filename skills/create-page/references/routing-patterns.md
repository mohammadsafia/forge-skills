# Routing Patterns

## Lazy Loading

```typescript
import { lazy } from 'react';

const EntitiesPage = lazy(() => import('@pages/entities/EntitiesPage'));
const EntityDetailPage = lazy(() => import('@pages/entities/EntityDetailPage'));
```

## Route Configuration

```typescript
// src/routes/index.ts

export const ROUTES = {
  ENTITIES: {
    LIST: '/entities',
    DETAIL: '/entities/:id',
    CREATE: '/entities/create',
    EDIT: '/entities/:id/edit',
  },
} as const;
```

## Layout Wrapping

```tsx
// Public routes — MainLayout
<Route element={<MainLayout />}>
  <Route path={ROUTES.HOME} element={<HomePage />} />
</Route>

// Protected routes — DashboardLayout + AuthGuard
<Route element={<AuthGuard allowedRoles={['admin', 'operator']}><DashboardLayout /></AuthGuard>}>
  <Route path={ROUTES.ENTITIES.LIST} element={<EntitiesPage />} />
  <Route path={ROUTES.ENTITIES.DETAIL} element={<EntityDetailPage />} />
</Route>
```

## Nested Routes

```tsx
<Route path="entities">
  <Route index element={<EntitiesPage />} />
  <Route path=":id" element={<EntityDetailPage />} />
  <Route path="create" element={<EntityCreatePage />} />
  <Route path=":id/edit" element={<EntityEditPage />} />
</Route>
```

## Navigation

```typescript
// Programmatic navigation
const navigate = useNavigate();
navigate(ROUTES.ENTITIES.LIST);
navigate(ROUTES.ENTITIES.DETAIL.replace(':id', entityId));

// Link component
<Link to={ROUTES.ENTITIES.DETAIL.replace(':id', entity.id)}>
  {entity.name}
</Link>
```

## Dynamic Route Prefixing

The project uses `ALLOWED_PREFIXES` for dynamic route prefixing (e.g., `/en/entities`, `/ar/entities`). Ensure new routes work with this system.
