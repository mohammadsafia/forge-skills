---
name: forge:create-table
description: "Create data tables using TanStack React Table 8 with search, pagination, and sorting. Use when the user wants to build a data table, add a list view with table, create a sortable/filterable table, or says 'create table', 'add data table', 'build list table', 'table with pagination', 'new table view'. Triggers whenever tabular data display needs to be built."
---

# Create Table

Generate data tables using TanStack React Table 8 with the project's table component wrappers.

## Step 1 — Gather Information

Ask the user if not provided:
- **Entity name** (e.g., "Order", "User", "Product")
- **Columns**: field name, display label, type (text, date, status, actions, image)
- **Features needed**: search, pagination, sorting, filtering, row selection, row actions
- **Data source**: which query hook provides the data

## Step 2 — Scan Existing Patterns

Before writing code, read:
1. The project's table components: `src/components/tables/data-table/DataTable.tsx`, `DataTableContent.tsx`, `DataTablePagination.tsx`, `DataTableToolbar.tsx`
2. Table filter components in `src/components/tables/data-table-filters/`
3. An existing table page in `src/pages/` for wiring patterns
4. The query hook that fetches list data

See `references/column-types.md` for column definition examples.
See `references/search-pagination.md` for search and pagination patterns.
See `_shared/code-standards.md` for all project rules.

## Step 3 — Generate Code

### 3a. Define Columns

File: `src/views/<feature>/columns.tsx` or inline in the page

```typescript
import { type ColumnDef } from '@tanstack/react-table';

import type { EntityListDto } from '@app-types';

export const columns: ColumnDef<EntityListDto>[] = [
  {
    accessorKey: 'name',
    header: 'Name',
  },
  // ... more columns — see references/column-types.md
];
```

> Date columns render the raw value in a `<span>`. Use `dateFilterFn` or `dateRangeFilterFn` for date filtering. For translated headers, use `t()` directly in the `header` field.

### 3b. Create Table Page/View

Wire the query hook, columns, and table component together:
- Use the project's table wrapper components from `src/components/tables/`
- Add search with debounce (300ms)
- Add pagination controls
- Use `Conditional.If` for loading/empty states

### 3c. Add Search with Debounce

```typescript
const [searchQuery, setSearchQuery] = useState('');
const debouncedSearch = useDebounce(searchQuery, 300);
```

## Rules

See `_shared/code-standards.md` for all project rules. Table-specific rules:

- Use existing table components from `src/components/tables/` — don't rebuild
- Debounce search inputs (300ms) before API calls
- Define columns as a plain `const` array for simplicity
- Date columns render the raw value — no hook-based formatters in cell renderers
- Add `data-slot` attributes to table wrapper elements
- Add `aria-label` to search inputs for accessibility

## Reference Files

- `references/table-pattern.md` — Full table page template
- `references/column-types.md` — Column type templates (text, date, status, actions)
- `references/search-pagination.md` — Search and pagination patterns
