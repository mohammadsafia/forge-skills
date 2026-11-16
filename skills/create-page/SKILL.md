---
name: forge:create-page
description: "Create new pages with routing, lazy loading, and layout guards. Use when the user wants to add a new page, create a route, set up a new view with routing, or says 'create page', 'add new page', 'new route for', 'add page with guard', 'create dashboard page'. Triggers whenever a new route-level component needs to be set up."
---

# Create Page

Generate a new page component with route configuration, lazy loading, a menu entry when needed, and access limits.

## Step 1 — Gather Information

Ask the user if not provided:
- **Page name** (e.g., "Orders", "OrderDetail")
- **Route path** (e.g., `/orders`, `/orders/:id`)
- **Layout**: inside the signed-in app shell, or a page without it
- **Who may open it**: any signed-in person, or only some roles (which ones, and where the app keeps roles)
- **Menu**: does it get a sidebar entry, and in which group
- **Dynamic params**: any URL params (`:id`, `:slug`)

## Step 2 — Read the Project's Layout

1. If `kit.lock.json` exists at the repository root, the app is built on the RSK kit. Read `../_shared/rsk-kit.md`
   sections 1–3 and follow them: they replace the paths and names in this skill's references.
2. Otherwise read an existing page in `src/pages/`, the route configuration (often `src/routes/`), the layouts, and the
   navigation source. Use what they use. Do not add names the project does not have (a prefix list, a guard prop, a
   layout) because a template mentions them.

See `references/page-template.md` and `references/routing-patterns.md` for generic templates (non-RSK projects).
See `../_shared/code-standards.md` for the default project rules (sections 5, 6, 9, 12) and for how a skill step
relates to them.

## Step 3 — Create the Page Component

File: the project's page folder (RSK: `src/pages/<area>/<Name>Page.tsx`, default export).

- Follow the project's internal order (RSK: `docs/CODE_STANDARDS.md` section 10).
- Start with the project's page header. In RSK, `<PageHeader title={t('title')} />` renders the `h1`.
- Do not add a `<main>` when the layout already renders one (the RSK shell does). Two `main` landmarks is a defect.
- Show loading, empty, error and success states. Use the project's conditional wrapper if it has one. In RSK:
  `Conditional` from `@components/utils`; the else case is `<Conditional>` with `Conditional.If` and
  `Conditional.Else` (there is no `fallback` prop).
- Copy goes through the translation hook, in a namespace for the area (see `forge:add-translations`).

## Step 4 — Add the Route

- Load the page lazily the way the router already does (RSK: a child of the `AppLayout` route inside the `AuthGuard`
  route in `src/routes/router.tsx`, with `lazy: async () => ({ Component: (await import('@pages/…')).default })`).
- Add the path to the project's route constants (RSK: `FULL_ROUTES_PATH` in `src/routes/routes.ts`).
- Build links with params through the project's helper if it has one (RSK: `pathBuilder` from `@utils`).

## Step 5 — Limit Access

- Find what the project's guard checks. The RSK `AuthGuard` checks only that someone is signed in; the kit has no roles
  and `withAuth` lets everyone through.
- For a page limited to some roles: use the project's role source. If there is none, stop and ask; never invent one.
  Limit the route, the menu entry and each action on the page, and say that the API must refuse the request too.

## Step 6 — Add Navigation

- RSK: add an entry to `BASE_MENU` in `src/routes/routes.ts` (`id`, `path`, `group`, Lucide `icon`), and its label in
  `src/locales/en/nav.json` and `src/locales/ar/nav.json` under the same `id` (a new group also needs
  `groups.<group>`).
- Other projects: wire the sidebar, navbar or other entry points the project uses.

## Step 7 — Focus After Navigation

Check whether the layout moves focus to the new page's heading after a route change. The RSK kit does not do this by
itself. If the app's layout does not, say so in the output; do not add it silently to a shared layout without asking.

## Checklist

- [ ] Layout read first (RSK detected by `kit.lock.json`, or the project's own files)
- [ ] Page in the project's page folder, default export, loaded lazily by the router
- [ ] One `main` landmark; the page starts with the project's page header (`h1`)
- [ ] Loading, empty, error and success states shown
- [ ] Path constant added; params built with the project's helper
- [ ] Access limited with the project's own role source, or the question asked
- [ ] Menu entry and its label in both locale files (when the page is in the menu)
- [ ] Focus after navigation checked and reported
