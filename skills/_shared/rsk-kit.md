# Apps built on the RSK kit

Read this file when the target repository has `kit.lock.json` at its root. That file means the app was created from the
RSK starter (`vp create github:mohammadsafia/rsk-starter`) and its kit files are kept current with `pnpm kit:update`.
In such an app, the facts below replace the generic paths, names and templates in a skill's `references/`. Where this
file and a skill's template disagree, this file wins; where the app itself disagrees with this file (it changed
something on purpose), the app wins.

These facts were checked against the kit at commit `bf12e1d` (rsk PR #41). Before relying on one, open the file named
next to it in the app: the kit moves, and the app may have changed it.

## 1. First look

1. Read `kit.lock.json`: `kit` (the kit commit), `target` (`vite` or `next`), `blocks`, and `files` (every kit-owned file).
   This file describes the `vite` target. For `next`, read the app's README for its `app/` routes and layouts.
2. Read the app's `README.md` ("Where to add things"), `AGENTS.md` or `CLAUDE.md`, and `docs/` if present. Project rules
   win over this file.
3. Kit-owned files (listed in `kit.lock.json` `files`: `src/components/**`, `src/lib/{constants,contexts,hooks,utils}/**`,
   `src/styles/**`, `tests/design-system/**`) are not edited in feature work. A fault in one is a kit defect: report it
   and follow the project's rule for taking the fix. Two expected exceptions: the empty barrels
   `src/lib/hooks/queries/index.ts` and `src/lib/hooks/mutations/index.ts` are kit files that every app adds exports to.
   `pnpm kit:status` lists them as changed by the app; say so in the pull request.
4. App-owned and yours to change: `src/pages`, `src/views`, `src/routes`, `src/layouts`, `src/api`, `src/types`,
   `src/locales`, `src/test-utils`, `src/app-config`, `src/i18n.ts`.
5. The kit's documentation is not copied into the app. Read it in the kit repository (github.com/mohammadsafia/rsk):
   `docs/CODE_STANDARDS.md` and `src/component-docs/` (guides `forms.mdx`, `data-tables.mdx`, `rtl-i18n.mdx`, and one
   `.mdx` per component). In the app, a component's source and its `*.test.tsx` beside it show its real props.

## 2. Where things go

| What | Where (alias) |
|---|---|
| Page | `src/pages/<area>/<Name>Page.tsx`, default export (`@pages`) |
| Route path constants | `FULL_ROUTES_PATH` in `src/routes/routes.ts` |
| Route table | `src/routes/router.tsx` (`createBrowserRouter`, React Router `react-router`, not `react-router-dom`) |
| Sidebar and command palette | `BASE_MENU` in `src/routes/routes.ts` (feeds `APP_MENU`) |
| Menu labels | `src/locales/{en,ar}/nav.json`, key = the entry's `id`; group labels under `groups.<group>` |
| Endpoint paths | `ApiEndpoints` in `src/api/config/ApiEndpoints.ts` |
| HTTP client | `httpClient` (lower case) from `@api/config/HttpClient` |
| Request handlers | `src/api/handlers/<area>.ts`, exported from `src/api/handlers/index.ts` |
| Query and mutation hooks | `src/lib/hooks/queries/`, `src/lib/hooks/mutations/` (`@hooks/queries`, `@hooks/mutations`) |
| Hand-written DTOs | `src/types/`, exported from `src/types/index.ts` (`@app-types`) |
| Generated DTOs | `src/types/api/` (written by `pnpm dto:gen`; do not edit by hand) |
| Feature schemas and reused views | `src/views/<feature>/` |
| Copy | `src/locales/{en,ar}/<namespace>.json` (one file per namespace) |
| Test helpers | `src/test-utils/` (the kit ships `FormHarness.tsx`) |
| Shared hooks | `@hooks/shared` (`useAppTranslation`, `useToast`, `useDate`, `useTime`, `useAuth`, `useDebounce`) |
| Utilities | `@utils` (`cn`, `pathBuilder`, `errorMessage`, `formResolver`) |
| `Conditional` | `@components/utils` (not `@components/shared`) |

## 3. Pages, routes and the menu

- A page under the app shell is a child of the `AppLayout` route inside the `AuthGuard` route in `router.tsx`, loaded
  with `lazy: async () => ({ Component: (await import('@pages/<area>/<Name>Page')).default })`.
- The shell (`AppShell`) already renders the page inside `<main>`. Do not add another `<main>`. Start the page with
  `<PageHeader title={t('title')} />` from `@components/shared`: it renders the page's `h1` (and a back link with `back`).
- The kit does not move focus when the route changes. Check whether the app's `src/layouts/app-layout/AppLayout.tsx` does
  (focus the new page's `h1`, made focusable with `tabIndex={-1}`). If it does not, say so; a keyboard user is left
  where the old page was.
- `AuthGuard` checks only that someone is signed in. The kit has no roles: `CurrentUser` has none, nothing filters
  `APP_MENU` by its `roles` field, and `withAuth` (`@hoc`) always lets everyone through. For a page limited to some
  roles, find where the app keeps roles (its session or a "who am I" query). If it keeps none, ask; do not invent a
  role source. Then limit the route (a guard element that shows not-found or no-access), the menu entry, and every
  action, and state that the server must refuse the request too.
- `Conditional` has `Conditional.If` (`condition`, `children`) and `Conditional.Else`. It has no `fallback` prop, although
  `docs/CODE_STANDARDS.md` 6.2 shows one. The else case is:

```tsx
<Conditional>
  <Conditional.If condition={!!data}>…</Conditional.If>
  <Conditional.Else>…</Conditional.Else>
</Conditional>
```

## 4. API

- `ApiEndpoints` holds paths relative to the base URL. The base URL (`APP_CONFIGURATIONS.VITE_APP_API_URL` in
  `src/app-config/appConfig.ts`) already ends in the API prefix, so a path is `'/visits'`, never `'/api/v1/visits'`.
  Check the base URL before writing the first path.
- `httpClient.get<T>(url, config?)` (also `post`, `put`, `patch`, `delete`) returns the response body. A request carries
  the session token unless `{ withToken: false }`. A 401 on a request that carried the token signs the person out.
- A failed request throws the API's error body with `status` added (`{ ...body, status }`), not an `AxiosError`. Read it
  with `errorMessage(error, fallback)` from `@utils`, or by its fields (a `code`, a `status`).
- `pathBuilder({ path, pathParams, queryParams })` from `@utils` fills `:id` parameters and encodes them.
- The query client (`createQueryClient` in `src/api/config/QueryClient.ts`) sets `retry: false`, `staleTime: 0`.
- Toasts: `toast({ title, description, tone })` from `useToast()` in `@hooks/shared`; `tone` is `neutral`, `success`,
  `warning`, `danger` or `info` (there is no `variant: 'destructive'`). The `<Toaster />` is mounted only inside the
  signed-in shell (`AppLayoutShell`), so a toast raised on the sign-in pages is never seen.

## 5. Forms

- `FormContainer` (`@components/forms`) takes the `useForm` result as `formContext` and an `onSuccess` handler. So the
  component that renders the form calls `useForm` itself: a page or view with a form has `useForm` in it.
- Resolver: `resolver: formResolver<Values>(schema)` from `@utils` (a typed wrapper of `zodResolver`).
- `FormContainer.Actions` renders Cancel and Submit (Submit shows a loading state; `confirmOnCancel` asks before
  dropping changes). Since kit `bf12e1d`, `Button` and `IconButton` are `type="button"` unless given `type="submit"`, so
  Enter in a field submits with the form's own Submit. In an older kit, check `src/components/ui/button/Button.tsx`.
- Fields: `FormInput`, `FormTextarea`, `FormNumber`, `FormSelect` (Radix Select), `FormCombobox` and
  `FormMultiCombobox` (searchable), `FormCheckbox`, `FormCheckboxGroup`, `FormRadioGroup`, `FormDatePicker`,
  `FormDateRange`, `FormTimePicker`, `FormChipInput`, `FormFileUploader`, `FormSection`, `FormWizard`. Option fields take
  `options`, `getOptionLabel`, `getOptionValue`. Every field renders through `FormField`: label, `required` marker,
  inline error, `aria-describedby`.
- `FormDatePicker` value is an ISO date string (`'2026-03-14'`); the box shows the display format (`03/14/2026` in
  English). `FormTimePicker` value is `'10:30 AM'`, or `'10:30'` with `use24hFormat`.
- `FormSection` is a titled `<section>`, not a `<fieldset>`. `FormCheckboxGroup` and `FormRadioGroup` are named groups
  already.
- Repeating groups of fields (1..N) use `useFieldArray` from `react-hook-form` inside the same `FormContainer`. The kit
  has no repeating-group component.

## 6. Tables

- `Table` (`@components/ui`) is a plain compound table: `Table.Header`, `Table.Body`, `Table.Row`, `Table.Head`,
  `Table.Cell`, `Table.Caption`, `Table.Empty`, `Table.Loader`.
- `DataTable` (`@components/tables`) takes a TanStack Table v9 `table` built with `useTable({ features: kitFeatures, … })`
  and is composed of `DataTable.Toolbar`, `DataTable.Content`, `DataTable.Pagination`, `DataTable.BulkActions`. Server
  paging and sorting go through `useDataTableQuery`; filters through `useDataTableFilters`. Read the kit's
  `src/component-docs/guides/data-tables.mdx`.
- Neither has a narrow (stacked) mode. At phone width a wide table scrolls sideways inside its own container.

## 7. Copy and direction

- `useAppTranslation('<namespace>')` returns `t`, `direction`, `isRTL`. A namespace is a file name in `src/locales/en/`;
  `tests/i18n/parity.test.ts` fails when a key is in one language only.
- Arabic plurals: `_zero`, `_one`, `_two`, `_few`, `_many`, `_other`; English `_one`, `_other`.
- Layout is logical (`ms-`, `me-`, `ps-`, `pe-`, `start-`, `end-`, `text-start`, `border-s`, `rounded-s`). Directional
  icons mirror with `rtl:-scale-x-100`. Identifiers, amounts, dates, times and codes are wrapped in `dir="ltr"`.
- The kit's own errors live in `src/locales/{en,ar}/errors.json` (`validation.*`, `boundary.*`, `notFound.*`).

## 8. Styling tokens

Semantic tokens only: surfaces `bg-canvas`, `bg-surface`, `bg-surface-sunken`, `bg-surface-raised`; text `text-fg`,
`text-fg-muted`, `text-fg-subtle`; borders `border-border`, `border-border-strong`, `border-border-subtle`; roles
`accent`, `danger`, `warning`, `success`, `info` (each with `-subtle` and `-fg`). Focus: the `focus-ring` and
`focus-ring-input` utilities; invalid: `state-invalid`. Control heights `h-control-sm|md|lg` (28 / 32 / 40 px). Names
such as `bg-background`, `text-foreground`, `bg-primary` are legacy and fail the kit's `forbidden-patterns` test. The
default theme is dark.

## 9. Guards the kit already runs

`vp test` runs the kit's checks: `tests/design-system/code-standards.test.ts` (no `&&` or ternary JSX, no `interface`,
barrels only, no inline SVG, no multi-line inline handlers, no empty `catch`), `forbidden-patterns.test.ts` (raw colours,
arbitrary pixel values, state fills, legacy names), `icon-button-labels.test.ts`, `contrast.test.ts`, and
`tests/i18n/parity.test.ts`. `code-standards.test.ts` checks only the folders in its `SCOPE` list (by default the sign-in
pages and blocks, not the app's own pages): say whether the code you touched is in it. `pnpm a11y:audit` runs axe over
every page in light and dark, English and Arabic (run `pnpm exec playwright install chromium` once).
