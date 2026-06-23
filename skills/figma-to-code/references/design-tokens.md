# Design Token Mapping

## Semantic Tokens

| Token | Tailwind Class | Usage |
|-------|---------------|-------|
| `--background` | `bg-background` | Page/section backgrounds |
| `--foreground` | `text-foreground` | Primary text |
| `--primary` | `bg-primary`, `text-primary` | Primary actions, links |
| `--primary-foreground` | `text-primary-foreground` | Text on primary backgrounds |
| `--secondary` | `bg-secondary` | Secondary surfaces |
| `--secondary-foreground` | `text-secondary-foreground` | Text on secondary |
| `--muted` | `bg-muted` | Muted/subtle backgrounds |
| `--muted-foreground` | `text-muted-foreground` | Secondary text, placeholders |
| `--accent` | `bg-accent` | Accent highlights |
| `--accent-foreground` | `text-accent-foreground` | Text on accent |
| `--destructive` | `bg-destructive` | Destructive actions |
| `--destructive-foreground` | `text-destructive-foreground` | Text on destructive |
| `--border` | `border-border` | Default borders |
| `--input` | `border-input` | Input borders |
| `--ring` | `ring-ring` | Focus rings |
| `--card` | `bg-card` | Card backgrounds |
| `--card-foreground` | `text-card-foreground` | Card text |
| `--popover` | `bg-popover` | Popover/dropdown backgrounds |
| `--popover-foreground` | `text-popover-foreground` | Popover text |

## Color Scales

### Blue Scale
| Token | Tailwind | Hex (approx) |
|-------|----------|-------------|
| `--blue-25` | `bg-blue-25`, `text-blue-25` | Lightest |
| `--blue-50` | `bg-blue-50` | |
| `--blue-100` | `bg-blue-100` | |
| `--blue-200` | `bg-blue-200` | |
| `--blue-300` | `bg-blue-300` | |
| `--blue-400` | `bg-blue-400` | |
| `--blue-500` | `bg-blue-500` | Primary blue |
| `--blue-600` | `bg-blue-600` | |
| `--blue-700` | `bg-blue-700`, `text-blue-700` | |
| `--blue-800` | `bg-blue-800` | |
| `--blue-900` | `bg-blue-900` | |
| `--blue-950` | `bg-blue-950` | Darkest |

### Brand Color Scale (Optional)

Projects may define additional brand-specific color scales (e.g., `--brand-25` to `--brand-950`). Check your project's `src/index.css` for custom scales beyond the defaults.

### Gray Scale

> **Dark mode caveat:** The project defines its own `gray-*` custom properties in `src/index.css` with `:root` and `.dark` variants. These are NOT the same as Tailwind's built-in `gray-*` palette. Always verify your gray tokens come from the project's CSS custom properties. When in doubt, prefer semantic tokens (`bg-muted`, `text-muted-foreground`, `border-border`) which are guaranteed to be dark-mode safe.

| Token | Tailwind | Preferred Semantic Alternative |
|-------|----------|-------------------------------|
| `--gray-25` to `--gray-950` | `bg-gray-*`, `text-gray-*`, `border-gray-*` | `bg-muted`, `text-muted-foreground`, `border-border` |

### Error Scale
| Token | Tailwind | Usage |
|-------|----------|-------|
| `--error-25` to `--error-950` | `bg-error-*`, `text-error-*` | Error states, validation |

### Success Scale
| Token | Tailwind | Usage |
|-------|----------|-------|
| `--success-25` to `--success-950` | `bg-success-*`, `text-success-*` | Success states |

### Warning Scale
| Token | Tailwind | Usage |
|-------|----------|-------|
| `--warning-25` to `--warning-950` | `bg-warning-*`, `text-warning-*` | Warning states |

## Token System

| Token | Tailwind | Usage |
|-------|----------|-------|
| `--tokens-primary` | `bg-tokens-primary` | Primary brand color |
| `--tokens-accent` | `bg-tokens-accent` | Accent color |
| `--tokens-accent-content` | `text-tokens-accent-content` | Text on accent |
| `--tokens-neutral` | `bg-tokens-neutral` | Neutral surfaces |
| `--tokens-secondary-content` | `text-tokens-secondary-content` | Secondary text |
| `--tokens-outline` | `border-tokens-outline` | Outline borders |

## Shadows

| Token | Tailwind |
|-------|----------|
| `--shadow-xs` | `shadow-xs` |
| `--shadow-sm` | `shadow-sm` |
| `--shadow-md` | `shadow-md` |
| `--shadow-lg` | `shadow-lg` |
| `--shadow-xl` | `shadow-xl` |
| `--shadow-2xl` | `shadow-2xl` |
| `--shadow-custom` | `shadow-custom` |

## Gradients

| Token | Tailwind |
|-------|----------|
| `--gradient-custom-1` | `bg-gradient-custom-1` |
| `--gradient-custom-2` | `bg-gradient-custom-2` |
| `--gradient-custom-3` | `bg-gradient-custom-3` |
| `--gradient-custom-4` | `bg-gradient-custom-4` |
| `--gradient-custom-5` | `bg-gradient-custom-5` |

## Adding New Tokens

When a Figma color doesn't exist in the project:

1. Add to `:root` in `src/index.css`:
```css
:root {
  --new-color-500: oklch(0.65 0.18 250);
}
```

2. Add dark mode counterpart:
```css
.dark {
  --new-color-500: oklch(0.55 0.15 250);
}
```

3. Register in `@theme inline` block:
```css
@theme inline {
  --color-new-color-500: var(--new-color-500);
}
```

4. Use in components: `bg-new-color-500`, `text-new-color-500`

## Common Figma-to-Token Mappings

| Figma Color | Project Token |
|-------------|--------------|
| White (#FFFFFF) | `bg-background` (not `bg-white`) |
| Black (#000000) | `text-foreground` (not `text-black`) |
| Light gray background | `bg-muted` |
| Gray text | `text-muted-foreground` |
| Border gray | `border-border` |
| Primary blue | `bg-primary` or `bg-tokens-primary` |
| Success green | `bg-success-500` |
| Error red | `bg-error-500` or `bg-destructive` |
| Warning yellow | `bg-warning-500` |
