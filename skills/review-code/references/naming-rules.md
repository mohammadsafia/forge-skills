# Naming Conventions Reference

## File Naming

| Category | File Name Convention | Example |
|----------|---------------------|---------|
| **Pages** | PascalCase + `Page` suffix | `CommunitiesPage.tsx`, `CommunityDetailPage.tsx` |
| **View components** | PascalCase | `CommunityCard.tsx`, `CommunityForm.tsx`, `CommunitiesView.tsx` |
| **Shared components** | PascalCase | `PrimeDialog.tsx`, `ActionPanel.tsx`, `StatusBadge.tsx` |
| **UI components** | PascalCase (shadcn/ui) | `Button.tsx`, `Input.tsx`, `Dialog.tsx` |
| **Form components** | PascalCase | `FormInput.tsx`, `FormSelect.tsx`, `FormContainer.tsx` |
| **Table components** | PascalCase | `DataTable.tsx`, `TablePagination.tsx` |
| **Icon components** | PascalCase | `HeroCheckmark.tsx`, `DataDubaiLogo.tsx` |
| **DTO files** | PascalCase + `Dto` suffix | `CommunityDto.ts`, `OrderDto.ts`, `UserDto.ts` |
| **Handler files** | kebab-case | `community.ts`, `order.ts`, `user-profile.ts` |
| **Query hook files** | camelCase starting with `use` | `useCommunityQuery.ts`, `useOrdersQuery.ts` |
| **Mutation hook files** | camelCase starting with `use` | `useCommunityMutation.ts`, `useCreateOrderMutation.ts` |
| **Shared hook files** | camelCase starting with `use` | `useDebounce.ts`, `useDate.ts`, `useAppTranslation.ts` |
| **Context files** | PascalCase + `Context` suffix | `AuthContext.tsx`, `ThemeContext.tsx` |
| **Util files** | camelCase | `formatDate.ts`, `pathBuilder.ts`, `cn.ts` |
| **Constant files** | camelCase or kebab-case | `roles.ts`, `order-status.ts` |
| **Validation/schema files** | camelCase | `schemas.ts` (inside `views/<feature>/`) |
| **Config files** | PascalCase or camelCase | `ApiEndpoints.ts`, `HttpClient.ts`, `QueryClient.ts` |
| **Barrel exports** | always `index.ts` | `index.ts` |
| **Locale files** | lowercase language code | `en.json`, `ar.json` |

## Folder Naming

**All folders use kebab-case — NEVER PascalCase:**

```
src/views/communities/community-card/     CORRECT
src/views/Communities/CommunityCard/      WRONG

src/components/shared/prime-dialog/       CORRECT
src/components/shared/PrimeDialog/        WRONG

src/pages/user-profile/                   CORRECT
src/pages/UserProfile/                    WRONG
```

## Export Naming

| Category | Export Name Convention | Example |
|----------|----------------------|---------|
| **Components** | PascalCase (default export) | `export default CommunityCard` |
| **Hooks** | camelCase starting with `use` | `export const useCommunityQuery = ...` |
| **Handler objects** | camelCase + `Handler` suffix | `export const communityHandler = { ... }` |
| **Handler request functions** | camelCase verb + entity | `getCommunityList`, `createCommunity`, `updateCommunity`, `deleteCommunity` |
| **Contexts** | PascalCase + `Context` | `export const AuthContext = createContext(...)` |
| **Context hooks** | camelCase `use` + name | `export const useAuth = () => useContext(AuthContext)` |
| **Context providers** | PascalCase + `Provider` | `export const AuthProvider = ({ children }) => ...` |
| **Constants** | UPPER_SNAKE_CASE | `export const ORDER_STATUS = { ... }`, `export const ROLES = { ... }` |
| **Route constants** | UPPER_SNAKE_CASE nested | `ROUTES.COMMUNITIES.LIST`, `ROUTES.ORDERS.DETAIL` |
| **Enums** | PascalCase | `enum OrderStatus { Pending = 'pending' }` |
| **Type aliases** | PascalCase | `type OrderForReadDto = { ... }` |
| **Utility functions** | camelCase | `export function formatCurrency(...)`, `export function pathBuilder(...)` |
| **Icon components** | PascalCase (default export) | `export default function HeroCheckmark(props)` |
| **Zod schemas** | camelCase + `Schema` suffix | `const communityFormSchema = z.object({ ... })` |
| **Zod inferred types** | PascalCase + `FormValues` | `type CommunityFormValues = z.infer<typeof communityFormSchema>` |

## DTO Naming

| Suffix | Purpose | Example |
|--------|---------|---------|
| `ForReadDto` | GET response (single item) | `CommunityForReadDto` |
| `ForCreateDto` | POST payload | `CommunityForCreateDto` |
| `ForUpdateDto` | PUT/PATCH payload | `CommunityForUpdateDto` |
| `ListDto` | Single item in a list response | `CommunityListDto` |
| `ListResponseDto` | Full paginated list wrapper | `CommunityListResponseDto` |
| `ParamsDto` | Query/filter parameters | `CommunitiesListParamsDto` |

Nested sub-objects get their own named type:
```typescript
// CORRECT
type CommunityMetadataDto = { ... };
type CommunityForReadDto = {
  metadata: CommunityMetadataDto;
};

// WRONG — anonymous inline
type CommunityForReadDto = {
  metadata: { weight: number; dimensions: string };
};
```

## Hook Naming

Hooks always use **camelCase** starting with `use` — never kebab-case or PascalCase:

```typescript
// CORRECT
useCommunityQuery
useCreateOrderMutation
useDebounce
useAppTranslation
useDate
useTime
useToast

// WRONG
use-community-query     // kebab-case
UseCommunityQuery       // PascalCase
communityQuery          // missing use prefix
getCommunityHook        // wrong prefix
```

### Query hook naming:
- List query: `use<Entity>Query` or `use<Entities>Query` → `useCommunitiesQuery`, `useOrdersQuery`
- Detail query: `use<Entity>ByIdQuery` → `useCommunityByIdQuery`, `useOrderByIdQuery`
- Filtered query: `use<Entity><Filter>Query` → `useOrdersByStatusQuery`

### Mutation hook naming:
- Create: `useCreate<Entity>Mutation` → `useCreateCommunityMutation`
- Update: `useUpdate<Entity>Mutation` → `useUpdateCommunityMutation`
- Delete: `useDelete<Entity>Mutation` → `useDeleteCommunityMutation`
- Generic: `use<Entity>Mutation` when a single file exports multiple mutations

## Handler queryKey Naming

queryKeys use kebab-case with slash separator:
```typescript
// CORRECT
queryKey: 'communities/list'
queryKey: 'communities/detail'
mutationKey: 'communities/create'
mutationKey: 'communities/update'
mutationKey: 'communities/delete'

// WRONG
queryKey: 'communitiesList'        // camelCase
queryKey: 'communities_list'       // snake_case
queryKey: ['communities', 'list']  // array (must be string)
```

## Event Handler Naming

All event handlers use `handle` prefix + action:
```typescript
// CORRECT
handleSubmit
handleDelete
handleSearchChange
handleToggleFilter
handleCloseDialog

// WRONG
onSubmit           // on* is for props, not internal handlers
deleteItem         // missing handle prefix
submit             // too generic, missing handle prefix
```

## API Endpoint Naming

Endpoint constants use UPPER_SNAKE_CASE, nested by domain:
```typescript
export const ApiEndpoints = {
  COMMUNITIES: {
    LIST: '/communities',
    BY_ID: '/communities/:id',
    CREATE: '/communities',
    UPDATE: '/communities/:id',
    DELETE: '/communities/:id',
  },
  USERS: {
    LIST: '/users',
    BY_ID: '/users/:id',
  },
} as const;
```

## Translation Key Naming

Dot-separated, nested by feature:
```json
{
  "communities": {
    "title": "Communities",
    "create": "Create Community",
    "fields": {
      "name": "Community Name",
      "description": "Description"
    }
  }
}
```

## Common Violations

| Violation | Fix |
|-----------|-----|
| `use-community-query.ts` | `useCommunityQuery.ts` (camelCase, no hyphens) |
| `CommunityQuery.ts` for a hook | `useCommunityQuery.ts` (must start with `use`) |
| `communityHandler.ts` | `community.ts` (handler files are kebab-case, no suffix) |
| `CommunityCard/` folder | `community-card/` (folders are kebab-case) |
| `orderDTO.ts` | `OrderDto.ts` (PascalCase `Dto`, not all-caps `DTO`) |
| `CreateOrder.ts` for mutation hook | `useCreateOrderMutation.ts` (must start with `use`, include `Mutation`) |
| `auth-context.tsx` | `AuthContext.tsx` (context files are PascalCase) |
| `CONSTANTS.ts` | `roles.ts` or `order-status.ts` (file is kebab/camelCase, exports are UPPER_SNAKE) |
| `queryKey: ['orders', 'list']` | `queryKey: 'orders/list'` (must be a string) |
| `onDelete` for internal handler | `handleDelete` (`on*` is for callback props, `handle*` for internal) |
