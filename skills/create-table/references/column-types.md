# Column Type Templates

## Text Column

```typescript
{
  accessorKey: 'name',
  header: t('name'),
  cell: ({ row }) => (
    <span className="font-medium text-foreground">{row.original.name}</span>
  ),
}
```

## Date Column

```typescript
{
  accessorKey: 'dateCreated',
  header: t('created'),
  enableSorting: true,
  sortDescFirst: true,
  cell: ({ row }) => (
    <span className="text-muted-foreground">{row.original.dateCreated}</span>
  ),
}
```

For date filtering, use the filter functions from the data table utils:

```typescript
import { dateFilterFn, dateRangeFilterFn, createFilterMeta } from '@utils';

{
  accessorKey: 'joined',
  header: t('joined'),
  enableSorting: true,
  filterFn: dateRangeFilterFn,
  cell: ({ row }) => (
    <span className="text-muted-foreground">{row.original.joined}</span>
  ),
  meta: {
    label: t('joined'),
    filterMeta: createFilterMeta({
      variant: 'dateRange',
      label: t('joined'),
    }),
  },
}
```

## Status Badge Column

```typescript
{
  accessorKey: 'status',
  header: t('status'),
  cell: ({ row }) => {
    const variant = getStatusVariant(row.original.status.code);
    return (
      <Badge variant={variant}>
        {row.original.status.label_i18n}
      </Badge>
    );
  },
}
```

## Image Column

```typescript
{
  accessorKey: 'image',
  header: t('image'),
  cell: ({ row }) => (
    <Conditional.If condition={!!row.original.primaryImage?.contentUrl}>
      <img
        src={row.original.primaryImage.contentUrl}
        alt={row.original.name}
        className="h-10 w-10 rounded-md object-cover"
      />
    </Conditional.If>
  ),
}
```

## Number/Currency Column

```typescript
{
  accessorKey: 'price',
  header: t('price'),
  cell: ({ row }) => (
    <span className="font-medium tabular-nums">
      {new Intl.NumberFormat('en-AE', { style: 'currency', currency: 'AED' }).format(row.original.price)}
    </span>
  ),
}
```

## Boolean Column

```typescript
{
  accessorKey: 'isActive',
  header: t('active'),
  cell: ({ row }) => (
    <Badge variant={row.original.isActive ? 'success' : 'neutral'}>
      {row.original.isActive ? t('yes') : t('no')}
    </Badge>
  ),
}
```

## Actions Column

```typescript
{
  id: 'actions',
  header: '',
  cell: ({ row }) => (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button variant="ghost" size="icon">
          <MoreHorizontal className="h-4 w-4" />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem onClick={() => handleView(row.original.id)}>
          <Eye className="me-2 h-4 w-4" />
          {t('view')}
        </DropdownMenuItem>
        <DropdownMenuItem onClick={() => handleEdit(row.original.id)}>
          <Pencil className="me-2 h-4 w-4" />
          {t('edit')}
        </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem
          className="text-destructive"
          onClick={() => handleDelete(row.original.id)}
        >
          <Trash className="me-2 h-4 w-4" />
          {t('delete')}
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  ),
}
```

## Selection Column

```typescript
{
  id: 'select',
  header: ({ table }) => (
    <Checkbox
      checked={table.getIsAllPageRowsSelected()}
      onCheckedChange={(value) => table.toggleAllPageRowsSelected(!!value)}
      aria-label="Select all"
    />
  ),
  cell: ({ row }) => (
    <Checkbox
      checked={row.getIsSelected()}
      onCheckedChange={(value) => row.toggleSelected(!!value)}
      aria-label="Select row"
    />
  ),
  enableSorting: false,
  enableHiding: false,
}
```
