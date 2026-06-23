> Rules: see `_shared/code-standards.md`. This file contains code examples only.

# Reusability Rules — Code Examples

## Sub-Component Signature (MANDATORY)

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
- [ ] Uses semantic HTML element when appropriate

## CVA Example

```typescript
import { cva, type VariantProps } from 'class-variance-authority';

const badgeVariants = cva(
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

## Context Inside Compound Components

```typescript
// CORRECT — Context for shared state across 3+ sub-components
type DialogContextValue = { isLoading: boolean; dialogMode: string; onClose: () => void };
const DialogContext = createContext<DialogContextValue>({} as DialogContextValue);

// WRONG — Context for simple 1-level prop passing
// Just pass the prop directly instead
```

## forwardRef with displayName

```typescript
const Input = forwardRef<HTMLInputElement, InputProps>(({ className, ...props }, ref) => (
  <input ref={ref} className={cn('...', className)} {...props} />
));
Input.displayName = 'Input';
```

## Export & Barrel Pattern

```typescript
// src/components/shared/my-component/MyComponent.tsx
export default MyComponent;

// src/components/shared/my-component/index.ts
export { default as MyComponent } from './MyComponent';

// src/components/shared/index.ts
export * from './my-component';
```
