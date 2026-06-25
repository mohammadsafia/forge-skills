---
name: forge:review-code
description: "Review code against project standards and best practices. Use this skill when the user asks to review code, check code quality, audit a file, validate standards compliance, or says things like 'review this', 'check my code', 'is this correct', 'audit this file', 'does this follow our standards'. Also use when the user has finished implementing something and wants verification before committing."
---

# Review Code

Systematically review code files against project standards, run all audit skills, and output a structured report with file:line references.

## Workflow

### Step 1 — Determine Scope

Figure out what to review:
- If the user mentions specific files → review those files
- If the user says "review my changes" → run `git diff --name-only` and `git diff --staged --name-only` to find changed files
- If the user says "review this PR" → run `git diff main...HEAD --name-only` to find all changed files in the branch

### Step 2 — Read Each File and Check Against Rules

Use `_shared/code-standards.md` as the primary rule source (12 categories).
Use the reference files below for detailed wrong/correct code examples:

- `references/api-rules.md` — handler and hook code templates
- `references/component-rules.md` — component pattern examples
- `references/architecture-rules.md` — architecture violation examples
- `references/code-hygiene-rules.md` — hygiene violation examples
- `references/correctness-rules.md` — correctness violation examples
- `references/import-rules.md` — import pattern examples
- `references/naming-rules.md` — naming convention examples
- `references/reusability-rules.md` — reusability pattern examples
- `references/styling-rules.md` — styling violation examples
- `references/type-rules.md` — type pattern examples
- `references/react-patterns-rules.md` — React pattern examples
- `references/runtime-safety-rules.md` — runtime safety examples

For each file under review, check it against all 12 categories in `_shared/code-standards.md`.

**Import Rules** (see `references/import-rules.md`):
- UI components from barrel `@components/ui` only — not individual files
- Shared components from barrel `@components/shared` only
- Custom icons from `@assets/icons` barrel only
- Path aliases used everywhere — no deep relative imports (`../../`)
- Import order: React → third-party → UI → shared → views → contexts/hooks → utils/constants → icons → types
- `import type` for type-only imports
- One empty line between import groups, no empty lines within groups

**Type Rules** (see `references/type-rules.md`):
- `type` over `interface` (interface only for extension/merging)
- No `any`, no implicit types, no unsafe casting
- Exported functions have explicit return types (except React Query hooks — those infer)
- DTO naming: `ForReadDto`, `ForCreateDto`, `ForUpdateDto`, `ListDto`, `ParamsDto`
- Status/type fields use enums or type literals — never raw `string`
- Feature-specific Zod schemas go in `views/<feature>/Feature.schemas.ts` — NOT in `src/types/`
- DTOs live in `src/types/api/` and are exported through the barrel
- Nested sub-objects get their own named type — no inline object literals in DTOs
- Mark truly optional BE fields with `?` — don't make everything optional
- Reuse shared types (`ResultDto<T>`, `PrimaryImageForReadDto`, `EntityStatusForReadDto`, `CreatorForReadDto`) — don't redefine per feature
- Map BE snake_case to camelCase in DTOs

**Component Rules** (see `references/component-rules.md`):
- `Conditional.If` for show/hide — never `&&` or ternary for simple conditional rendering
- `cn()` for conditional classes — never template literal concatenation
- Event handlers named `handle*`
- Internal code order: core hooks → context → shared hooks → queries → state → memo → callbacks → effects → JSX
- Pages contain logic directly — no View wrappers just to wrap
- Only create a View when the same UI is reused across multiple pages
- Folders use kebab-case — never PascalCase
- No separator/divider comments (`// ----`, `// ====`)
- View components must be in their own folder with an `index.ts`
- If JSX exceeds ~150 lines, break into sub-components
- Extract repeated JSX blocks (3+ usages) into their own component

**Reusability Rules** (see `references/reusability-rules.md`):
- Shared components (`src/components/shared/`) must use the compound component pattern (unless simple leaf component)
- Sub-components MUST have: `className?` prop, `cn()` merging, `...props` spread, `data-slot` attribute, semantic HTML elements
- Use CVA for 3+ visual variants — use simple `cn()` conditionals for fewer
- CVA must have `defaultVariants`, semantic token colors, disabled and focus-visible styles in base
- Use `React.createContext` inside compound components ONLY when 3+ sub-components share state
- Use `forwardRef` ONLY for consumer-facing DOM access (inputs, buttons, triggers) — skip for containers/layouts
- Always set `displayName` when using `forwardRef`
- Default export from component file, barrel re-export from `index.ts`
- Before creating ANY new component, scan `ui/`, `shared/`, `forms/`, `tables/`, `views/` for existing implementations

**Styling Rules** (see `references/styling-rules.md`):
- Theme-aware classes only: `bg-background` not `bg-white`, `text-foreground` not `text-slate-900`
- Tailwind spacing scale — not arbitrary pixel values like `p-[24px]`
- No inline styles, no CSS files, no style tags
- Use project color tokens (blue-*, gray-*, error-*, success-*, warning-*, dda-blue-*, tokens-*) not Tailwind defaults (slate-*, zinc-*, stone-*, neutral-*)
- Use `font-sans` — no custom font declarations
- Mobile-first responsive: base styles for mobile, breakpoint overrides for larger
- Use existing shadow and border-radius tokens — no custom inline values

**API & Handler Rules** (see `references/api-rules.md`):
- Endpoints in `ApiEndpoints.ts` as plain strings — no function callbacks
- Handler `queryKey` is a string — not an array
- Request functions defined above handler object, referenced by name — not inlined
- React Query hooks have no explicit return types
- Wrap string queryKey in array inside hook: `queryKey: [handler.getList.queryKey]`
- Mutations must invalidate correct queries in `onSuccess`
- No duplicate server state: never copy React Query data into `useState`
- Handle errors in mutation `onError` with toast — never silently swallow
- Every API response must be typed with DTOs — no `any` or untyped responses

**Form Rules:**
- Must use FormProvider-based `FormContainer` — no raw `useForm` in pages
- No asterisks (`*`) in translation labels — `required` prop handles the indicator
- Feature-specific Zod schemas go in `views/<feature>/Feature.schemas.ts`

**State Management:**
- Local UI state → `useState`
- Server state → React Query (never duplicate into `useState`)
- Global UI state → Context (Auth, Theme, Products, Bookmarks)
- URL state → nuqs
- Use stable query keys; always invalidate after mutations

**Naming Conventions** (see `references/naming-rules.md`):
- Folders: always kebab-case (`community-card/` not `CommunityCard/`)
- Pages: PascalCase + `Page` suffix (`CommunitiesPage.tsx`)
- Components: PascalCase (`CommunityCard.tsx`, `PrimeDialog.tsx`)
- Hook files: camelCase starting with `use` (`useCommunityQuery.ts` not `use-community-query.ts` or `CommunityQuery.ts`)
- Query hooks: `use<Entity>Query`, `use<Entity>ByIdQuery`
- Mutation hooks: `useCreate<Entity>Mutation`, `useUpdate<Entity>Mutation`, `useDelete<Entity>Mutation`
- Handler files: kebab-case (`community.ts`, `user-profile.ts`)
- Handler exports: camelCase + `Handler` (`communityHandler`)
- Handler request functions: camelCase verb + entity (`getCommunityList`, `createCommunity`)
- Handler queryKey: kebab-case string with slash (`'communities/list'`, `'communities/detail'`)
- DTO files: PascalCase + `Dto` suffix (`CommunityDto.ts` not `communityDTO.ts`)
- Context files: PascalCase + `Context` (`AuthContext.tsx`)
- Context hooks: `use` + name (`useAuth`)
- Constants exports: UPPER_SNAKE_CASE (`ORDER_STATUS`, `ROLES`)
- Endpoint constants: UPPER_SNAKE_CASE nested (`ApiEndpoints.COMMUNITIES.LIST`)
- Route constants: UPPER_SNAKE_CASE with `as const`
- Zod schemas: camelCase + `Schema` (`communityFormSchema`)
- Zod inferred types: PascalCase + `FormValues` (`CommunityFormValues`)
- Event handlers: `handle*` prefix (`handleSubmit`, `handleDelete`) — `on*` is for callback props only
- Icon components: PascalCase default export (`HeroCheckmark.tsx`)
- Barrel exports: always `index.ts`

**React Patterns & Performance** (see `references/react-patterns-rules.md`):
- Missing `useMemo`/`useCallback` where a new reference on every render triggers child re-renders
- Objects or arrays created inline in JSX props (`options={[...]}`, `style={{...}}`) — move outside or memoize
- Missing dependency array items in `useEffect`/`useMemo`/`useCallback` (causes stale closures)
- Extra dependency array items that cause unnecessary re-runs
- Derived state anti-pattern: `useState` + `useEffect` to compute a value that should be `useMemo` or a plain `const`
- `useEffect` with `setInterval`/`setTimeout`/`addEventListener` missing cleanup return (memory leak)
- Subscriptions or observers opened in effects without unsubscribing on unmount
- Using array index as `key` in lists that can reorder, filter, or insert items
- Missing `key` prop entirely on mapped JSX elements
- `React.lazy` used without a wrapping `<Suspense>` with a fallback
- Async pages/features without an `<ErrorBoundary>` to catch render errors
- Prop drilling through 3+ component levels — should use Context or composition instead

**Runtime Safety** (see `references/runtime-safety-rules.md`):
- Query data used without checking `isLoading` — causes flash of undefined or runtime error
- No empty state UI when `data` is an empty array — user sees blank screen
- No error UI when query or mutation fails — errors are invisible to the user
- Every page/view that fetches data must handle all three states: loading, empty, and error
- `dangerouslySetInnerHTML` used without sanitizing the input first (XSS)
- User input interpolated into URLs without validation (open redirect)
- Secrets, tokens, or API keys hardcoded in source files
- Sensitive data logged to console in production code paths
- **Deeper security pass** — these four are the quick everyday checks. For a focused security review covering token storage, client-bundle secrets (`VITE_*`/`NEXT_PUBLIC_*`), CORS vs CSP, dependency/supply-chain risk, client-only authorization, `postMessage`/`window.opener`, prototype pollution, source maps, and clickjacking, run the dedicated on-demand skill `forge:super-security-review`

**Code Hygiene** (see `references/code-hygiene-rules.md`):
- `console.log`, `console.warn`, `console.error`, `debugger` statements left in production code
- Commented-out code blocks (not explanatory comments — actual dead code that should be deleted)
- Unused exports — function or type exported but never imported anywhere in the project
- `// @ts-ignore` or `// @ts-expect-error` without an explanation comment
- Non-null assertions (`!`) — usually hides a missing null check, prefer proper narrowing
- Type assertions (`as SomeType`) bypassing the type system instead of proper narrowing or generics
- Magic numbers or strings — unexplained literals that should be named constants
- Inconsistent async style — mixing `async/await` with `.then()` chains in the same file
- Hardcoded user-facing strings that should use `t()` for i18n
- Translation keys used in code but missing from `en.json` or `ar.json`
- Orphaned translation keys in locale files that are no longer referenced in any component

**General:**
- Debounce search inputs (300ms default with `useDebounce` hook)
- Use `useDate`/`useTime` hooks — never custom date/time formatters
- No inline SVGs — extract to `src/assets/icons/` with barrel export
- No `Co-Authored-By` in commit messages
- Use lazy-loaded pages (`React.lazy`) for routes
- Route constants must use `as const`
- Produce complete code — no TODOs or placeholders

**PR Completeness**:
- New component/DTO/handler/icon created but NOT exported from its barrel `index.ts` — MUST read the barrel file and verify the export exists
- New page created but no route defined — MUST read `src/routes/index.ts` and verify
- New page in route but not lazy-loaded — MUST verify `React.lazy(() => import(...))` is used
- New user-facing UI but translation keys missing from `en.json` or `ar.json` — MUST read both locale files and verify each `t('...')` key exists
- New handler method with no corresponding hook — MUST search `src/lib/hooks/` for a hook that references the handler method
- New hook created but no component imports it — search reviewed files for the hook import
- Mutation hook missing `onSuccess` (no query invalidation) or `onError` (silent error) — MUST read the hook and verify both callbacks exist

**Cross-file Consistency**:
- Handler returns `Promise<ResultDto<SomeDto>>` but `SomeDto` doesn't exist or isn't exported — MUST read the DTO file and barrel
- Zod schema field names don't match the corresponding DTO field names — MUST read both files and compare field by field
- Route defines param `:communityId` but page destructures `{ id }` from `useParams()` — MUST read route config and page file
- Mutation invalidates a queryKey that doesn't match any handler's queryKey — MUST read the handler and verify the key string matches exactly
- `pathBuilder` params object keys don't match the `:param` placeholders in the endpoint string — MUST read `ApiEndpoints` and verify

**Git Hygiene**:
- Branch name missing ticket number — run `git branch --show-current` and verify format `<type>/<TICKET>-<description>`
- Commit messages missing ticket number — run `git log main..HEAD --oneline` and verify each starts with `DM-XXX:`
- Merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in any file — search all reviewed files
- Accidental files in diff: `.env`, `.DS_Store`, `package-lock.json` without `package.json` changes
- `fixup!` or `squash!` commits left unrebased

**React Query Correctness** (see `references/correctness-rules.md`):
- Query depends on a param (from `useParams`, props, or state) but has no `enabled: !!param` guard — will fire with undefined
- Mutation `onSuccess` invalidates wrong queryKey (e.g., invalidates detail but not list)
- Using `.refetch()` after mutation instead of `queryClient.invalidateQueries()`
- Multiple sibling components calling the same query with conflicting params

**Zod / Form Correctness** (see `references/correctness-rules.md`):
- Zod schema field types don't match DTO types (e.g., `z.string()` where DTO has `number`)
- Form `<FormInput name="x" />` where `x` doesn't exist in the Zod schema — value silently dropped
- Required Zod field (no `.optional()`) but form input missing `required` prop
- `defaultValues` missing a required schema field — form starts in invalid state
- Zod schema has field names that don't match the API DTO — form submits data API rejects

**Routing Correctness** (see `references/correctness-rules.md`):
- Route inside `DashboardLayout` without `AuthGuard` wrapper
- Route defined but no `<Link>`, `<NavLink>`, or `navigate()` points to it (orphaned)
- Hardcoded path strings (`navigate('/orders')`) instead of route constants
- Route param name (`:communityId`) doesn't match `useParams()` destructure (`{ id }`)

**UX Completeness** (see `references/correctness-rules.md`):
- Delete action calls mutation directly without confirmation dialog
- Form submit button has no loading/disabled state tied to `mutation.isPending`
- Mutation `onSuccess` has no toast or navigation — user gets no feedback
- List renders all items without pagination or virtual scrolling
- Search input `onChange` triggers API directly without `useDebounce`

**API Contract** (see `references/correctness-rules.md`):
- `pathBuilder(endpoint, { key })` but endpoint has no `:key` placeholder — MUST read `ApiEndpoints` and verify
- Wrong HTTP method (e.g., `HttpClient.get` for a create operation)
- GET request passing a body payload instead of `{ params }`
- Handler function called with data missing required DTO fields

**Separation of Concerns** (see `references/architecture-rules.md`):
- Business logic (filter, sort, compute, format) inline inside JSX `return (...)` — extract to `useMemo`/`const` above
- Non-trivial API response transformation in component — move to query `select` option or handler
- Manual validation that duplicates what Zod schema already validates
- Single `useEffect` handling multiple unrelated concerns — split into separate effects

**Abstraction Quality** (see `references/architecture-rules.md`):
- Component with 5+ boolean props — should be compound pattern or separate components
- Function with 4+ positional parameters — should use an options object
- Wrapper component that passes all props through to a single child — unnecessary layer
- God component handling list/detail/create/edit modes via flags — split into separate components

**Data Flow Architecture** (see `references/architecture-rules.md`):
- Child component calls `useQueryClient()` and invalidates queries directly — invalidation belongs in mutation hook
- Component in `views/orders/` imports a handler from `handlers/community.ts` directly — use the hook instead
- Circular dependency: file A imports from file B which imports from file A
- Context provider wraps more of the tree than it needs to — scope it closer to consumers

**Error Resilience** (see `references/architecture-rules.md`):
- `JSON.parse()` without `try/catch` — crashes on malformed input
- `localStorage.getItem()` result used without null check
- Async function in `useEffect` without `.catch()` — unhandled promise rejection
- `mutateAsync()` called without `try/catch` — throws on error even if hook has `onError`
- Optional chaining 3+ levels deep (`data?.result?.items?.[0]?.title`) — DTO types are probably too loose

**Bundle & Performance** (see `references/architecture-rules.md`):
- Heavy library (`recharts`, `lexical`, etc.) imported at top level but only used conditionally — lazy-load it
- `import * as Icons from 'lucide-react'` — imports entire icon library, import individual icons instead
- Large array/object (10+ items) defined inside component body — move to module level
- `<img>` without `width`/`height` (layout shift) or without `loading="lazy"` (below fold)

**Testing Readiness** (see `references/architecture-rules.md`):
- Direct `window.location`, `document.getElementById`, `document.title` usage — use React hooks/refs instead
- Side effects at module scope (code that runs on import, not inside a function)
- Complex logic embedded deeply in JSX callbacks — extract to a testable hook or utility

**Backwards Compatibility** (see `references/architecture-rules.md`) — check when modifying existing files:
- Exported type removed or renamed — MUST search `src/` for imports of the old name
- Prop removed from shared component — MUST search `src/` for usages of the removed prop
- Handler queryKey string changed — MUST search `src/` for any code invalidating or referencing the old key
- Context value property removed or renamed — MUST search for all consumers
- Route path changed without redirect from old path — bookmarks will break

### Step 3 — Run All Audit Skills

After the standards check, run the four audit skills on the same file scope to catch specialized issues:

1. **Accessibility audit** (`forge:audit-a11y`):
   - Icon buttons without `aria-label`
   - Clickable divs without `role="button"`, `tabIndex`, and keyboard handler
   - Missing focus rings (`focus-visible:ring-2 focus-visible:ring-tokens-primary focus-visible:ring-offset-2`)
   - Missing disabled states (`disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50`)
   - Images without `alt` attribute
   - Form inputs without labels
   - Color-only indicators without text/icon alternative
   - When wrapping Radix primitives, ARIA/focus/keyboard must be delegated to Radix

2. **Dark mode audit** (`forge:audit-dark-mode`):
   - Hardcoded Tailwind colors (`bg-white`, `text-slate-*`, `border-gray-*`)
   - Tailwind default scales used instead of project tokens (`slate-*`, `zinc-*`, `stone-*`, `neutral-*`)
   - Inline hex/rgb/rgba/hsl color values in className or style
   - CSS custom properties defined in `:root` but missing from `.dark`

3. **RTL audit** (`forge:audit-rtl`):
   - Directional margins/padding (`ml-*`, `mr-*`, `pl-*`, `pr-*`) without RTL counterpart or logical properties (`ms-*`, `me-*`, `ps-*`, `pe-*`)
   - Directional border-radius without RTL mirroring
   - `left-*`/`right-*` positioning without RTL counterpart
   - `text-left`/`text-right` without RTL counterpart
   - Directional borders without RTL counterpart
   - Directional icons (arrows, chevrons) not flipping with `rtl:rotate-180`
   - Flex layouts where visual order matters without `rtl:flex-row-reverse`

4. **Import audit** (`forge:audit-imports`):
   - Barrel violations (individual file imports instead of barrel)
   - Path alias violations (relative imports instead of aliases)
   - Import group order violations
   - `import type` violations
   - Unused or duplicate imports

### Step 4 — Output Structured Report

Combine findings from both the standards review (Step 2) and all audits (Step 3) into one unified report.

**CRITICAL RULES FOR THE REPORT:**
1. Every finding MUST include the exact file path and line number: `src/path/to/File.tsx:42`
2. Every finding MUST describe what is wrong AND what the correct fix is
3. Do NOT guess line numbers — you MUST have read the file and identified the exact line
4. Do NOT report issues you haven't verified — if you can't confirm it, don't include it
5. Group findings by file for readability, then by severity within each file

```markdown
## Code Review Report

### Errors (must fix)

**`src/pages/OrdersPage.tsx`**
- `:12` — Importing Button from `@components/ui/button` instead of barrel → change to `import { Button } from '@components/ui'`
- `:30` — `dangerouslySetInnerHTML` without sanitization → wrap content in `DOMPurify.sanitize()` or use safe renderer
- `:55` — `useEffect` with `setInterval` missing cleanup return → add `return () => clearInterval(id)`
- `:68` — `mutateAsync(data)` without try/catch → wrap in try/catch or switch to `mutate()`

**`src/views/orders/OrderCard.tsx`**
- `:5` — `import { OrderDto } from '@app-types'` → change to `import type { OrderDto } from '@app-types'`
- `:10` — Duplicating query data into `useState` → remove useState, use query result directly
- `:18` — Using `data.items` without checking `isLoading` → add `if (isLoading) return <Loader />`
- `:45` — Using `{isVisible && <Component />}` → change to `<Conditional.If condition={isVisible}>`

**`src/api/handlers/orders.ts`**
- `:15` — Request function inlined in handler object → define function above handler and reference by name
- `:22` — `pathBuilder(ApiEndpoints.ORDERS.BY_ID, { orderId })` but endpoint has `:id` not `:orderId` → change to `{ id }`

**`src/types/api/OrderDto.ts`**
- `:8` — Using `interface OrderForReadDto` → change to `type OrderForReadDto = { ... }`

**`src/lib/hooks/queries/use-orders-query.ts`**
- File name uses kebab-case → rename to `useOrdersQuery.ts`

**`src/lib/hooks/mutations/useCreateOrderMutation.ts`**
- `:12` — `onSuccess` invalidates `'orders/detail'` but should invalidate `'orders/list'` → change queryKey
- `:18` — No `onError` callback → add `onError: (error) => toast({ variant: 'destructive', title: error.message })`

**`src/components/shared/order-badge/OrderBadge.tsx`**
- Created but not exported from `src/components/shared/index.ts` → add `export * from './order-badge'`

### Warnings (should fix)

**`src/pages/OrdersPage.tsx`**
- `:25` — Derived state via `useState` + `useEffect` → simplify to `useMemo`
- `:40` — `console.log('debug', data)` left in production code → remove
- `:62` — No empty state when `data.items.length === 0` → add `<Conditional.If condition={data.items.length > 0} fallback={<EmptyState />}>`
- `:88` — Using `bg-white` → change to `bg-background`
- `:92` — `navigate('/orders/create')` with hardcoded path → use `ROUTES.ORDERS.CREATE`

**`src/views/orders/OrderCard.tsx`**
- `:8` — Hardcoded string "Delete order?" → use `t('orders.deleteConfirm')`
- `:22` — Using `p-[24px]` → change to `p-6`
- `:34` — `ml-4` without RTL counterpart → change to `ms-4`
- `:55` — Icon button `<Button><Trash /></Button>` missing `aria-label` → add `aria-label={t('common.delete')}`

**`src/views/orders/OrderList.tsx`**
- `:15` — Using array index as `key` on a filterable list → use `order.id`
- `:35` — Delete button calls mutation directly without confirmation dialog → add confirm dialog

**`src/views/orders/OrderForm.tsx`**
- `:48` — Submit button has no `loading` prop → add `loading={createMutation.isPending}`
- `:12` — `<FormInput name="nickname" />` but `nickname` not in Zod schema → field value will be silently dropped

**`src/locales/ar.json`**
- Key `orders.createSuccess` exists but value is "Order created" (same as English) → translate to Arabic

### Suggestions

**`src/pages/OrdersPage.tsx`**
- `:45,67,89` — Repeated card JSX pattern (3 occurrences) → extract into `OrderSummaryCard` component

**`src/views/orders/OrderDetail.tsx`**
- `:12,28,44` — `theme` prop passed through 3 component levels → use Context or composition

**`src/components/shared/OrderBadge.tsx`**
- 5 visual variants using `cn()` conditionals → consider CVA for cleaner variant management

**`src/views/orders/OrderCard.tsx`**
- Complex filter + sort logic at `:30-42` inside JSX return → extract to `useMemo` above return for readability and testability

### Git Hygiene
- Branch: `fix/consumer-profile` — missing ticket number → should be `fix/DM-XXX-consumer-profile`
- Commit `abc1234: fixed stuff` — missing ticket number, not imperative → `DM-XXX: Fix consumer profile redirect`
- `package-lock.json` changed but `package.json` unchanged → revert accidental lock file change

### Summary
14 errors, 12 warnings, 4 suggestions, 3 git issues across 8 files
```

**SEVERITY CLASSIFICATION:**

| Severity | Criteria | Examples |
|----------|----------|---------|
| **Error** | Will cause bugs, crashes, security issues, memory leaks, or break other code | XSS, missing barrel exports, wrong HTTP method, `mutateAsync` without try/catch, uncleaned effects, accessing data before loaded, merge conflicts, circular deps, broken type/prop/queryKey references |
| **Warning** | Violates convention, degrades UX, or creates maintenance burden | Hardcoded colors, missing RTL/a11y, console.log, index-as-key, missing loading/empty/error states, hardcoded i18n strings, no confirmation dialog, no submit loading state, unused exports, `@ts-ignore` |
| **Suggestion** | Improvement opportunity that doesn't break anything today | DRY extraction, CVA upgrade, prop drilling, large constants inside components, module-scope extraction, testing readiness |

**LINE NUMBER ACCURACY:**
- You MUST read every file before including it in the report
- Line numbers must correspond to the actual file content you read
- If a file has changed since you read it, re-read before reporting
- Never output a line number you haven't verified by reading the file
