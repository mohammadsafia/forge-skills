# CVA (Class Variance Authority) Pattern

Use CVA when a component has **3+ visual variants**. For fewer variants, use `cn()` conditionals.

## Basic CVA Setup

```typescript
import { cva, type VariantProps } from 'class-variance-authority';
import { type ComponentProps, type FC } from 'react';

import { cn } from '@utils';

const badgeVariants = cva(
  // Base styles shared by ALL variants
  'inline-flex items-center rounded-full font-medium transition-colors',
  {
    variants: {
      variant: {
        success: 'bg-success-50 text-success-700 border border-success-200',
        warning: 'bg-warning-50 text-warning-700 border border-warning-200',
        destructive: 'bg-error-50 text-error-700 border border-error-200',
        info: 'bg-blue-50 text-blue-700 border border-blue-200',
        neutral: 'bg-tokens-neutral text-tokens-secondary-content border border-tokens-outline',
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

type BadgeProps = ComponentProps<'span'> & VariantProps<typeof badgeVariants>;

const StatusBadge: FC<BadgeProps> = ({ className, variant, size, children, ...props }) => (
  <span
    data-slot="status-badge"
    className={cn(badgeVariants({ variant, size }), className)}
    {...props}
  >
    {children}
  </span>
);

export default StatusBadge;
```

## CVA with Compound Components

Combine CVA for the root and simple cn() for sub-components:

```typescript
const cardVariants = cva(
  'rounded-lg border bg-background transition-shadow',
  {
    variants: {
      variant: {
        default: 'border-border',
        elevated: 'border-border shadow-md',
        outlined: 'border-2 border-tokens-primary',
        ghost: 'border-transparent bg-transparent',
      },
      padding: {
        none: '',
        sm: 'p-3',
        md: 'p-4',
        lg: 'p-6',
      },
    },
    defaultVariants: {
      variant: 'default',
      padding: 'md',
    },
  },
);
```

## Rules

- **Base styles** (first argument): shared by all variants — include disabled, focus, transition
- **Always set `defaultVariants`** so the component works without explicit variant props
- **Use semantic token colors** — never hardcoded hex values
- **Include disabled state in base**: `disabled:pointer-events-none disabled:opacity-50`
- **Include focus styles in base**: `focus-visible:ring-2 focus-visible:ring-tokens-primary focus-visible:ring-offset-2`
- For **1-2 variants**, skip CVA and use:
  ```typescript
  className={cn('base', variant === 'primary' && 'bg-primary text-primary-foreground')}
  ```

## Compound Variants

For styles that depend on multiple variant dimensions:

```typescript
const buttonVariants = cva('inline-flex items-center justify-center rounded-md font-medium', {
  variants: {
    variant: {
      primary: 'bg-tokens-primary text-white',
      secondary: 'bg-tokens-neutral text-foreground',
      destructive: 'bg-destructive text-destructive-foreground',
    },
    size: {
      sm: 'h-8 px-3 text-sm',
      md: 'h-10 px-4 text-sm',
      lg: 'h-12 px-6 text-base',
    },
  },
  compoundVariants: [
    // Small destructive buttons get extra padding
    { variant: 'destructive', size: 'sm', className: 'px-4' },
  ],
  defaultVariants: {
    variant: 'primary',
    size: 'md',
  },
});
```
