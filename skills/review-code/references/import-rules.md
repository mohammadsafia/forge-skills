> Rules: see `_shared/code-standards.md`. This file contains code examples only.

# Import Rules — Code Examples

## Barrel Import Rules

**UI components — barrel only:**
```typescript
// CORRECT
import { Button, Input, Dialog, Card, Badge } from '@components/ui';

// WRONG
import { Button } from '@components/ui/button';
import { Input } from '@components/ui/input';
```

**Shared components — barrel only:**
```typescript
// CORRECT
import { Conditional, PrimeCard, PrimeDialog } from '@components/shared';

// WRONG
import { Conditional } from '@components/shared/conditional/Conditional';
```

**Custom icons — barrel only:**
```typescript
// CORRECT
import { AppLogo, CheckCircleIcon } from '@assets/icons';

// WRONG
import HeroCheckmark from '@assets/icons/HeroCheckmark';
```

## Import Group Order

Strict order with ONE empty line between groups:

```typescript
// 1. React & core libraries
import { useState, useEffect, useMemo, useCallback } from 'react';
import { useNavigate, useParams, useSearchParams } from 'react-router-dom';

// 2. Third-party libraries
import { z } from 'zod';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { motion } from 'framer-motion';

// 3. UI components (from barrel ONLY)
import { Button, Input, Dialog, Card, Badge, DropdownMenu } from '@components/ui';

// 4. Shared components (from barrel ONLY)
import { Conditional, PrimeDialog, ActionPanel } from '@components/shared';

// 5. View components
import { OrderCard } from '@views/orders';

// 6. Contexts, then hooks
import { useAuth, useTheme } from '@contexts';
import { useToast, useAppTranslation, useDebounce } from '@hooks/shared';
import { useOrdersQuery } from '@hooks/queries';
import { useCreateOrderMutation } from '@hooks/mutations';

// 7. Utils, constants, config
import { cn, pathBuilder, formatCurrency } from '@utils';
import { ROLES, ORDER_STATUS } from '@constants';
import { AppConfig } from '@app-config';

// 8. Icons (Lucide standard, then custom from barrel)
import { Plus, Trash, Calendar, ChevronRight } from 'lucide-react';
import { AppLogo, CheckCircleIcon } from '@assets/icons';

// 9. Types (always use `import type`)
import type { OrderForReadDto, OrderListDto } from '@app-types';
```
