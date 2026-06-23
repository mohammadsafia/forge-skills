> Rules: see `_shared/code-standards.md`. This file contains code examples only.

# Styling Rules — Code Examples

## Inline Color Values

```typescript
// WRONG
className="text-[#333333]"
style={{ color: '#666' }}
style={{ backgroundColor: 'rgb(255, 255, 255)' }}
```

## No Inline Styles

```typescript
// CORRECT
className="flex items-center gap-4 rounded-lg border bg-background p-6"

// WRONG
style={{ display: 'flex', padding: '24px' }}
```

## Spacing Scale Examples

```
p-[24px]   → p-6     WRONG → CORRECT
gap-[32px] → gap-8   WRONG → CORRECT
mt-[16px]  → mt-4    WRONG → CORRECT
```

## Responsive Design (mobile-first)

```typescript
// CORRECT — mobile first
className="flex flex-col gap-4 p-4 md:flex-row md:gap-6 md:p-6 lg:gap-8"

// WRONG — desktop first
className="flex flex-row gap-8 p-6 sm:flex-col sm:gap-4 sm:p-4"
```

## Adding New Colors

If a Figma color does not exist in `src/index.css`:
1. Add the CSS custom property to `:root` (light) AND `.dark` (dark)
2. Register it in the `@theme inline` block
3. Use oklch format to match the existing system
4. Never leave a color without a dark mode counterpart
