# Transformation Catalog

## Import Transformations

### Deep import → Barrel import
```typescript
// BEFORE
import { Button } from '@components/ui/button';
import { Input } from '@components/ui/input';
import { EventCard } from '@components/shared/event-card/EventCard';

// AFTER
import { Button, Input } from '@components/ui';
import { EventCard } from '@components/shared';
```

### Relative import → Path alias
```typescript
// BEFORE
import { formatDate } from '../../../lib/utils';
import type { UserDto } from '../../types';

// AFTER
import { formatDate } from '@utils';
import type { UserDto } from '@app-types';
```

### Value import → Type import
```typescript
// BEFORE
import { OrderForReadDto, UserDto } from '@app-types';

// AFTER
import type { OrderForReadDto, UserDto } from '@app-types';
```

### Disordered imports → Correct order
```typescript
// BEFORE
import { cn } from '@utils';
import { useState } from 'react';
import { Button } from '@components/ui';
import type { UserDto } from '@app-types';
import { useToast } from '@hooks/shared';

// AFTER
import { useState } from 'react';

import { Button } from '@components/ui';

import { useToast } from '@hooks/shared';

import { cn } from '@utils';

import type { UserDto } from '@app-types';
```

## Type Transformations

### interface → type
```typescript
// BEFORE
interface UserProps {
  name: string;
  email: string;
}

// AFTER
type UserProps = {
  name: string;
  email: string;
};
```

### Raw string → Type literal
```typescript
// BEFORE
status: string;

// AFTER
status: 'active' | 'inactive' | 'pending';
```

## Pattern Transformations

### && rendering → Conditional.If
```typescript
// BEFORE
{isVisible && <Component />}
{hasItems ? <List /> : <Empty />}

// AFTER
<Conditional.If condition={isVisible}>
  <Component />
</Conditional.If>

<Conditional.If condition={hasItems} fallback={<Empty />}>
  <List />
</Conditional.If>
```

### Template literal className → cn()
```typescript
// BEFORE
className={`base-class ${isActive ? 'active' : ''}`}

// AFTER
className={cn('base-class', isActive && 'active')}
```

### Custom date formatter → useDate hook
```typescript
// BEFORE
const formatDate = (date: string) => new Date(date).toLocaleDateString();

// AFTER
const { formatDate } = useDate();
```

## Styling Transformations

### Hardcoded color → Theme token
```typescript
// BEFORE
className="bg-white text-slate-900 border-slate-200"

// AFTER
className="bg-background text-foreground border-border"
```

### Arbitrary pixel → Scale value
```typescript
// BEFORE
className="p-[24px] gap-[16px] mt-[32px]"

// AFTER
className="p-6 gap-4 mt-8"
```

## API Layer Transformations

### Inline request → Handler pattern
```typescript
// BEFORE
const usersQuery = useQuery({
  queryKey: ['users', 'list'],
  queryFn: () => axios.get('/api/users'),
});

// AFTER
const usersQuery = useQuery({
  queryKey: [usersHandler.getList.queryKey],
  queryFn: () => usersHandler.getList.request(),
});
```

### Array queryKey → String queryKey
```typescript
// BEFORE (in handler)
queryKey: ['users', 'list'] as const

// AFTER
queryKey: 'users/list'
```
