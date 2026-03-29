# Styling Rules Reference

## Theme-Aware Classes

Never use hardcoded colors. Use semantic tokens:

| Hardcoded (WRONG) | Theme Token (CORRECT) |
|-------------------|----------------------|
| `bg-white` | `bg-background` |
| `bg-black` | `bg-foreground` |
| `text-white` (on colored bg) | `text-primary-foreground` or appropriate |
| `text-black` | `text-foreground` |
| `text-slate-900` | `text-foreground` |
| `text-slate-700` | `text-foreground` |
| `text-slate-500` | `text-muted-foreground` |
| `text-slate-400` | `text-muted-foreground` |
| `text-gray-900` | `text-foreground` |
| `text-gray-500` | `text-muted-foreground` |
| `bg-slate-100` | `bg-muted` |
| `bg-slate-50` | `bg-muted` or `bg-background` |
| `bg-gray-50` | `bg-muted` or `bg-background` |
| `border-slate-200` | `border-border` |
| `border-slate-300` | `border-border` |
| `border-gray-200` | `border-border` |
| `divide-slate-200` | `divide-border` |

## Project Color Scales

Use project-specific color scales (defined in `src/index.css`):

| Scale | Usage |
|-------|-------|
| `blue-25` through `blue-950` | Primary blue scale |
| `dda-blue-25` through `dda-blue-950` | DDA brand blue scale |
| `gray-25` through `gray-950` | Neutral gray scale |
| `error-25` through `error-950` | Error/danger states |
| `success-25` through `success-950` | Success states |
| `warning-25` through `warning-950` | Warning states |
| `tokens-primary`, `tokens-accent`, etc. | Design token system |

Do NOT use Tailwind default scales (`slate-*`, `zinc-*`, `stone-*`, `neutral-*`) — they are not the project's tokens.

## Inline Color Values

Flag any hex, rgb, rgba, or hsl values:

```typescript
// WRONG
className="text-[#333333]"
style={{ color: '#666' }}
style={{ backgroundColor: 'rgb(255, 255, 255)' }}
```

## Adding New Colors

If a Figma color does not exist in `src/index.css`:
1. Add the CSS custom property to `:root` (light) AND `.dark` (dark)
2. Register it in the `@theme inline` block
3. Use oklch format to match the existing system
4. Never leave a color without a dark mode counterpart

## Spacing Scale

Always divide pixels by 4 for Tailwind spacing:

| Pixels | Tailwind | Pixels | Tailwind |
|--------|----------|--------|----------|
| 4px | 1 | 28px | 7 |
| 8px | 2 | 32px | 8 |
| 12px | 3 | 36px | 9 |
| 16px | 4 | 40px | 10 |
| 18px | 4.5 | 48px | 12 |
| 20px | 5 | 56px | 14 |
| 24px | 6 | 64px | 16 |

**Never use arbitrary pixel values when a scale value exists:**
```
p-[24px]   → p-6     WRONG → CORRECT
gap-[32px] → gap-8   WRONG → CORRECT
mt-[16px]  → mt-4    WRONG → CORRECT
```

Only use arbitrary values for truly non-standard measurements that don't divide cleanly.

## No Inline Styles

Tailwind only — no CSS files, no style tags, no inline styles:

```typescript
// CORRECT
className="flex items-center gap-4 rounded-lg border bg-background p-6"

// WRONG
style={{ display: 'flex', padding: '24px' }}
```

## Typography

- Use `font-sans` — no custom font declarations
- Use Tailwind's responsive type scale (`text-sm`, `text-base`, `text-lg`, etc.)
- Match font weights to Tailwind: `font-normal` (400), `font-medium` (500), `font-semibold` (600), `font-bold` (700)

## Responsive Design

Mobile-first with Tailwind breakpoints:

| Breakpoint | Width |
|------------|-------|
| `xs` | 425px (custom) |
| `sm` | 640px |
| `md` | 768px |
| `lg` | 1024px |
| `xl` | 1280px |
| `2xl` | 1536px |

```typescript
// CORRECT — mobile first
className="flex flex-col gap-4 p-4 md:flex-row md:gap-6 md:p-6 lg:gap-8"

// WRONG — desktop first
className="flex flex-row gap-8 p-6 sm:flex-col sm:gap-4 sm:p-4"
```

## Shadows and Border Radius

Use existing tokens — no custom inline values:
- Shadows: `shadow-xs`, `shadow-sm`, `shadow-md`, `shadow-lg`, `shadow-xl`, `shadow-2xl`
- Border radius: `rounded-sm`, `rounded`, `rounded-md`, `rounded-lg`, `rounded-xl`, `rounded-2xl`, `rounded-3xl`, `rounded-full`
