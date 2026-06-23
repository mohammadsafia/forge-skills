# RSK Skill Extraction Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace forge-skills' duplicated rules with a single shared CODE_STANDARDS.md from rsk, and update all skill scan steps to point at real rsk file paths.

**Architecture:** Copy rsk's CODE_STANDARDS.md as a shared reference. Update each SKILL.md's rules section to point to it. Add real file scan paths to each creation skill. Strip duplicated rules from review-code and refactor-to-standards reference files.

**Tech Stack:** Markdown only — no runtime code, no tests, no build.

## Global Constraints

- All skill names keep their `forge:` prefix
- SKILL.md frontmatter (name, description) must not change
- Skill workflow structure (Step 1 gather → Step 2 scan → Step 3 generate → Checklist) stays intact
- BUG fixes from previous commit must not be reverted
- Reference files that contain code templates/examples are kept; only rules portions are removed
- Source repo: `C:\Users\user\Desktop\rsk`
- Target repo: `C:\Users\user\Desktop\forge-skills`

## File Structure

### New files
- `skills/_shared/code-standards.md` — copied from `rsk/docs/CODE_STANDARDS.md`

### Files to delete
- `skills/review-code/references/pr-completeness-rules.md` — 100% rules, no templates
- `skills/refactor-to-standards/references/common-violations.md` — 100% rules, no templates

### Files to modify (SKILL.md scan paths + rules pointers)
- `skills/create-table/SKILL.md`
- `skills/create-form/SKILL.md`
- `skills/create-component/SKILL.md`
- `skills/create-api/SKILL.md`
- `skills/create-page/SKILL.md`
- `skills/create-context/SKILL.md`
- `skills/scaffold-feature/SKILL.md`
- `skills/figma-to-code/SKILL.md`
- `skills/review-code/SKILL.md`
- `skills/refactor-to-standards/SKILL.md`
- `skills/add-icon/SKILL.md`
- `skills/extract-component/SKILL.md`

### Reference files to strip rules from (keep only code templates)
- `skills/review-code/references/architecture-rules.md`
- `skills/review-code/references/code-hygiene-rules.md`
- `skills/review-code/references/correctness-rules.md`
- `skills/review-code/references/import-rules.md`
- `skills/review-code/references/naming-rules.md`
- `skills/review-code/references/reusability-rules.md`
- `skills/review-code/references/styling-rules.md`
- `skills/review-code/references/type-rules.md`

### Reference files to keep as-is (100% templates, no changes needed)
- `skills/review-code/references/component-rules.md`
- `skills/review-code/references/react-patterns-rules.md`
- `skills/review-code/references/runtime-safety-rules.md`
- `skills/review-code/references/api-rules.md`
- `skills/refactor-to-standards/references/transformation-catalog.md`
- All `create-table/references/*`, `create-form/references/*`, `create-component/references/*`, `create-api/references/*`, `figma-to-code/references/*`

---

### Task 1: Create shared code-standards.md

**Files:**
- Create: `skills/_shared/code-standards.md`
- Source: `C:\Users\user\Desktop\rsk\docs\CODE_STANDARDS.md`

**Interfaces:**
- Consumes: rsk's `docs/CODE_STANDARDS.md` (12 categories, 171 lines)
- Produces: `skills/_shared/code-standards.md` — the single shared rules reference all skills will point to

- [ ] **Step 1: Create the _shared directory and copy CODE_STANDARDS.md**

```bash
mkdir -p skills/_shared
```

Copy the content of `C:\Users\user\Desktop\rsk\docs\CODE_STANDARDS.md` into `skills/_shared/code-standards.md`. Add a header note:

```markdown
# Code Standards

> This file is the single source of truth for all project rules. It is copied from the production starter kit (rsk). Individual skills reference this file instead of embedding their own rules.

[... rest of CODE_STANDARDS.md content verbatim ...]
```

- [ ] **Step 2: Verify the file**

Read `skills/_shared/code-standards.md` and confirm it has all 12 sections:
1. Imports, 2. Types, 3. API Layer, 4. React Query Hooks, 5. Components, 6. Conditional Rendering, 7. Forms, 8. Styling & Tokens, 9. File Organization, 10. Component Internal Order, 11. Date/Time & i18n, 12. General

- [ ] **Step 3: Commit**

```bash
git add skills/_shared/code-standards.md
git commit -m "Add shared code-standards.md from rsk as single source of truth"
```

---

### Task 2: Update creation skills — scan paths and rules pointers

**Files:**
- Modify: `skills/create-table/SKILL.md`
- Modify: `skills/create-form/SKILL.md`
- Modify: `skills/create-component/SKILL.md`
- Modify: `skills/create-api/SKILL.md`
- Modify: `skills/create-page/SKILL.md`
- Modify: `skills/create-context/SKILL.md`
- Modify: `skills/scaffold-feature/SKILL.md`

**Interfaces:**
- Consumes: `skills/_shared/code-standards.md` (from Task 1)
- Produces: Updated SKILL.md files with real scan paths and shared rules reference

For each skill below, make two edits:

#### 2a. create-table/SKILL.md

- [ ] **Step 1: Update scan step (lines 20-29)**

Replace the existing scan list with:

```markdown
Before writing code, read:
1. The project's table components: `src/components/tables/data-table/DataTable.tsx`, `DataTableContent.tsx`, `DataTablePagination.tsx`, `DataTableToolbar.tsx`
2. Table filter components in `src/components/tables/data-table-filters/`
3. An existing table page in `src/pages/` for wiring patterns
4. The query hook that fetches list data

See `references/column-types.md` for column definition examples.
See `references/search-pagination.md` for search and pagination patterns.
See `_shared/code-standards.md` for all project rules.
```

- [ ] **Step 2: Replace rules section (lines 68-79)**

Replace the entire Rules section with:

```markdown
## Rules

See `_shared/code-standards.md` for all project rules. Table-specific rules:

- Use existing table components from `src/components/tables/` — don't rebuild
- Debounce search inputs (300ms) before API calls
- Define columns as a plain `const` array for simplicity
- If a column needs hooks (`useDate`, `useTranslation`), call them in the parent page component and pass results down, or use a small cell component — never call hooks inside `cell` renderers directly
- Add `data-slot` attributes to table wrapper elements
- Add `aria-label` to search inputs for accessibility
```

#### 2b. create-form/SKILL.md

- [ ] **Step 3: Update scan step (lines 20-28)**

Replace with:

```markdown
Before writing code, read:
1. The project's form components: `src/components/forms/form-container/FormContainer.tsx`
2. Field components: `form-input/FormInput.tsx`, `form-select/FormSelect.tsx`, `form-checkbox/FormCheckbox.tsx`, `form-date-picker/FormDatePicker.tsx`, `form-textarea/FormTextarea.tsx`
3. An existing form in `src/views/` for wiring patterns
4. Shared submit buttons: `src/components/shared/form-submit-button/FormSubmitButton.tsx`

See `references/form-pattern.md` for the form template.
See `references/validation-patterns.md` for Zod patterns.
See `_shared/code-standards.md` for all project rules.
```

- [ ] **Step 4: Replace rules section (lines 70-78)**

Replace with:

```markdown
## Rules

See `_shared/code-standards.md` for all project rules (sections 5, 7). Form-specific rules:

- All forms use `FormProvider`-based `FormContainer` — no raw `useForm` in pages
- Use existing form field wrappers (`FormInput`, `FormSelect`, etc.) — don't rebuild
- Zod schema in `src/views/<feature>/schemas.ts`
- Guard optional callbacks with `Conditional.If`
- All validation messages use `t()` translation keys
```

#### 2c. create-component/SKILL.md

- [ ] **Step 5: Add scan paths to Step 1 (Audit & Variant Discovery, lines 10-38)**

Add after the existing audit instructions:

```markdown
Scan existing shared components for patterns:
- `src/components/shared/` — look at `PrimeCard`, `CollapsibleCard`, `PrimeDialog` for compound pattern examples
- `src/components/shared/combobox/Combobox.tsx` for CVA + forwardRef pattern
- `src/components/ui/` for base component primitives

See `_shared/code-standards.md` for all project rules (sections 5, 8, 10).
```

#### 2d. create-api/SKILL.md

- [ ] **Step 6: Update scan step (lines 20-29)**

Replace with:

```markdown
Before writing code, read:
1. Endpoint config: `src/api/config/ApiEndpoints.ts`
2. An existing handler in `src/api/handlers/` for the handler pattern
3. Query hooks in `src/lib/hooks/queries/` for the query hook pattern
4. Mutation hooks in `src/lib/hooks/mutations/` for the mutation hook pattern
5. DTO files in `src/types/api/` for naming conventions

See `references/handler-pattern.md` for the handler template.
See `references/query-hook-pattern.md` for the hook template.
See `references/dto-conventions.md` for DTO naming.
See `_shared/code-standards.md` for all project rules (sections 3, 4).
```

#### 2e. create-page/SKILL.md

- [ ] **Step 7: Update scan step (lines 21-28)**

Replace with:

```markdown
Before writing code, read:
1. An existing page in `src/pages/` for page structure
2. Route config in `src/routes/` for lazy loading and guards
3. Layout components in `src/layouts/` for page wrappers

See `references/page-template.md` for the page template.
See `references/routing-patterns.md` for route setup.
See `_shared/code-standards.md` for all project rules (sections 5, 9, 12).
```

- [ ] **Step 8: Replace rules section (lines 65-74)**

Replace with:

```markdown
## Rules

See `_shared/code-standards.md` for all project rules. Page-specific rules:

- Route pages use `React.lazy` for code splitting
- Pages contain logic directly — no wrapper Views for single-use
- Use `pathBuilder` for URL params, not string interpolation
- Add `<main>` landmark wrapper for accessibility
- Use `Conditional.If` for loading/empty/error states
```

#### 2f. create-context/SKILL.md

- [ ] **Step 9: Update scan step (lines 25-31)**

Replace with:

```markdown
Before writing code, read:
1. Existing contexts in `src/lib/contexts/` for the project's context pattern
2. Check if a similar context already exists before creating a new one

See `_shared/code-standards.md` for all project rules (section 10 for hook order).
```

- [ ] **Step 10: Replace rules section (lines 91-98)**

Replace with:

```markdown
## Rules

See `_shared/code-standards.md` for all project rules. Context-specific rules:

- Memoize context value with `useMemo` to prevent unnecessary re-renders
- Provide named actions (e.g., `openDialog()`) instead of raw setters
- Custom hook must throw if used outside Provider
- Use `type` for context value shape, not `interface`
```

#### 2g. scaffold-feature/SKILL.md

- [ ] **Step 11: Update scan step (lines 23-30)**

Replace with:

```markdown
Before writing code, read:
1. An existing feature folder in `src/views/` for structure conventions
2. API layer: `src/api/handlers/`, `src/api/config/ApiEndpoints.ts`
3. Hooks: `src/lib/hooks/queries/`, `src/lib/hooks/mutations/`
4. Pages: `src/pages/`
5. Routes: `src/routes/`
6. Types: `src/types/api/`

See `references/folder-structure.md` for the folder structure.
See `_shared/code-standards.md` for all project rules.
```

- [ ] **Step 12: Replace rules section (lines 58-66)**

Replace with:

```markdown
## Rules

See `_shared/code-standards.md` for all project rules. Scaffold-specific rules:

- Follow the folder structure in `references/folder-structure.md` exactly
- No placeholders or TODOs — produce complete code
- Translation keys must be added to both `en.json` and `ar.json`
- Every layer must be wired: DTOs exported, handler exported, hook wired into page
```

- [ ] **Step 13: Commit all creation skill changes**

```bash
git add skills/create-table/SKILL.md skills/create-form/SKILL.md skills/create-component/SKILL.md skills/create-api/SKILL.md skills/create-page/SKILL.md skills/create-context/SKILL.md skills/scaffold-feature/SKILL.md
git commit -m "Update creation skills with rsk scan paths and shared rules reference"
```

---

### Task 3: Update figma-to-code, add-icon, extract-component skills

**Files:**
- Modify: `skills/figma-to-code/SKILL.md`
- Modify: `skills/add-icon/SKILL.md`
- Modify: `skills/extract-component/SKILL.md`

**Interfaces:**
- Consumes: `skills/_shared/code-standards.md` (from Task 1)
- Produces: Updated SKILL.md files with scan paths and shared rules reference

#### 3a. figma-to-code/SKILL.md

- [ ] **Step 1: Update scan step (lines 26-34)**

Replace with:

```markdown
Read the following project files before generating code:
1. Design tokens: `src/index.css` — all CSS custom properties (`:root` and `.dark`)
2. UI primitives: `src/components/ui/` — base components from shadcn/ui
3. Shared components: `src/components/shared/` — existing reusable components
4. An existing page or view for code style reference

See `references/design-tokens.md` for the token mapping.
See `references/spacing-scale.md` for the spacing table.
See `_shared/code-standards.md` for all project rules (sections 5, 8, 10).
```

#### 3b. add-icon/SKILL.md

- [ ] **Step 2: Add scan instruction before Step 2 (line 17)**

Insert before the "Create Icon Component" step:

```markdown
## Step 1b — Scan Existing Icons

Read `src/assets/icons/index.ts` to understand the barrel export pattern and naming conventions.

See `_shared/code-standards.md` for all project rules (section 5.7).
```

- [ ] **Step 3: Replace rules section (lines 68-75)**

Replace with:

```markdown
## Rules

See `_shared/code-standards.md` for all project rules (section 5.7). Icon-specific rules:

- No inline SVG in components — all icons in `src/assets/icons/`
- Named export from barrel `index.ts`
- Add `data-slot="icon"` to the `<svg>` element
- Decorative icons: `aria-hidden="true"`. Standalone interactive icons: `aria-label`
- Directional icons: use `className="rtl:rotate-180"` when needed
```

#### 3c. extract-component/SKILL.md

- [ ] **Step 4: Add scan instruction to Step 1 (lines 11-15)**

Add to the existing Step 1 instructions:

```markdown
Before extracting, scan existing shared components:
- `src/components/shared/` — check if a similar component already exists
- Look at compound pattern examples (`PrimeCard`, `PrimeDialog`) for the target structure

See `_shared/code-standards.md` for all project rules (sections 5, 8).
```

- [ ] **Step 5: Replace rules section (lines 76-84)**

Replace with:

```markdown
## Rules

See `_shared/code-standards.md` for all project rules. Extraction-specific rules:

- Check `src/components/shared/` before creating — may already exist
- Add `data-slot` to the extracted component's root element
- Ensure all visible strings use `t()` for i18n
- Interactive components must include `aria-label` or `aria-labelledby`
- Use compound pattern if the component has 3+ distinct sections
```

- [ ] **Step 6: Commit**

```bash
git add skills/figma-to-code/SKILL.md skills/add-icon/SKILL.md skills/extract-component/SKILL.md
git commit -m "Update figma-to-code, add-icon, extract-component with rsk scan paths"
```

---

### Task 4: Update review-code and refactor-to-standards skills

**Files:**
- Modify: `skills/review-code/SKILL.md`
- Modify: `skills/refactor-to-standards/SKILL.md`
- Delete: `skills/review-code/references/pr-completeness-rules.md`
- Delete: `skills/refactor-to-standards/references/common-violations.md`

**Interfaces:**
- Consumes: `skills/_shared/code-standards.md` (from Task 1)
- Produces: Updated quality skills pointing to shared standards, dead rule files removed

#### 4a. review-code/SKILL.md

- [ ] **Step 1: Update the Step 2 header area (lines 19-21)**

The current Step 2 embeds all rules inline (lines 19-265). Replace the opening with a pointer to the shared standards and the reference files:

Add after the Step 2 header:

```markdown
Use `_shared/code-standards.md` as the primary rule source (12 categories).
Use the reference files below for detailed wrong/correct code examples:

- `references/api-rules.md` — handler and hook code templates
- `references/component-rules.md` — component pattern examples
- `references/architecture-rules.md` — architecture violation examples
- `references/code-hygiene-rules.md` — hygiene violation examples
- `references/correctness-rules.md` — correctness violation examples
- `references/import-rules.md` — import pattern examples
- `references/naming-rules.md` — naming convention examples
- `references/reusability-rules.md` — reusability pattern examples
- `references/styling-rules.md` — styling violation examples
- `references/type-rules.md` — type pattern examples
- `references/react-patterns-rules.md` — React pattern examples
- `references/runtime-safety-rules.md` — runtime safety examples

For each file under review, check it against all 12 categories in `_shared/code-standards.md`.
```

#### 4b. refactor-to-standards/SKILL.md

- [ ] **Step 2: Update scan step (lines 19-28)**

Replace with:

```markdown
Scan each file in scope against `_shared/code-standards.md` (all 12 categories).
Use `references/transformation-catalog.md` for before/after code examples of common transformations.

Check categories:
1. Imports (aliases, barrels, ordering)
2. Types (type vs interface, DTOs, any)
3. API layer (handlers, queryKeys)
4. React Query hooks (return types, invalidation)
5. Components (pages vs views, compound pattern, size)
6. Conditional rendering (Conditional.If)
7. Forms (FormProvider, field wrappers)
8. Styling (tokens, cn(), scale values)
9. File organization (kebab-case folders, barrels)
10. Component internal order (hooks → state → memo → callbacks → effects → JSX)
11. Date/time & i18n (useDate, useAppTranslation)
12. General (no TODOs, handle* naming, lazy routes)
```

- [ ] **Step 3: Replace rules section (lines 48-54)**

Replace with:

```markdown
## Rules

See `_shared/code-standards.md` for the complete rule set. Refactoring-specific rules:

- Fix violations in priority order: Errors first, then Warnings
- Preserve existing behavior — refactoring must not change functionality
- Run the build after changes to verify no regressions
- Use `references/transformation-catalog.md` for correct before/after patterns
```

- [ ] **Step 4: Delete pure-rules reference files**

```bash
git rm skills/review-code/references/pr-completeness-rules.md
git rm skills/refactor-to-standards/references/common-violations.md
```

- [ ] **Step 5: Commit**

```bash
git add skills/review-code/SKILL.md skills/refactor-to-standards/SKILL.md
git commit -m "Update review-code and refactor-to-standards to use shared code-standards.md

Remove pr-completeness-rules.md and common-violations.md (100% rules, now covered by shared standards)."
```

---

### Task 5: Strip duplicated rules from mixed reference files

**Files:**
- Modify: `skills/review-code/references/architecture-rules.md` — remove "How to detect" blocks and reviewer output fences
- Modify: `skills/review-code/references/code-hygiene-rules.md` — remove Exceptions prose, Commit Hygiene section, "How to check" prose
- Modify: `skills/review-code/references/correctness-rules.md` — remove "How to detect" blocks, reviewer output fences, HTTP method table
- Modify: `skills/review-code/references/import-rules.md` — remove Path Aliases table, Common Violations table
- Modify: `skills/review-code/references/naming-rules.md` — remove File Naming table, Export Naming table, DTO Naming table, Common Violations table
- Modify: `skills/review-code/references/reusability-rules.md` — remove "Before Creating" prose, "When to Use" decision tree, "Compound pattern is MANDATORY" prose, forwardRef table, Component Size prose
- Modify: `skills/review-code/references/styling-rules.md` — remove Theme-Aware Classes table, Project Color Scales table, "Do NOT use" prose, Spacing Scale table, Typography prose, Responsive breakpoints table, Shadows/Border Radius prose
- Modify: `skills/review-code/references/type-rules.md` — remove DTO Naming table, DTO Location prose, "Mark truly optional" prose, Shared API Types prose

**Interfaces:**
- Consumes: Nothing from other tasks
- Produces: Leaner reference files containing only code templates/examples

For each file:

- [ ] **Step 1: Read the file, identify rules sections vs template sections**

Read each file. Remove all:
- Prose-only rule descriptions and detection steps
- Lookup/reference tables that duplicate CODE_STANDARDS.md
- Reviewer output fence blocks (backtick blocks showing `Warning: ...` / `Error: ...`)

Keep all:
- Wrong/correct TypeScript/TSX code blocks
- Code templates with inline comments
- Any code block that shows a concrete before/after transformation

- [ ] **Step 2: Edit each file**

For each of the 8 files, strip the rules portions identified above. Add a one-line header at the top of each:

```markdown
> Rules: see `_shared/code-standards.md`. This file contains code examples only.
```

- [ ] **Step 3: Verify no code templates were accidentally removed**

Read each edited file and confirm every TypeScript/TSX code block from the original is still present.

- [ ] **Step 4: Commit**

```bash
git add skills/review-code/references/architecture-rules.md skills/review-code/references/code-hygiene-rules.md skills/review-code/references/correctness-rules.md skills/review-code/references/import-rules.md skills/review-code/references/naming-rules.md skills/review-code/references/reusability-rules.md skills/review-code/references/styling-rules.md skills/review-code/references/type-rules.md
git commit -m "Strip duplicated rules from review-code reference files, keep code templates only"
```

---

### Task 6: Final verification and summary commit

**Files:**
- All files modified in Tasks 1-5

**Interfaces:**
- Consumes: All previous task outputs
- Produces: Clean, verified branch ready for PR

- [ ] **Step 1: Verify shared reference is reachable**

Grep all SKILL.md files for `_shared/code-standards.md` to confirm all 12 updated skills reference it:

```bash
grep -rl "_shared/code-standards.md" skills/*/SKILL.md | wc -l
```

Expected: 12

- [ ] **Step 2: Verify deleted files are gone**

```bash
ls skills/review-code/references/pr-completeness-rules.md 2>&1
ls skills/refactor-to-standards/references/common-violations.md 2>&1
```

Expected: both return "No such file or directory"

- [ ] **Step 3: Verify all reference files still exist that should**

```bash
ls skills/review-code/references/*.md | wc -l
```

Expected: 12 (was 13, minus 1 deleted)

```bash
ls skills/refactor-to-standards/references/*.md | wc -l
```

Expected: 1 (was 2, minus 1 deleted)

- [ ] **Step 4: Review the full diff**

```bash
git diff --stat HEAD~5
```

Review the summary to ensure no unintended files were changed.
