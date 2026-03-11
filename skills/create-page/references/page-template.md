# Page Component Template

## Standard Page

```typescript
// src/pages/<feature>/<FeaturePage>.tsx

import { useState, useMemo, useCallback } from 'react';
import { useNavigate, useParams } from 'react-router-dom';

import { Button, Input } from '@components/ui';

import { Conditional } from '@components/shared';

import { useAppTranslation } from '@hooks/shared';
import { useEntityListQuery } from '@hooks/queries';

function EntitiesPage() {
  // 1. Core hooks
  const navigate = useNavigate();
  const { t } = useAppTranslation('entities');

  // 2. Query hooks
  const { data, isLoading } = useEntityListQuery();

  // 3. Component state
  const [searchQuery, setSearchQuery] = useState('');

  // 4. Computed values
  const filteredItems = useMemo(
    () => data?.items?.filter(item =>
      item.name.toLowerCase().includes(searchQuery.toLowerCase())
    ) ?? [],
    [data, searchQuery],
  );

  // 5. Callbacks
  const handleCreate = useCallback(() => {
    navigate('/entities/create');
  }, [navigate]);

  // 6. JSX
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold text-foreground">{t('title')}</h1>
        <Button onClick={handleCreate}>{t('create')}</Button>
      </div>

      <Conditional.If condition={isLoading}>
        {/* Loading state */}
      </Conditional.If>

      <Conditional.If condition={!isLoading && filteredItems.length > 0}>
        {/* Content */}
      </Conditional.If>

      <Conditional.If condition={!isLoading && filteredItems.length === 0}>
        {/* Empty state */}
      </Conditional.If>
    </div>
  );
}

export default EntitiesPage;
```

## Detail Page (with URL params)

```typescript
// src/pages/<feature>/<FeatureDetailPage>.tsx

import { useParams, useNavigate } from 'react-router-dom';

import { Conditional } from '@components/shared';

import { useEntityDetailsQuery } from '@hooks/queries';

function EntityDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { data: entity, isLoading } = useEntityDetailsQuery(id!, !!id);

  return (
    <div className="space-y-6">
      <Conditional.If condition={isLoading}>
        {/* Loading skeleton */}
      </Conditional.If>

      <Conditional.If condition={!isLoading && !!entity}>
        {/* Detail content */}
      </Conditional.If>
    </div>
  );
}

export default EntityDetailPage;
```
