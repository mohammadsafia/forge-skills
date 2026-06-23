---
name: forge:add-icon
description: "Convert SVG markup into a properly exported icon component. Use when the user wants to add a custom icon, convert SVG to component, create an icon from SVG, or says 'add icon', 'new icon', 'convert SVG', 'create icon component', 'add custom icon'. Triggers whenever SVG markup needs to become a reusable icon component in the assets/icons directory."
---

# Add Icon

Convert raw SVG markup into a React icon component with proper barrel export.

## Step 1 — Get the SVG

Accept SVG from:
- User-provided SVG markup
- Figma export (via Figma MCP tools)
- An SVG file path

## Step 1b — Scan Existing Icons

Read `src/assets/icons/index.ts` to understand the barrel export pattern and naming conventions.

See `_shared/code-standards.md` for all project rules (section 5.7).

## Step 2 — Create Icon Component

File: `src/assets/icons/<IconName>.tsx`

```typescript
import { type SVGProps } from 'react';

export default function IconName(props: SVGProps<SVGSVGElement>) {
  return (
    <svg
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      {...props}
    >
      <path d="..." fill="currentColor" />
    </svg>
  );
}
```

### SVG Cleanup Rules

1. **Remove** `xmlns` if already on the SVG element (React handles it)
2. **Convert** HTML attributes to React: `fill-rule` → `fillRule`, `clip-path` → `clipPath`, `stroke-width` → `strokeWidth`
3. **Replace** hardcoded colors with `currentColor` (so the icon inherits text color)
4. **Keep** `viewBox` for proper scaling
5. **Spread `...props`** on the `<svg>` element for className, size overrides
6. **Default** width/height to 24x24 (can be overridden via props)

## Step 3 — Update Barrel Export

```typescript
// src/assets/icons/index.ts — add:
export { default as IconName } from './IconName';
```

## Step 4 — Usage

```tsx
// CORRECT — Import from barrel
import { IconName } from '@assets/icons';

<IconName className="h-5 w-5 text-muted-foreground" />

// For directional icons, add RTL flip
<IconName className="h-5 w-5 rtl:rotate-180" />
```

## Rules

See `_shared/code-standards.md` for all project rules (section 5.7). Icon-specific rules:

- No inline SVG in components — all icons in `src/assets/icons/`
- Named export from barrel `index.ts`
- Add `data-slot="icon"` to the `<svg>` element
- Decorative icons: `aria-hidden="true"`. Standalone interactive icons: `aria-label`
- Directional icons: use `className="rtl:rotate-180"` when needed
