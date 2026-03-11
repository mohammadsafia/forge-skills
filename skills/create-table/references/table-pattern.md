# Table Page Template

## Full Table Page

```typescript
// src/pages/entities/EntitiesPage.tsx

import { useState } from 'react';

import { Input } from '@components/ui';

import { Conditional } from '@components/shared';

import { useDebounce } from '@hooks/shared';
import { useEntityListQuery } from '@hooks/queries';

import { columns } from './columns';
// Import the project's DataTable component from src/components/tables/

function EntitiesPage() {
  // 1. State
  const [searchQuery, setSearchQuery] = useState('');
  const debouncedSearch = useDebounce(searchQuery, 300);

  // 2. Query
  const { data, isLoading } = useEntityListQuery({ search: debouncedSearch });

  // 3. Handlers
  const handleSearchChange = (value: string) => {
    setSearchQuery(value);
  };

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold text-foreground">Entities</h1>
      </div>

      {/* Search */}
      <div className="flex items-center gap-3">
        <Input
          placeholder="Search..."
          value={searchQuery}
          onChange={(e) => handleSearchChange(e.target.value)}
          className="max-w-sm"
        />
      </div>

      {/* Table */}
      <Conditional.If condition={isLoading}>
        {/* Loading skeleton */}
      </Conditional.If>

      <Conditional.If condition={!isLoading && !!data}>
        {/* DataTable component={columns} data={data.items} */}
      </Conditional.If>

      <Conditional.If condition={!isLoading && (!data || data.items.length === 0)}>
        {/* Empty state */}
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

import { useDate } from '@hooks/shared';

import type { EntityListDto } from '@app-types';

export const useEntityColumns = (): ColumnDef<EntityListDto>[] => {
  const { formatDate } = useDate();

  return [
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
      cell: ({ row }) => formatDate(row.original.dateCreated),
    },
    {
      id: 'actions',
      cell: ({ row }) => <ActionsMenu entity={row.original} />,
    },
  ];
};
```
