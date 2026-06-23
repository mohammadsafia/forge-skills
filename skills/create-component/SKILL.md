---
name: forge:create-component
description: "Create reusable shared components following the compound component pattern with CVA variants. Use when the user wants to create a new reusable component, build a shared component, make a composite component, or says things like 'create component', 'build a card component', 'new shared component', 'make a reusable widget'. Triggers whenever new reusable UI components need to be built in src/components/shared/."
---

# Create Component

Build reusable shared components using the three-phase workflow: Audit → Build → Verify.

## Step 1 — Audit & Variant Discovery

Before writing code, scan for existing components and build a variant matrix.

### Search for existing components

Check these locations — if an existing component covers 80%+ of the need, extend it:
1. `src/components/ui/` — shadcn/ui primitives
2. `src/components/shared/` — existing composite components
3. `src/components/forms/` — form wrappers
4. `src/components/tables/` — table variants
5. `src/views/` — feature components that could be promoted

Scan existing shared components for patterns:
- `src/components/shared/` — look at `PrimeCard`, `CollapsibleCard`, `PrimeDialog` for compound pattern examples
- `src/components/shared/combobox/Combobox.tsx` for CVA + forwardRef pattern
- `src/components/ui/` for base component primitives

See `_shared/code-standards.md` for all project rules (sections 5, 8, 10).

### Build the variant matrix

Scan every page/view that will use this component and document:

| Dimension | What to collect |
|-----------|----------------|
| Visual states | default, hover, active, focused, disabled, loading, error, empty, selected |
| Size variants | sm, md, lg, xl |
| Semantic variants | primary, secondary, success, danger, warning, info, outline, ghost |
| Layout variations | horizontal, vertical, compact, expanded, with-icon, without-icon |
| Sub-parts/slots | header, content, footer, trigger, actions, icon, title, description |
| Responsive | How does it adapt at sm, md, lg breakpoints? |
| RTL | Directional styling needing `rtl:` mirroring? |
| Dark mode | Colors needing different dark treatment beyond standard tokens? |

Document this matrix BEFORE writing code.

## Step 2 — Choose the Pattern

```
Has 2+ semantic sub-parts (header, content, footer)?
  YES → Compound component pattern (see references/compound-pattern.md)
  NO  → Plain FC

Has 3+ visual variants?
  YES → Use CVA (see references/cva-pattern.md)
  NO  → Use simple cn() conditionals

State shared across 3+ sub-components?
  YES → Add React.createContext inside the compound
  NO  → Simple composition, no Context
```

## Step 3 — Build

### Folder structure

```
src/components/shared/
└── my-component/
    ├── MyComponent.tsx    # Component implementation
    └── index.ts           # export { default as MyComponent } from './MyComponent'
```

Folder name: **kebab-case**. Component file: **PascalCase**.

### Sub-component rules (mandatory for every sub-component)

Every sub-component MUST:
- Accept `className?` prop
- Use `cn('default-styles', className)` for class merging
- Spread `...props` for native HTML passthrough
- Add `data-slot="component-name-slot-name"` for debugging
- Use semantic HTML elements when appropriate

### Import rules

```typescript
import { type ComponentProps, type FC, type ReactNode } from 'react';

import { cn } from '@utils';
```

Use `import type` for type-only imports. Import from barrels only.

## Step 4 — Verify

Run through the quality checklist in `references/quality-checklist.md` before exporting.

### Export through barrel

```typescript
// src/components/shared/my-component/index.ts
export { default as MyComponent } from './MyComponent';

// src/components/shared/index.ts — add:
export * from './my-component';
```

## Reference Files

- `references/compound-pattern.md` — Full compound component template
- `references/cva-pattern.md` — CVA variant examples and rules
- `references/quality-checklist.md` — Phase 3 quality verification
