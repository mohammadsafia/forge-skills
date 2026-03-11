# Component Output Checklist

Verify every item before delivering a Figma-to-code component.

## Colors & Theme
- [ ] Zero hardcoded colors — no `bg-white`, `text-black`, `text-slate-*`, hex values
- [ ] All colors use project tokens (`bg-background`, `text-foreground`, `bg-primary`, etc.)
- [ ] Every color works in both light and dark mode
- [ ] New tokens added to both `:root` and `.dark` in `index.css`

## Spacing
- [ ] All spacing uses Tailwind scale (divide pixels by 4)
- [ ] No arbitrary pixel values like `p-[24px]` when `p-6` exists
- [ ] Consistent spacing rhythm (not mixing random values)

## Typography
- [ ] Uses `font-sans` — no custom font declarations
- [ ] Font sizes use Tailwind scale (`text-sm`, `text-base`, etc.)
- [ ] Font weights use Tailwind classes (`font-medium`, `font-semibold`)

## Component Reuse
- [ ] Checked `src/components/ui/` for existing primitives
- [ ] Checked `src/components/shared/` for existing composites
- [ ] Using existing components instead of rebuilding
- [ ] Icons from `lucide-react` or `@assets/icons` barrel

## Imports
- [ ] UI from barrel: `import { Button } from '@components/ui'`
- [ ] Shared from barrel: `import { ... } from '@components/shared'`
- [ ] Icons from barrel: `import { ... } from '@assets/icons'`
- [ ] Path aliases used (no relative `../../`)
- [ ] Correct import group order
- [ ] Types use `import type`

## Patterns
- [ ] Uses `Conditional.If` (not `&&` pattern)
- [ ] Uses `cn()` for conditional classes
- [ ] Event handlers named `handle*`
- [ ] Component code order: hooks → state → memo → callbacks → effects → JSX
- [ ] `data-slot` attributes on semantic elements

## Responsive
- [ ] Mobile-first (base styles for mobile)
- [ ] Breakpoint overrides for larger screens
- [ ] Uses `sm`, `md`, `lg`, `xl`, `2xl` breakpoints
- [ ] Layout stacks vertically on mobile, horizontal on desktop

## RTL
- [ ] Directional margins/padding use `rtl:` prefix or logical properties
- [ ] Directional border-radius mirrored
- [ ] Directional icons flip in RTL
- [ ] Flex layouts with directional content handled

## Accessibility
- [ ] Interactive elements have `aria-label` or visible label
- [ ] Focus ring: `focus-visible:ring-2 focus-visible:ring-tokens-primary focus-visible:ring-offset-2`
- [ ] Disabled: `disabled:pointer-events-none disabled:opacity-50`
- [ ] Keyboard navigation works
- [ ] Semantic HTML elements used

## TypeScript
- [ ] Uses `type` not `interface`
- [ ] No `any` or unsafe casting
- [ ] Props properly typed
- [ ] Exported functions have explicit return types
