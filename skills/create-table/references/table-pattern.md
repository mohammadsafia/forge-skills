# Table Page Template

## Full Table Page

```typescript
// src/pages/entities/EntitiesPage.tsx

import { useState } from 'react';

import { Input } from '@components/ui';

import { Conditional } from '@components/shared';
import { DataTable } from '@components/tables';

import { useDebounce } from '@hooks/shared';
import { useEntityListQuery } from '@hooks/queries';

import { columns } from './columns';

function EntitiesPage() {
  // 1. State
  const [searchQuery, setSearchQuery] = useState('');
  const debouncedSearch = useDebounce(searchQuery, 300);

  // 3. Query
  const entitiesQuery = useEntityListQuery({ search: debouncedSearch });

  return (
    <div data-slot="page" className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold text-foreground">Entities</h1>
      </div>

      {/* Search */}
      <div className="flex items-center gap-3">
        <Input
          aria-label="Search entities"
          placeholder="Search..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="max-w-sm"
        />
      </div>

      {/* Table */}
      <Conditional.If condition={entitiesQuery.isLoading}>
        <div data-slot="table-skeleton" className="space-y-3">
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="h-12 animate-pulse rounded-md bg-muted" />
          ))}
        </div>
      </Conditional.If>

      <Conditional.If condition={!entitiesQuery.isLoading && !!entitiesQuery.data && entitiesQuery.data.items.length > 0}>
        <DataTable columns={columns} data={entitiesQuery.data.items} />
      </Conditional.If>

      <Conditional.If condition={!entitiesQuery.isLoading && (!entitiesQuery.data || entitiesQuery.data.items.length === 0)}>
        <div data-slot="empty-state" className="flex flex-col items-center justify-center py-12 text-center">
          <p className="text-muted-foreground">No entities found.</p>
        </div>
      </Conditional.If>
    </div>
  );
}

export default EntitiesPage;
```

## Column Definitions

```typescript
// src/views/<feature>/columns.tsx

import { type ColumnDef } from '@tanstack/react-table';

import { Badge, Button } from '@components/ui';

import type { EntityListDto } from '@app-types';

export const columns: ColumnDef<EntityListDto>[] = [
  {
    accessorKey: 'name',
    header: 'Name',
    cell: ({ row }) => (
      <span className="font-medium text-foreground">{row.original.name}</span>
    ),
  },
  {
    accessorKey: 'status',
    header: 'Status',
    cell: ({ row }) => (
      <Badge variant={getStatusVariant(row.original.status)}>
        {row.original.status.label}
      </Badge>
    ),
  },
  {
    accessorKey: 'dateCreated',
    header: 'Created',
    cell: ({ row }) => (
      <span className="text-muted-foreground">{row.original.dateCreated}</span>
    ),
  },
  {
    id: 'actions',
    cell: ({ row }) => <ActionsMenu entity={row.original} />,
  },
];
```

> **Date/time columns:** Render the raw ISO string in a `<span>`. Use `dateFilterFn` or `dateRangeFilterFn` from the data table utils for date filtering. See `references/column-types.md` for examples.
