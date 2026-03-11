---
name: forge:audit-dark-mode
description: "Audit components for dark mode compliance — find hardcoded colors that break in dark mode. Use when the user mentions dark mode, theme issues, hardcoded colors, or says 'check dark mode', 'fix colors', 'audit theme', 'find hardcoded colors'. Triggers when reviewing UI that should work in both light and dark themes."
---

# Audit Dark Mode

Scan components for hardcoded colors that break in dark mode and suggest theme-aware replacements.

## What to Scan For

### Hardcoded Tailwind Colors

| Find | Replace With |
|------|-------------|
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

### Tailwind Default Scales (Not Project Tokens)
Flag any usage of `slate-*`, `zinc-*`, `stone-*`, `neutral-*` — these are Tailwind defaults, not the project's design tokens. The project uses its own `gray-*`, `blue-*`, `error-*`, `success-*`, `warning-*` scales defined in `src/index.css`.

### Inline Color Values
Flag any hex, rgb, rgba, or hsl values in className or style attributes:
```typescript
// WRONG
className="text-[#333333]"
style={{ color: '#666' }}
style={{ backgroundColor: 'rgb(255, 255, 255)' }}
```

### Missing Dark Mode Counterparts
Check `src/index.css` for any CSS custom property defined in `:root` but missing from `.dark`.

## Report Format

```markdown
## Dark Mode Audit

### Violations
- `Component.tsx:15` — `bg-white` → use `bg-background`
- `Component.tsx:28` — `text-slate-500` → use `text-muted-foreground`
- `Component.tsx:42` — `text-[#333]` → use theme token

### Missing Dark Mode Values
- `--custom-color-500` defined in `:root` but missing from `.dark`

### Summary
X violations found, Y missing dark values
```

## Auto-Fix

When the user confirms, apply the replacement mapping automatically. For ambiguous cases (where multiple theme tokens could apply), ask the user which token to use.
