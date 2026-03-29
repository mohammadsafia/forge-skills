# Reusability Rules Reference

## Before Creating Any Component

Scan for existing implementations before creating anything new:

1. `src/components/ui/` — Does a shadcn/ui primitive cover this?
2. `src/components/shared/` — Does a composite component exist?
3. `src/components/forms/` — Is there a form wrapper for this input type?
4. `src/components/tables/` — Is there a table variant?
5. `src/views/` — Has another feature built something similar?

If an existing component covers 80%+ of the need, **extend or compose it** — don't create a new one.

## When to Use Compound Pattern

```
Does the component have 2+ semantic sub-parts (header, content, footer)?
  YES → Use compound component pattern
  NO  → Plain FC (e.g., StatusBadge, Loader)

Does the component have 3+ visual variants?
  YES → Use CVA (class-variance-authority)
  NO  → Use simple cn() conditionals

Does state need to be shared across 3+ sub-components?
  YES → Add React.createContext inside the compound
  NO  → Simple composition, no Context needed
```

Compound pattern is MANDATORY for `src/components/shared/`. Skip only for:
- One-off view-specific components
- Simple leaf components (badge, status dot, loader)
- `src/components/ui/` (follows shadcn/ui conventions)

## Sub-Component Signature Rules (MANDATORY)

Every sub-component MUST have all of these:

```typescript
// CORRECT — full signature
const Header: FC<HeaderProps> = ({ className, children, ...props }) => (
  <header data-slot="card-header" className={cn('p-4', className)} {...props}>
    {children}
  </header>
);

// WRONG — missing className, no cn(), no spread, no data-slot
const Header: FC<HeaderProps> = ({ children }) => (
  <div className="p-4">{children}</div>
);
```

Checklist for every sub-component:
- [ ] Accepts `className?` prop
- [ ] Uses `cn('defaults', className)` for class merging
- [ ] Spreads `...props` for native HTML attribute passthrough
- [ ] Has `data-slot="component-name-slot-name"` attribute
- [ ] Uses semantic HTML element (`header`, `section`, `footer`, `nav`) when appropriate

## CVA Rules

Use CVA when a component has **3+ visual variants**:

```typescript
import { cva, type VariantProps } from 'class-variance-authority';

const badgeVariants = cva(
  // Base styles (shared by all variants)
  'inline-flex items-center rounded-full font-medium',
  {
    variants: {
      variant: {
        success: 'bg-success/10 text-success-700 border-success/20',
        warning: 'bg-warning/10 text-warning-700 border-warning/20',
        error: 'bg-error/10 text-error-700 border-error/20',
        neutral: 'bg-tokens-neutral text-tokens-secondary-content border-tokens-outline',
      },
      size: {
        sm: 'px-2 py-0.5 text-xs',
        md: 'px-2.5 py-1 text-sm',
        lg: 'px-3 py-1.5 text-base',
      },
    },
    defaultVariants: {
      variant: 'neutral',
      size: 'md',
    },
  },
);
```

CVA requirements:
- Always set `defaultVariants`
- Use semantic token colors — never hardcoded hex
- Include disabled state in base: `disabled:pointer-events-none disabled:opacity-50`
- Include focus styles in base: `focus-visible:ring-2 focus-visible:ring-tokens-primary focus-visible:ring-offset-2`
- For 1-2 variants, use simple `cn()` conditionals instead of CVA

## Context Inside Compound Components

Use `React.createContext` ONLY when 3+ sub-components share state:

```typescript
// CORRECT — Context for shared state across 3+ sub-components
type DialogContextValue = { isLoading: boolean; dialogMode: string; onClose: () => void };
const DialogContext = createContext<DialogContextValue>({} as DialogContextValue);

// WRONG — Context for simple 1-level prop passing
// Just pass the prop directly instead
```

## forwardRef Rules

Use `forwardRef` ONLY when the consumer needs direct DOM access:

| Use forwardRef | Skip forwardRef |
|----------------|-----------------|
| Inputs | Cards |
| Buttons | Panels |
| Trigger elements | Sections |
| Elements needing focus management | Layout wrappers |

When using forwardRef, always set `displayName`:

```typescript
const Input = forwardRef<HTMLInputElement, InputProps>(({ className, ...props }, ref) => (
  <input ref={ref} className={cn('...', className)} {...props} />
));
Input.displayName = 'Input';
```

## Export & Barrel Pattern

Default export from the component file, barrel re-export from `index.ts`:

```typescript
// src/components/shared/my-component/MyComponent.tsx
export default MyComponent;

// src/components/shared/my-component/index.ts
export { default as MyComponent } from './MyComponent';

// src/components/shared/index.ts
export * from './my-component';
```

## Component Size

- Single responsibility — one component does one thing
- If JSX exceeds ~150 lines, break into sub-components
- Extract repeated JSX blocks (3+ usages) into their own component
- Prefer composition (children/slots) over configuration (many boolean props)
