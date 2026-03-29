# PR Completeness Rules Reference

These checks verify that the work is finished — all pieces connected, all files wired up, nothing left dangling.

## IMPORTANT: Verification Method

For every check below, you MUST actually read the target file and verify. Do NOT assume a file contains something — open it and check. If a file doesn't exist, that's a finding. If you can't verify, say "could not verify" — never guess.

---

## 1. Barrel Export Completeness

When a new file is created, it must be exported from the nearest barrel `index.ts`.

### How to check:

For each new file in the review scope:

**New component in `src/components/shared/<name>/`:**
1. Read `src/components/shared/<name>/index.ts` — verify it exports the component
2. Read `src/components/shared/index.ts` — verify it re-exports from `./<name>`

**New component in `src/views/<feature>/<name>/`:**
1. Read `src/views/<feature>/<name>/index.ts` — verify it exports the component
2. Read `src/views/<feature>/index.ts` — verify it re-exports from `./<name>`

**New DTO in `src/types/api/`:**
1. Read `src/types/api/index.ts` — verify it has `export * from './<DtoFileName>'`

**New handler in `src/api/handlers/`:**
1. Read `src/api/handlers/index.ts` — verify it has `export * from './<handler-file>'`

**New icon in `src/assets/icons/`:**
1. Read `src/assets/icons/index.ts` — verify it has `export { default as <IconName> } from './<IconName>'`

### What to flag:

```
Error: `src/components/shared/order-badge/OrderBadge.tsx` created but not exported from `src/components/shared/order-badge/index.ts`
Error: `src/types/api/OrderDto.ts` created but missing from `src/types/api/index.ts` barrel
```

---

## 2. Route Wiring

When a new page is created, it must be added to the route config.

### How to check:

1. Find all new `*Page.tsx` files in the review scope
2. Read `src/routes/index.ts` (or the main route config file)
3. For each new page, verify:
   - The page is imported with `React.lazy(() => import(...))`
   - A route path is defined for it
   - The route is wrapped in the correct layout (`MainLayout` or `DashboardLayout`)
   - Protected pages are wrapped in `AuthGuard`

### What to flag:

```
Error: `src/pages/communities/CommunitiesPage.tsx` created but no route defined in `src/routes/index.ts`
Error: `CommunitiesPage` imported directly (not lazy-loaded) — use `React.lazy(() => import(...))`
Warning: `CommunitiesPage` route not wrapped in `AuthGuard` — is this intentionally public?
```

---

## 3. Translation Completeness

When new user-facing UI is created, translation keys must exist in both locale files.

### How to check:

1. In each reviewed `.tsx` file, find all `t('...')` calls — extract the key strings
2. Read `src/locales/en.json` — verify each key exists
3. Read `src/locales/ar.json` — verify each key exists and the value is NOT the same as the English value (which would indicate an untranslated placeholder)

### What to flag:

```
Error: `t('communities.createSuccess')` used in `CommunitiesPage.tsx:45` but key missing from `en.json`
Error: `t('communities.createSuccess')` used in `CommunitiesPage.tsx:45` but key missing from `ar.json`
Warning: `ar.json` has `"createSuccess": "Community created"` — Arabic value is identical to English (likely untranslated)
```

---

## 4. Handler-Hook-Component Chain

When a new API integration is added, all three layers must exist and connect.

### How to check:

1. If a new handler file exists in `src/api/handlers/`:
   - For each `queryKey` in the handler, search `src/lib/hooks/queries/` for a hook that references it
   - For each `mutationKey`, search `src/lib/hooks/mutations/` for a hook that references it
   - If no hook references a handler method, it's dead code

2. If a new hook exists in `src/lib/hooks/queries/` or `mutations/`:
   - Read the hook — find which handler it imports
   - Verify that handler file exists and exports the referenced method
   - Search the review scope for components that import and call this hook

3. If a new endpoint is added to `ApiEndpoints.ts`:
   - Search `src/api/handlers/` for any handler that references this endpoint
   - If no handler uses it, it's a dangling endpoint

### What to flag:

```
Error: `communityHandler.create` defined but no mutation hook references it — dead code or missing hook
Error: `useCreateCommunityMutation` imports `communityHandler.create` but `communityHandler` has no `create` method
Warning: `ApiEndpoints.COMMUNITIES.DELETE` added but no handler references it yet
```

---

## 5. Mutation Side Effects

Every mutation must have proper side effects: query invalidation and user feedback.

### How to check:

For each mutation hook in the review scope:
1. Read the hook file
2. Verify `onSuccess` callback exists and contains:
   - `queryClient.invalidateQueries(...)` — with the correct related query key
   - A toast or navigation (user feedback that the action succeeded)
3. Verify `onError` callback exists and contains:
   - A toast with error feedback (not just `console.log`)

### What to flag:

```
Error: `useCreateCommunityMutation` has no `onSuccess` — user won't see their change reflected
Error: `useDeleteCommunityMutation.onSuccess` invalidates `'communities/detail'` but should invalidate `'communities/list'`
Error: `useUpdateCommunityMutation` has no `onError` — errors are silently swallowed
Warning: `useCreateCommunityMutation.onSuccess` invalidates queries but shows no toast — user has no feedback
```

---

## 6. Git Hygiene

### How to check:

Run these git commands and verify:

**Branch name:**
```bash
git branch --show-current
```
- Must match pattern: `<type>/<TICKET>-<description>` (e.g., `feature/DM-210-add-communities`)
- Type must be one of: `feature`, `fix`, `refactor`, `chore`, `hotfix`
- Description must be kebab-case

**Commit messages:**
```bash
git log main..HEAD --oneline
```
- Each commit must start with ticket number: `DM-XXX: <imperative description>`
- No `Co-Authored-By` lines
- No `fixup!` or `squash!` commits left unrebased

**Accidental files:**
```bash
git diff main..HEAD --name-only
```
- Flag files that shouldn't be in the PR:
  - `package-lock.json` changes with no `package.json` changes (accidental lock churn)
  - `.env`, `.env.local`, credentials files
  - `.DS_Store`, `Thumbs.db`
  - Unrelated files that don't match the ticket scope

**Merge conflict markers:**
Search all changed files for:
```
<<<<<<<
=======
>>>>>>>
```
If found, flag as Error — merge conflict not resolved.

### What to flag:

```
Error: Merge conflict markers found in `src/pages/OrdersPage.tsx:45`
Error: Branch name `fix/consumer-profile-link` missing ticket number — should be `fix/DM-XXX-consumer-profile-link`
Warning: Commit `abc1234: fixed stuff` missing ticket number and not imperative
Warning: `package-lock.json` changed but `package.json` is unchanged — accidental lock file churn?
Warning: `.env.local` is in the diff — should not be committed
```

---

## 7. Cross-File Consistency

### DTO ↔ Handler match

1. Read the handler file — find all `Promise<ResultDto<SomeDto>>` return types
2. Read the DTO file — verify `SomeDto` actually exists and is exported
3. Check that the handler function parameters match the DTO shapes (e.g., `createUser(payload: UserForCreateDto)` — verify `UserForCreateDto` exists)

### Zod Schema ↔ DTO match

1. If the feature has a `schemas.ts` in `views/<feature>/`:
   - Read the Zod schema fields
   - Read the corresponding `ForCreateDto` or `ForUpdateDto`
   - Verify the Zod schema field names and types align with the DTO
   - Flag mismatches: schema has `name: z.string()` but DTO has `title: string`

### Route ↔ Page match

1. Verify route paths follow a consistent pattern with the page file location
2. Verify route params (`:id`) match what `useParams()` destructures in the page

### What to flag:

```
Error: Handler returns `Promise<ResultDto<CommunityForReadDto>>` but `CommunityForReadDto` is not exported from `src/types/api/index.ts`
Error: Zod schema has field `name` but `CommunityForCreateDto` has field `title` — mismatch
Error: Route defines param `:communityId` but page destructures `const { id } = useParams()` — param name mismatch
```
