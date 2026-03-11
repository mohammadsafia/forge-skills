# Styling Rules Reference

## Theme-Aware Classes

Never use hardcoded colors. Use semantic tokens:

| Hardcoded (WRONG) | Theme Token (CORRECT) |
|-------------------|----------------------|
| `bg-white` | `bg-background` |
| `bg-black` | `bg-foreground` |
| `text-slate-900` | `text-foreground` |
| `text-slate-500` | `text-muted-foreground` |
| `text-gray-500` | `text-muted-foreground` |
| `border-slate-200` | `border-border` |
| `border-gray-200` | `border-border` |
| `bg-slate-100` | `bg-muted` |
| `bg-gray-100` | `bg-muted` |

Use project-specific color scales (defined in `src/index.css`):
- `bg-blue-500`, `text-blue-700` (project blue scale)
- `bg-gray-100`, `text-gray-600` (project gray scale)
- `bg-error-500`, `text-error-700` (project error scale)
- `bg-success-500`, `text-success-700` (project success scale)
- `bg-warning-500`, `text-warning-700` (project warning scale)
- `bg-tokens-primary`, `text-tokens-accent-content` (token system)

Do NOT use Tailwind default scales (slate, zinc, stone, neutral) — they are not the project's tokens.

## Spacing Scale

Always divide pixels by 4 for Tailwind spacing:

| Pixels | Tailwind | Example |
|--------|----------|---------|
| 4px | 1 | `p-1`, `gap-1` |
| 8px | 2 | `p-2`, `gap-2` |
| 12px | 3 | `p-3`, `gap-3` |
| 16px | 4 | `p-4`, `gap-4` |
| 20px | 5 | `p-5`, `gap-5` |
| 24px | 6 | `p-6`, `gap-6` |
| 32px | 8 | `p-8`, `gap-8` |
| 40px | 10 | `p-10`, `gap-10` |
| 48px | 12 | `p-12`, `gap-12` |
| 64px | 16 | `p-16`, `gap-16` |

**Never use arbitrary pixel values when a scale value exists:**
```
p-[24px]  → p-6     ✗ WRONG → ✓ CORRECT
gap-[32px] → gap-8   ✗ WRONG → ✓ CORRECT
mt-[16px]  → mt-4    ✗ WRONG → ✓ CORRECT
```

## No Inline Styles

Tailwind only — no CSS files, no style tags, no inline styles:

```typescript
// CORRECT
className="flex items-center gap-4 rounded-lg border bg-background p-6"

// WRONG
style={{ display: 'flex', padding: '24px' }}
```

## Responsive Design

Mobile-first with Tailwind breakpoints: `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px), `2xl` (1536px), plus custom `xs` (425px).

```typescript
// CORRECT — mobile first
className="flex flex-col gap-4 p-4 md:flex-row md:gap-6 md:p-6 lg:gap-8"

// WRONG — desktop first
className="flex flex-row gap-8 p-6 sm:flex-col sm:gap-4 sm:p-4"
```

## Font Families

Use `font-sans` (Dubai/Inter) — no custom font declarations.

## Shadows and Border Radius

Use existing tokens:
- Shadows: `shadow-xs`, `shadow-sm`, `shadow-md`, `shadow-lg`, `shadow-xl`, `shadow-2xl`
- Border radius: `rounded-sm`, `rounded`, `rounded-md`, `rounded-lg`, `rounded-xl`, `rounded-2xl`, `rounded-3xl`, `rounded-full`
