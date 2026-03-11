---
name: forge:review-code
description: "Review code against project standards and best practices. Use this skill when the user asks to review code, check code quality, audit a file, validate standards compliance, or says things like 'review this', 'check my code', 'is this correct', 'audit this file', 'does this follow our standards'. Also use when the user has finished implementing something and wants verification before committing."
---

# Review Code

Systematically review code files against project standards and output a structured report with file:line references.

## Workflow

### Step 1 — Determine Scope

Figure out what to review:
- If the user mentions specific files → review those files
- If the user says "review my changes" → run `git diff --name-only` and `git diff --staged --name-only` to find changed files
- If the user says "review this PR" → run `git diff main...HEAD --name-only` to find all changed files in the branch

### Step 2 — Read Each File and Check Against Rules

For each file, check these categories. Read the corresponding reference file for detailed rules when needed.

**Import Rules** (see `references/import-rules.md`):
- UI components from barrel `@components/ui` only — not individual files
- Shared components from barrel `@components/shared` only
- Custom icons from `@assets/icons` barrel only
- Path aliases used everywhere — no deep relative imports (`../../`)
- Import order: React → third-party → UI → shared → views → contexts/hooks → utils/constants → icons → types
- `import type` for type-only imports
- One empty line between import groups, no empty lines within groups

**Type Rules** (see `references/type-rules.md`):
- `type` over `interface` (interface only for extension/merging)
- No `any`, no implicit types, no unsafe casting
- Exported functions have explicit return types (except React Query hooks — those infer)
- DTO naming: `ForReadDto`, `ForCreateDto`, `ForUpdateDto`, `ListDto`, `ParamsDto`
- Status/type fields use enums or type literals — never raw `string`

**Component Rules** (see `references/component-rules.md`):
- `Conditional.If` for show/hide — never `&&` or ternary for simple conditional rendering
- `cn()` for conditional classes — never template literal concatenation
- Event handlers named `handle*`
- Internal code order: core hooks → context → shared hooks → queries → state → memo → callbacks → effects → JSX
- Pages contain logic directly — no View wrappers just to wrap
- Folders use kebab-case — never PascalCase
- No separator/divider comments (`// ----`, `// ====`)

**Styling Rules** (see `references/styling-rules.md`):
- Theme-aware classes only: `bg-background` not `bg-white`, `text-foreground` not `text-slate-900`
- Tailwind spacing scale — not arbitrary pixel values like `p-[24px]`
- No inline styles, no CSS files, no style tags
- Use project color tokens (blue-*, gray-*, error-*, etc.) not Tailwind defaults (slate-*, zinc-*)

**API Rules:**
- Endpoints in `ApiEndpoints.ts` as plain strings — no function callbacks
- Handler `queryKey` is a string — not an array
- Request functions defined above handler object, referenced by name
- React Query hooks have no explicit return types

**Form Rules:**
- Must use FormProvider-based `FormContainer` — no raw `useForm` in pages
- No asterisks (`*`) in translation labels — `required` prop handles the indicator

**General:**
- Debounce search inputs (300ms default with `useDebounce` hook)
- Use `useDate`/`useTime` hooks — never custom date/time formatters
- No inline SVGs — extract to `src/assets/icons/` with barrel export
- No `Co-Authored-By` in commit messages

### Step 3 — Output Structured Report

```markdown
## Code Review Report

### Errors (must fix)
- `src/pages/OrdersPage.tsx:12` — Importing Button from `@components/ui/button` instead of barrel `@components/ui`
- `src/views/orders/OrderCard.tsx:45` — Using `{isVisible && <Component />}` instead of `Conditional.If`
- `src/types/api/order.ts:8` — Using `interface` instead of `type`

### Warnings (should fix)
- `src/pages/OrdersPage.tsx:88` — Using `bg-white` instead of `bg-background`
- `src/views/orders/OrderCard.tsx:22` — Using `p-[24px]` instead of `p-6`

### Suggestions
- `src/pages/OrdersPage.tsx:45,67,89` — Repeated JSX pattern could be extracted into a component
- Consider adding `data-slot` attributes to semantic elements

### Summary
3 errors, 2 warnings, 2 suggestions across 2 files
```

**Severity classification:**
- **Error**: Violates a hard rule that will cause issues (wrong imports, wrong patterns, type violations)
- **Warning**: Violates a convention that should be fixed (hardcoded colors, arbitrary spacing)
- **Suggestion**: Improvement opportunity that isn't a rule violation (DRY opportunities, missing accessibility)
