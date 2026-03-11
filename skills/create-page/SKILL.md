---
name: forge:create-page
description: "Create new pages with routing, lazy loading, and layout guards. Use when the user wants to add a new page, create a route, set up a new view with routing, or says 'create page', 'add new page', 'new route for', 'add page with guard', 'create dashboard page'. Triggers whenever a new route-level component needs to be set up."
---

# Create Page

Generate a new page component with route configuration, lazy loading, and layout guards.

## Step 1 — Gather Information

Ask the user if not provided:
- **Page name** (e.g., "Communities", "OrderDetail", "ProviderDashboard")
- **Route path** (e.g., `/communities`, `/orders/:id`)
- **Layout**: MainLayout (public) or DashboardLayout (admin/operator)
- **Protected?**: Does it need AuthGuard? Which roles?
- **Dynamic params**: Any URL params (`:id`, `:slug`)?

## Step 2 — Scan Existing Patterns

Before writing code, read:
1. `src/routes/index.ts` — route configuration structure
2. An existing page in `src/pages/` — mirror the pattern
3. Layout components in `src/layouts/` — understand MainLayout vs DashboardLayout
4. AuthGuard usage for protected routes

See `references/page-template.md` for the page component template.
See `references/routing-patterns.md` for route configuration patterns.

## Step 3 — Generate Files

### 3a. Create Page Component

File: `src/pages/<feature>/<FeaturePage>.tsx`

```typescript
function FeaturePage() {
  // 1. Core hooks (navigate, params)
  // 2. Context hooks
  // 3. Shared utility hooks
  // 4. Query/mutation hooks
  // 5. Component state
  // 6. Memo/computed values
  // 7. Callbacks (handle* prefix)
  // 8. Effects
  // 9. JSX return
  return <div>...</div>;
}

export default FeaturePage;
```

### 3b. Add Route Configuration

Add to `src/routes/index.ts`:
- Use `React.lazy()` for the page import
- Wrap with appropriate layout
- Add AuthGuard if protected
- Route path as `const`

### 3c. Add Navigation (if needed)

Wire navigation from sidebar, navbar, or other entry points.

## Rules

- Pages are route-level — they contain feature logic directly
- Do NOT create a View just to wrap a page
- Use `React.lazy()` for lazy loading
- Follow component internal code order
- Use `Conditional.If` for conditional rendering
- Route paths must be constants using `as const`
- Folder name: kebab-case (`order-detail/`)
- Component file: PascalCase (`OrderDetailPage.tsx`)

## Reference Files

- `references/page-template.md` — Page component template
- `references/routing-patterns.md` — Route config patterns
