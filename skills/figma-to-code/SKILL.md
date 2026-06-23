---
name: forge:figma-to-code
description: "Convert Figma designs into production-ready React components with correct design tokens, spacing, dark mode, RTL, and responsive behavior. Use this skill whenever the user shares a Figma URL, asks to implement a design, mentions 'Figma', 'design to code', 'implement this UI', 'match this design', or wants to turn a mockup into a working component. Also triggers when the user pastes a figma.com link or references a design file."
---

# Figma to Code

Transform Figma designs into production-ready React components that use the project's actual design tokens, existing components, and coding standards.

## Why this workflow matters

Figma designs contain specific colors, spacing, and typography that must map to the project's design token system — not generic Tailwind defaults. Skipping the token scan leads to hardcoded colors that break in dark mode, arbitrary spacing that's inconsistent, and missed opportunities to reuse existing components.

## Workflow

### Step 1 — Read the Design

Extract `fileKey` and `nodeId` from the Figma URL:
- `figma.com/design/:fileKey/:fileName?node-id=:nodeId` → convert `-` to `:` in nodeId
- `figma.com/design/:fileKey/branch/:branchKey/:fileName` → use branchKey as fileKey

Use the Figma MCP tool `get_design_context` with the extracted fileKey and nodeId. This returns code hints, a screenshot, and contextual information.

### Step 2 — Scan the Project

Read the following project files before generating code:
1. Design tokens: `src/index.css` — all CSS custom properties (`:root` and `.dark`)
2. UI primitives: `src/components/ui/` — base components from shadcn/ui
3. Shared components: `src/components/shared/` — existing reusable components
4. An existing page or view for code style reference

See `references/design-tokens.md` for the token mapping.
See `references/spacing-scale.md` for the spacing table.
See `_shared/code-standards.md` for all project rules (sections 5, 8, 10).

### Step 3 — Map Design Tokens

Map every Figma color to a project CSS custom property. Read `references/design-tokens.md` for the full mapping table.

**Token priority (use the first match):**
1. Semantic tokens: `bg-background`, `text-foreground`, `bg-primary`, `text-muted-foreground`, `border-border`, `bg-muted`, `bg-accent`
2. Project color scales: `bg-blue-500`, `text-gray-600`, `bg-error-500`, `bg-success-500`, `bg-warning-500`
3. Token system: `bg-tokens-primary`, `text-tokens-accent-content`, `bg-tokens-neutral`

**If a color doesn't exist in the project:**
1. Add the CSS custom property to `:root` (light) AND `.dark` (dark) in `src/index.css`
2. Register it in the `@theme inline` block for Tailwind
3. Use oklch format to match existing system
4. Follow the naming convention (scale-based or semantic)

### Step 4 — Convert Spacing

Convert all pixel values to Tailwind spacing scale by dividing by 4. Read `references/spacing-scale.md` for the full conversion table.

Common conversions: 4px→1, 8px→2, 12px→3, 16px→4, 20px→5, 24px→6, 32px→8, 40px→10, 48px→12, 64px→16

Never use arbitrary values like `p-[24px]` when `p-6` exists. Only use arbitrary values for truly non-standard measurements.

### Step 5 — Generate the Component

Follow these rules exactly:

**Types:**
- Use `type` not `interface`
- No `any` or unsafe casting

**Imports** (strict order with one empty line between groups):
```typescript
// 1. React & core
import { useState, useCallback } from 'react';

// 2. Third-party
import { motion } from 'framer-motion';

// 3. UI components (barrel only)
import { Button, Card, Badge } from '@components/ui';

// 4. Shared components (barrel only)
import { Conditional, PrimeCard } from '@components/shared';

// 5. Contexts, hooks
import { useAppTranslation } from '@hooks/shared';

// 6. Utils
import { cn } from '@utils';

// 7. Icons
import { Plus, ArrowRight } from 'lucide-react';
import { CustomIcon } from '@assets/icons';

// 8. Types
import type { EntityDto } from '@app-types';
```

**Conditional rendering:**
```typescript
// Use Conditional.If — never && or ternary for show/hide
<Conditional.If condition={isVisible}>
  <Component />
</Conditional.If>

<Conditional.If condition={hasData} fallback={<EmptyState />}>
  <DataDisplay />
</Conditional.If>
```

**Styling:**
- Use `cn()` for conditional classes: `className={cn('base', isActive && 'active')}`
- Theme-aware only: `bg-background` not `bg-white`, `text-foreground` not `text-slate-900`
- Use project color tokens, not Tailwind defaults
- Use spacing scale values, not arbitrary pixels

**Component structure:**
- Follow internal code order: core hooks → context → shared hooks → queries → state → memo → callbacks → effects → JSX
- Event handlers named `handle*`
- Use semantic HTML
- Add `data-slot` attributes for debugging

**Responsive & RTL:**
- Mobile-first: base styles for mobile, breakpoint overrides for larger
- Use Tailwind breakpoints: `sm`, `md`, `lg`, `xl`, `2xl`
- Add `rtl:` prefix for directional styles
- Directional icons flip in RTL

**Accessibility:**
- Interactive elements have `aria-label` or visible label
- Focus rings: `focus-visible:ring-2 focus-visible:ring-tokens-primary focus-visible:ring-offset-2`
- Disabled states: `disabled:pointer-events-none disabled:opacity-50`

### Step 6 — Quality Check

Before delivering, verify against `references/component-checklist.md`:
- Zero hardcoded colors
- All spacing uses scale values
- Dark mode works (all colors use semantic tokens)
- RTL supported where needed
- Responsive (mobile-first)
- Reuses existing project components
- Correct import order and barrel usage
- Proper TypeScript types
- Accessible
