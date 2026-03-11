# Common Violations (Ranked by Frequency)

## Top 20 Violations

| # | Violation | Rule | Severity |
|---|-----------|------|----------|
| 1 | Deep import instead of barrel | Imports B | Error |
| 2 | `&&` conditional instead of `Conditional.If` | Patterns C | Error |
| 3 | Hardcoded colors (`bg-white`, `text-slate-*`) | Styling I | Error |
| 4 | Missing `import type` for DTOs | Imports B | Warning |
| 5 | `interface` instead of `type` | Types A | Warning |
| 6 | Arbitrary pixel values (`p-[24px]`) | Styling L | Warning |
| 7 | Import groups not separated by blank lines | Imports B | Warning |
| 8 | Template literal className instead of `cn()` | Styling I | Warning |
| 9 | Missing debounce on search inputs | Patterns K | Error |
| 10 | Custom date formatter instead of `useDate` | Patterns J | Error |
| 11 | Raw string for status fields | Types A | Warning |
| 12 | PascalCase folder names | Structure G | Warning |
| 13 | Inline SVG instead of icon component | Imports B | Warning |
| 14 | Array queryKey in handler | API E | Error |
| 15 | Inline request function in handler | API E | Error |
| 16 | View wrapping a page (unnecessary) | Structure G | Warning |
| 17 | Explicit return type on React Query hook | Hooks F | Warning |
| 18 | Function callback in ApiEndpoints | API E | Error |
| 19 | Zod schema in `src/types/` instead of feature | Types A | Warning |
| 20 | Asterisk in translation label | i18n | Warning |

## Quick Reference

### Severity Levels

- **Error**: Must fix — breaks conventions or causes bugs
- **Warning**: Should fix — style/consistency issue

### Auto-Fixable Violations

These can be transformed automatically:
- #1 Deep imports → barrel imports
- #3 Hardcoded colors → theme tokens
- #4 Missing `import type`
- #5 `interface` → `type`
- #6 Arbitrary pixels → scale values
- #7 Import group ordering
- #8 Template literal → `cn()`

### Manual Review Required

These need judgment:
- #2 `&&` → `Conditional.If` (verify fallback behavior)
- #9 Debounce (need to understand the data flow)
- #10 Date formatting (need to check hook availability)
- #11 String → type literal (need to know valid values)
