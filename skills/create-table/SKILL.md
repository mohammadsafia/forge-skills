---
name: forge:create-table
description: "Create data tables using TanStack React Table with search, pagination, and sorting. Use when the user wants to build a data table, add a list view with table, create a sortable/filterable table, or says 'create table', 'add data table', 'build list table', 'table with pagination', 'new table view'. Triggers whenever tabular data display needs to be built."
---

# Create Table

Show rows of data in the simplest table that does the job: a plain table, or a data table with search, paging,
sorting and filters.

## Step 1 — Gather Information

Ask the user if not provided:
- **Entity name** and **columns** (field, label, type: text, date, status, number, actions)
- **How many rows**, at most, and whether the server pages, sorts or filters them
- **Features**: search, sorting, filters, row selection, row actions
- **Data source**: which query hook provides the data
- **Narrowest width** the screen must work at (phone?)

## Step 2 — Plain Table or Data Table

| Use a plain table when | Use a data table when |
|---|---|
| The rows are few and bounded (a visit's guests, an order's lines, a short settings list) | The list grows without a limit, or the server pages it |
| No search, sort or filter is needed | People search, sort, filter or select rows |
| It sits inside a detail page or a card | It is the page's main content |

A data table for five rows adds a toolbar, empty paging and filter state that nobody uses. Say which you chose and why.

## Step 3 — Read the Project's Table Kit

1. If `kit.lock.json` exists at the repository root, the app is built on the RSK kit. Read `../_shared/rsk-kit.md`
   section 6 and the kit's `src/component-docs/guides/data-tables.mdx`:
   - plain: `Table` from `@components/ui` with `Table.Header`, `Table.Body`, `Table.Row`, `Table.Head`, `Table.Cell`,
     `Table.Caption`, `Table.Empty`, `Table.Loader`;
   - data table: `DataTable` from `@components/tables` over TanStack Table v9 (`useTable({ features: kitFeatures, … })`),
     with `useDataTableQuery` for server paging and `useDataTableFilters` for filters.
2. Otherwise read the project's table components, filter components and one existing table page. Check the installed
   TanStack Table major version before writing column or hook code (v8 and v9 differ).

See `references/table-pattern.md`, `references/column-types.md` and `references/search-pagination.md` for generic
templates. See `../_shared/code-standards.md`.

## Step 4 — Build It

- Columns: one place, typed by the row DTO; headers translated with `t()`.
- Dates, times and numbers are formatted for the locale with the project's helpers (RSK: `useDate`, `useTime`,
  `Numeral`/`Money`), inside a `dir="ltr"` span when they sit in Arabic text.
- Every table has a name: a caption, or `aria-label`/`aria-labelledby` pointing at the heading above it.
- States: loading (RSK `Table.Loader` or the data table's `isLoading`), empty with a message that fits the case (no data
  yet vs no match for the search) and an action when there is one, and error.
- Row actions: a visible button or a menu per row, named with the row ("Edit Order 1042"), never a click on the row
  alone.
- Search input debounced (300 ms) before it reaches the server, with a label.

## Step 5 — Narrow Widths

The RSK kit has no stacked table mode. Choose one, and check it at the narrowest width the screen supports:

1. **Scroll sideways** (default for data tables): wrap the table in a container with `overflow-x-auto` and give the
   table a `min-w-*` so columns keep their width. Keep the first column readable and the row actions reachable.
2. **Stacked rows** (for short plain tables on phone-first screens): under a container breakpoint
   (`@container` on the wrapper, `@max-lg:` variants on the parts), show each row as a block and each cell as
   "label: value", with the label in a `<span aria-hidden="true">` inside the cell. When CSS changes `display` on table
   parts, add `role="table"`, `role="row"`, `role="columnheader"` and `role="cell"` so screen readers keep the table.
   Keep the header row in the DOM, visually hidden (`sr-only`) in stacked mode.

Never hide columns at narrow widths without another way to reach their data.

## Checklist

- [ ] Plain table or data table chosen, with the reason
- [ ] Table kit read first (RSK detected by `kit.lock.json`); TanStack major version checked
- [ ] Columns typed; headers translated; dates and numbers formatted for the locale
- [ ] Table named (caption or label); loading, empty (both kinds) and error states
- [ ] Row actions are buttons named with their row
- [ ] Narrow width handled (scroll or stacked) and checked
