# Search & Pagination Patterns

## Search with Debounce

```typescript
import { useState } from 'react';

import { Input } from '@components/ui';

import { useDebounce } from '@hooks/shared';

// In component:
const [searchQuery, setSearchQuery] = useState('');
const debouncedSearch = useDebounce(searchQuery, 300);

// Pass debounced value to query
const entitiesQuery = useEntityListQuery({ search: debouncedSearch });

// Search input
<Input
  placeholder={t('search')}
  value={searchQuery}
  onChange={(e) => setSearchQuery(e.target.value)}
  className="max-w-sm"
/>
```

**Rules:**
- Default debounce: **300ms**
- Store immediate value in local state for responsive UI
- Use debounced value for API calls
- Never call API directly on `onChange`

## Pagination

```typescript
import { useState } from 'react';

import { Button } from '@components/ui';

// State
const [page, setPage] = useState(1);
const [pageSize] = useState(20);

// Pass to query
const entitiesQuery = useEntityListQuery({ page, pageSize, search: debouncedSearch });

// Pagination controls
<div className="flex items-center justify-between">
  <span className="text-sm text-muted-foreground">
    {t('showing_of', { count: entitiesQuery.data?.items.length, total: entitiesQuery.data?.totalCount })}
  </span>
  <div className="flex gap-2">
    <Button
      variant="outline"
      size="sm"
      onClick={() => setPage(p => p - 1)}
      disabled={page === 1}
    >
      {t('previous')}
    </Button>
    <Button
      variant="outline"
      size="sm"
      onClick={() => setPage(p => p + 1)}
      disabled={page >= (data?.lastPage ?? 1)}
    >
      {t('next')}
    </Button>
  </div>
</div>
```

## Sorting

```typescript
import { type SortingState } from '@tanstack/react-table';

const [sorting, setSorting] = useState<SortingState>([]);

// Pass to table
<DataTable
  columns={columns}
  data={data?.items ?? []}
  sorting={sorting}
  onSortingChange={setSorting}
/>
```

## Filtering

```typescript
// Column filters
const [columnFilters, setColumnFilters] = useState<ColumnFiltersState>([]);

// Status filter example
<Select
  value={statusFilter}
  onValueChange={(value) => {
    setColumnFilters(prev => [
      ...prev.filter(f => f.id !== 'status'),
      ...(value !== 'all' ? [{ id: 'status', value }] : []),
    ]);
  }}
>
  <SelectTrigger className="w-40">
    <SelectValue placeholder={t('all_statuses')} />
  </SelectTrigger>
  <SelectContent>
    <SelectItem value="all">{t('all')}</SelectItem>
    <SelectItem value="active">{t('active')}</SelectItem>
    <SelectItem value="inactive">{t('inactive')}</SelectItem>
  </SelectContent>
</Select>
```

## Combined: Search + Pagination + Sort

Reset page to 1 when search or filters change:

```typescript
useEffect(() => {
  setPage(1);
}, [debouncedSearch, statusFilter]);
```
