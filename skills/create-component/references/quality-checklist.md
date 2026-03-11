# Component Quality Checklist

Verify ALL items before exporting any reusable component.

## 1. Accessibility

- [ ] Interactive elements have `aria-label` or visible label text
- [ ] Keyboard navigation works (`Tab`, `Enter`, `Escape`)
- [ ] Focus ring visible: `focus-visible:ring-2 focus-visible:ring-tokens-primary focus-visible:ring-offset-2`
- [ ] Disabled state: `disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50`
- [ ] If wrapping a Radix primitive, delegate ARIA/focus/keyboard to Radix

## 2. Theme & Dark Mode

- [ ] Zero hardcoded colors — only semantic tokens
- [ ] `bg-background` not `bg-white`
- [ ] `text-foreground` not `text-slate-900`
- [ ] `text-muted-foreground` not `text-slate-500`
- [ ] `border-border` not `border-slate-200`
- [ ] Every color works in both light and dark mode

## 3. RTL Support

- [ ] Directional margin/padding uses `rtl:` prefix or logical properties (`ms-*`, `me-*`)
- [ ] Border radius uses `rtl:` mirroring where directional
- [ ] Icons with directional meaning flip: `rtl:rotate-180`
- [ ] Flex layouts that need mirroring use `rtl:flex-row-reverse`

## 4. Responsive

- [ ] Mobile-first: base styles target mobile
- [ ] Breakpoint overrides: `sm`, `md`, `lg`, `xl`, `2xl`
- [ ] Stack vertically on mobile: `flex flex-col lg:flex-row`
- [ ] Padding/gaps adjust per breakpoint

## 5. Sub-Component Signatures

- [ ] Every sub-component accepts `className?`
- [ ] Uses `cn('default-styles', className)` for merging
- [ ] Spreads `...props` for native HTML passthrough
- [ ] Has `data-slot="component-name-slot-name"`
- [ ] Uses semantic HTML elements where appropriate

## 6. Component Size

- [ ] Single responsibility — one component, one job
- [ ] JSX under ~150 lines (break into sub-components if larger)
- [ ] No repeated JSX blocks (extract at 3+ usages)
- [ ] Prefers composition (children/slots) over configuration (boolean props)

## 7. forwardRef

- [ ] Used ONLY when consumer needs DOM access (inputs, buttons, triggers)
- [ ] Skipped for container/layout components
- [ ] `displayName` set when using forwardRef

## 8. Export & Barrel

- [ ] Default export from component file
- [ ] Re-exported from `index.ts` in component folder
- [ ] Added to `src/components/shared/index.ts` barrel
