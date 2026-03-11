---
name: forge:audit-a11y
description: "Audit components for accessibility issues — ARIA, keyboard navigation, focus management, screen readers. Use when the user asks about accessibility, a11y, ARIA, or says 'check accessibility', 'is this accessible', 'audit a11y', 'add aria labels'. Also triggers when reviewing interactive UI components."
---

# Audit Accessibility

Scan components for accessibility violations and output a report with file:line references and fixes.

## What to Check

### 1. Interactive Elements Without Labels
- Buttons without visible text need `aria-label`
- Icon-only buttons need `aria-label` describing the action
- Links without descriptive text need `aria-label`

```typescript
// CORRECT
<Button aria-label="Delete order"><Trash className="h-4 w-4" /></Button>

// WRONG
<Button><Trash className="h-4 w-4" /></Button>
```

### 2. Clickable Non-Interactive Elements
- `<div>` or `<span>` with `onClick` need `role="button"`, `tabIndex={0}`, and `onKeyDown` handler

```typescript
// CORRECT
<div role="button" tabIndex={0} onClick={handleClick} onKeyDown={(e) => e.key === 'Enter' && handleClick()}>

// WRONG
<div onClick={handleClick}>
```

### 3. Focus Rings
Interactive elements should have visible focus indicators:
```typescript
focus-visible:ring-2 focus-visible:ring-tokens-primary focus-visible:ring-offset-2
```

### 4. Disabled States
Disabled elements should have:
```typescript
disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50
```

### 5. Images Without Alt Text
```typescript
// CORRECT
<img src={url} alt="Product thumbnail" />
<img src={url} alt="" /> // Decorative image

// WRONG
<img src={url} />
```

### 6. Form Inputs Without Labels
Every input needs an associated label — either via `<label htmlFor>`, `aria-label`, or `aria-labelledby`.

### 7. Color-Only Indicators
Information conveyed only by color needs a text or icon alternative for colorblind users.

### 8. Radix UI Primitives
When wrapping Radix primitives, delegate ARIA/focus/keyboard to Radix — don't manually reimplement.

## Report Format

```markdown
## Accessibility Audit

### Errors
- `ComponentName.tsx:25` — Icon button missing `aria-label`
- `ComponentName.tsx:42` — Clickable div without `role="button"` and keyboard handler

### Warnings
- `ComponentName.tsx:60` — Missing focus ring on interactive element
- `ComponentName.tsx:78` — Image without `alt` attribute

### Summary
X errors, Y warnings
```
