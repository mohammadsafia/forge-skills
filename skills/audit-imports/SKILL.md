---
name: forge:audit-imports
description: "Audit and auto-fix import statements — barrel violations, path aliases, import ordering. Use when the user wants to check imports, fix ordering, find barrel violations, or says 'fix imports', 'check import order', 'audit imports', 'clean up imports'."
---

# Audit Imports

Scan files for import violations and optionally auto-fix them.

## What to Check

### Barrel Violations
Individual file imports instead of barrel:
```typescript
// WRONG → CORRECT
import { Button } from '@components/ui/button'     → '@components/ui'
import { Input } from '@components/ui/input'        → '@components/ui'
import { Card } from '@components/shared/card/Card' → '@components/shared'
import Icon from '@assets/icons/MyIcon'             → import { MyIcon } from '@assets/icons'
```

### Path Alias Violations
Relative imports that should use aliases:
```typescript
// WRONG → CORRECT
import { X } from '../../../components/ui'    → '@components/ui'
import { Y } from '../../lib/hooks/shared'    → '@hooks/shared'
import { Z } from '../../../lib/utils'        → '@utils'
import type { T } from '../../types'          → '@app-types'
```

### Import Order Violations
Required order (one empty line between groups):
1. React & core (`react`, `react-router-dom`)
2. Third-party (`zod`, `react-hook-form`, `@tanstack/*`, `framer-motion`)
3. UI components (`@components/ui`)
4. Shared components (`@components/shared`)
5. View components (`@views/*`)
6. Contexts then hooks (`@contexts`, `@hooks/*`)
7. Utils, constants, config (`@utils`, `@constants`, `@app-config`)
8. Icons (`lucide-react`, `@assets/icons`)
9. Types (`import type` from `@app-types`)

### Type Import Violations
DTOs and types imported without `import type`:
```typescript
// WRONG
import { OrderForReadDto } from '@app-types';

// CORRECT
import type { OrderForReadDto } from '@app-types';
```

### Other Issues
- Unused imports (imported but never referenced)
- Duplicate imports (same module imported twice)
- Missing barrel exports (component exists in folder but not exported from `index.ts`)

## Report Format

```markdown
## Import Audit

### Barrel Violations
- `OrdersPage.tsx:3` — `import { Button } from '@components/ui/button'` → use barrel `@components/ui`

### Path Alias Violations
- `OrderCard.tsx:5` — `from '../../../lib/utils'` → use `@utils`

### Import Order Violations
- `OrdersPage.tsx` — Icons imported before hooks (should be after)

### Type Import Violations
- `OrderCard.tsx:12` — `import { OrderDto }` → should be `import type { OrderDto }`

### Unused Imports
- `OrdersPage.tsx:4` — `useEffect` imported but never used

### Summary
X violations found (Y auto-fixable)
```

## Auto-Fix

When user confirms, auto-fix:
1. Replace individual imports with barrel imports
2. Replace relative paths with aliases
3. Reorder import groups
4. Add `import type` where needed
5. Remove unused imports
