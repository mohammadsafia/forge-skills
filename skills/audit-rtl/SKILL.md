---
name: forge:audit-rtl
description: "Audit components for RTL (right-to-left) support — find directional styling issues. Use when the user mentions RTL, Arabic, bidirectional layout, or says 'check RTL', 'does this work in Arabic', 'fix RTL', 'audit bidirectional'. Important for projects supporting Arabic or Hebrew."
---

# Audit RTL

Scan components for directional styling that breaks in RTL mode and suggest fixes.

## What to Scan For

### Directional Margins and Padding
```typescript
// Find → Replace
ml-* without rtl: counterpart → use ms-* (margin-inline-start) or add rtl:mr-*
mr-* without rtl: counterpart → use me-* (margin-inline-end) or add rtl:ml-*
pl-* without rtl: counterpart → use ps-* (padding-inline-start) or add rtl:pr-*
pr-* without rtl: counterpart → use pe-* (padding-inline-end) or add rtl:pl-*
```

### Directional Border Radius
```typescript
// Find → Fix
rounded-l-* → add rtl:rounded-l-none rtl:rounded-r-*
rounded-r-* → add rtl:rounded-r-none rtl:rounded-l-*
rounded-tl-* → add rtl:rounded-tl-none rtl:rounded-tr-*
rounded-tr-* → add rtl:rounded-tr-none rtl:rounded-tl-*
rounded-bl-* → add rtl:rounded-bl-none rtl:rounded-br-*
rounded-br-* → add rtl:rounded-br-none rtl:rounded-bl-*
```

### Directional Positioning
```typescript
// Find → Fix
left-* → add rtl:left-auto rtl:right-*
right-* → add rtl:right-auto rtl:left-*
```

### Text Alignment
```typescript
// Find → Fix
text-left → add rtl:text-right
text-right → add rtl:text-left
```

### Directional Borders
```typescript
// Find → Fix
border-l → add rtl:border-l-0 rtl:border-r
border-r → add rtl:border-r-0 rtl:border-l
border-l-* → add rtl:border-l-0 rtl:border-r-*
```

### Directional Icons
Icons with directional meaning (arrows, chevrons) need to flip:
```typescript
// CORRECT
<ChevronRight className="h-4 w-4 rtl:rotate-180" />
<ArrowLeft className="h-4 w-4 rtl:rotate-180" />

// WRONG — no flip
<ChevronRight className="h-4 w-4" />
```

### Flex Layouts
Layouts where visual order matters may need mirroring:
```typescript
// When content order is directional
className="flex flex-row rtl:flex-row-reverse"
```

### Transform Origins
```typescript
// Find → Fix
origin-left → add rtl:origin-right
origin-right → add rtl:origin-left
```

## Safe Patterns (No Fix Needed)

These are fine without RTL counterparts:
- `mx-*`, `px-*` (both sides equal)
- `mt-*`, `mb-*`, `pt-*`, `pb-*` (vertical, not directional)
- `rounded-t-*`, `rounded-b-*` (vertical)
- `text-center` (no direction)
- Flexbox `gap-*` (handled by browser)
- CSS Grid gaps (handled by browser)

## Report Format

```markdown
## RTL Audit

### Issues
- `Component.tsx:15` — `ml-4` without RTL counterpart → use `ms-4` or add `rtl:mr-4 rtl:ml-0`
- `Component.tsx:28` — `rounded-l-lg` without RTL mirroring
- `Component.tsx:42` — `ChevronRight` icon not flipping in RTL → add `rtl:rotate-180`
- `Component.tsx:55` — `text-left` without `rtl:text-right`

### Summary
X directional issues found
```
