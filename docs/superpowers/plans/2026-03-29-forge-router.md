# Forge Router Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a single smart router skill (`forge:forge`) that analyzes the user's request and dispatches the right creation/workflow skills automatically.

**Architecture:** One SKILL.md file containing: YAML frontmatter, a skill catalog (17 entries with trigger signals), routing intelligence rules (subsumption, execution order, auto-add, conflict resolution), and a 6-step workflow. No reference files needed — everything is inline.

**Tech Stack:** Markdown only (content-only repo, no runtime code)

**Spec:** `docs/superpowers/specs/2026-03-29-forge-router-design.md`

---

### Task 1: Create skill directory and SKILL.md with frontmatter + intro

**Files:**
- Create: `skills/forge/SKILL.md`

- [ ] **Step 1: Create the directory**

```bash
mkdir -p skills/forge
```

- [ ] **Step 2: Write frontmatter and intro section**

Write `skills/forge/SKILL.md` with this exact content:

```markdown
---
name: forge:forge
description: "Smart skill router — analyzes the user's request and automatically invokes the right creation and workflow skills in sequence. Use when the user describes what they want to build, create, set up, add, scaffold, connect, wire up, or implement. Single entry point for all building tasks. Invoke as /forge followed by a description of what you need. Examples: 'scaffold a full feature', 'add a new API endpoint', 'build a form', 'convert this Figma design', 'create a data table', 'add an icon from SVG'. Do NOT use this for code review, audits, or refactoring — those use forge:review-code or forge:refactor-to-standards directly."
---

# Forge — Smart Skill Router

Analyze what the user wants to build and automatically invoke the right forge skills in the right order.

**This skill is for building.** For quality checks, use `forge:review-code`. For refactoring, use `forge:refactor-to-standards`.
```

- [ ] **Step 3: Verify the file exists and frontmatter is correct**

```bash
head -6 skills/forge/SKILL.md
```

Expected: YAML frontmatter with `name: forge:forge` and a description.

- [ ] **Step 4: Commit**

```bash
git add skills/forge/SKILL.md
git commit -m "feat: create forge router skill with frontmatter"
```

---

### Task 2: Write the Skill Catalog section

**Files:**
- Modify: `skills/forge/SKILL.md` (append after intro)

- [ ] **Step 1: Append the catalog section**

Append the following to `skills/forge/SKILL.md` after the intro paragraph:

```markdown

---

## Skill Catalog

You have 17 creation and workflow skills available. Use the trigger signals below to match the user's message. Signals are grouped by register — technical (developer jargon), casual (plain language), and problem-oriented (describing the need, not the solution). Match against ALL three levels.

### scaffold-feature
**What it does:** Generates a complete feature vertical slice — DTOs, handler, hooks, page, views, routes.
**Trigger signals:**
- Technical: "scaffold", "bootstrap", "vertical slice", "CRUD module", "feature skeleton", "full feature", "module"
- Casual: "build everything for", "set up the whole thing", "I need a full [X]", "create all files for", "start [X] from scratch", "new section in the app", "I have a new entity"
- Problem: "I need pages, API, forms, the whole thing for [X]", "new entity and need all the pieces"
**Inputs needed:** feature name, entity name, CRUD operations, route path

### create-api
**What it does:** Creates an API endpoint, DTOs, handler, and React Query hook.
**Trigger signals:**
- Technical: "API integration", "endpoint", "handler", "query hook", "mutation hook", "REST endpoint", "API layer", "backend integration"
- Casual: "connect to backend", "fetch data from", "call the server", "hook up the API", "wire up", "get data from", "send data to", "talk to the backend"
- Problem: "I need to get [X] from the server", "backend has an endpoint for [X] and I need to use it"
**Inputs needed:** entity name, endpoint URL, operations

### create-component
**What it does:** Creates a reusable shared component with CVA variants following compound pattern.
**Trigger signals:**
- Technical: "shared component", "reusable component", "compound component", "CVA variants", "component library"
- Casual: "build a [card/badge/chip]", "make a UI piece", "new component", "make something I can reuse", "build a [widget]"
- Problem: "I need a [X] that I can use in multiple places", "this UI element is needed across pages"
**Inputs needed:** component name, variants

### create-form
**What it does:** Creates a form using React Hook Form + Zod + FormProvider pattern.
**Trigger signals:**
- Technical: "form", "Zod schema", "form validation", "React Hook Form", "form fields", "create/edit form"
- Casual: "build a form", "add inputs", "user fills in", "data entry for", "sign up form", "edit screen", "input fields", "submission form"
- Problem: "users need to enter [data]", "I need to collect info", "need a way to create/edit [X]"
**Inputs needed:** entity name, fields, validation rules

### create-table
**What it does:** Creates a data table using TanStack React Table 8 with search, pagination, and sorting.
**Trigger signals:**
- Technical: "data table", "TanStack table", "list view", "sortable table", "paginated list", "columns", "grid view"
- Casual: "show a list of", "display data in rows", "table with data", "show all [items]", "list of [items]", "rows and columns"
- Problem: "I need to show lots of [items]", "users need to browse/search [items]", "display [items] with filtering"
**Inputs needed:** entity name, columns, features (search/sort/pagination)

### create-page
**What it does:** Creates a route-level page component with lazy loading and layout guards.
**Trigger signals:**
- Technical: "route", "page component", "lazy loading", "AuthGuard", "layout", "route path", "nested route"
- Casual: "new page", "new screen", "add a page for", "dashboard section", "add a place for [X]", "new view"
- Problem: "users need to navigate to [X]", "need a new section at /[path]"
**Inputs needed:** page name, layout, guard, route path

### create-context
**What it does:** Creates React Context with Provider and custom hook.
**Trigger signals:**
- Technical: "context", "provider", "global state", "shared state", "React Context", "context hook"
- Casual: "share data between components", "global data", "state that everything can access", "pass data around", "need the same data everywhere"
- Problem: "multiple components need the same [data]", "I keep passing the same props down through 3 levels"
**Inputs needed:** context name, state shape

### figma-to-code
**What it does:** Converts Figma designs into production-ready React components.
**Trigger signals:**
- Technical: "Figma", "design to code", "design spec", "pixel perfect", "design implementation"
- Casual: any `figma.com` URL, "implement this UI", "build what the designer made", "match this mockup", "looks like this design", "designer gave me this"
- Problem: "I have a design that needs to become code", "here's the Figma, build it"
**Inputs needed:** Figma URL, target location

### extract-component
**What it does:** Extracts repeated JSX into a reusable component.
**Trigger signals:**
- Technical: "extract component", "DRY", "refactor duplication", "shared abstraction", "reduce repetition"
- Casual: "this code is repeated", "same thing in multiple places", "too much copy paste", "reuse this block", "I keep writing the same thing"
- Problem: "this JSX block appears in 3 files", "two components have the same chunk of code"
**Inputs needed:** source file, which JSX block

### migrate-endpoint
**What it does:** Updates an existing API endpoint — URL, DTOs, handler, propagates through hooks and components.
**Trigger signals:**
- Technical: "migrate endpoint", "DTO update", "endpoint URL changed", "response shape changed", "API contract changed"
- Casual: "backend changed", "API is different now", "endpoint moved", "server response changed", "update the API call", "backend team changed something"
- Problem: "the [X] endpoint broke because backend changed it", "API response doesn't match our types anymore"
**Inputs needed:** which endpoint, what changed

### add-icon
**What it does:** Converts SVG markup into a properly exported icon component.
**Trigger signals:**
- Technical: "icon component", "SVG to component", "custom icon", "icon asset", "SVG markup"
- Casual: "add icon", "new icon", "I have an SVG", "put an icon", "need a [X] icon"
- Problem: "I need an icon that doesn't exist in Lucide", "designer gave me a custom SVG"
**Inputs needed:** SVG source

### add-translations
**What it does:** Adds new translation keys to both en.json and ar.json locale files.
**Trigger signals:**
- Technical: "i18n keys", "translation keys", "locale entries", "internationalization", "localization"
- Casual: "add translations", "translate this", "add labels", "text in Arabic", "need both languages", "add the Arabic version"
- Problem: "new UI text needs to be in both languages", "I added a screen and it needs translations"
**Inputs needed:** keys and values

### i18n-sync
**What it does:** Audits locale files for missing keys, untranslated values, and structural mismatches.
**Trigger signals:**
- Technical: "sync locales", "translation audit", "missing keys", "locale diff", "orphaned keys"
- Casual: "check translations", "are all translations there", "find missing translations", "translations out of sync"
- Problem: "some text might not be translated", "en.json and ar.json might be out of sync"
**Inputs needed:** none

### git-workflow
**What it does:** Follows structured git workflow — branch naming, commit messages, PR creation.
**Trigger signals:**
- Technical: "branch", "commit", "pull request", "PR", "push", "feature branch", "merge request"
- Casual: "save my work", "create a branch", "push changes", "open a PR", "start working on ticket [X]", "ready to submit"
- Problem: "I need to commit and push this", "how do I name this branch", "ready to open a PR"
**Inputs needed:** ticket number

### changelog
**What it does:** Generates a changelog from git history, grouped by type and linked to tickets.
**Trigger signals:**
- Technical: "changelog", "release notes", "commit summary", "version history", "release log"
- Casual: "what changed", "summarize changes", "list of changes", "what did we do since last release"
- Problem: "need to tell the team what's in this release"
**Inputs needed:** date range or tag

### document-component
**What it does:** Generates usage documentation for a component — props, variants, examples, guidelines.
**Trigger signals:**
- Technical: "component docs", "API documentation", "usage guide", "props documentation", "JSDoc"
- Casual: "write docs for", "how to use this component", "document this", "usage examples", "explain how to use"
- Problem: "someone new needs to know how to use this component", "there's no documentation for [X]"
**Inputs needed:** component path

### debug-build
**What it does:** Diagnoses and fixes TypeScript and Vite build failures systematically.
**Trigger signals:**
- Technical: "build error", "type error", "compilation failure", "tsc error", "Vite build failure"
- Casual: "build is broken", "it won't compile", "red errors", "build fails", "can't build", "everything is red", "npm run build doesn't work"
- Problem: "the project won't build", "getting errors when I run build", "CI is failing on build step"
**Inputs needed:** error message
```

- [ ] **Step 2: Verify catalog has all 17 skills**

```bash
grep -c "^### " skills/forge/SKILL.md
```

Expected: `17`

- [ ] **Step 3: Commit**

```bash
git add skills/forge/SKILL.md
git commit -m "feat: add skill catalog with 17 entries and trigger signals"
```

---

### Task 3: Write the Routing Intelligence section

**Files:**
- Modify: `skills/forge/SKILL.md` (append after catalog)

- [ ] **Step 1: Append routing intelligence section**

Append the following to `skills/forge/SKILL.md` after the catalog:

```markdown

---

## Routing Intelligence

Use these rules to turn the matched skills into a correct execution plan.

### Subsumption Rules — Avoid Redundancy

Some skills already do what other skills do. When a broader skill is selected, remove the narrower skills it covers:

| If selected | Remove from list | Why |
|-------------|-----------------|-----|
| `scaffold-feature` | `create-api`, `create-page` | Scaffold already creates DTOs, handler, hooks, page, and routes |

Skills NOT subsumed by `scaffold-feature` (always keep if matched): `create-form`, `create-table`, `create-component`, `add-translations`, `add-icon`.

### Execution Order — Dependency Layers

When multiple skills are selected, run them in this order. Skills within the same layer can run in any order.

| Layer | Skills | Why this order |
|-------|--------|---------------|
| 0 - Standalone | `debug-build`, `i18n-sync` | Always run alone. If matched, do NOT combine with other skills. |
| 1 - Infrastructure | `create-api`, `create-context`, `migrate-endpoint` | These create the data layer. No UI dependency. |
| 2 - Structure | `scaffold-feature`, `create-page` | These create the page shell. Need API/context from Layer 1. |
| 3 - UI | `create-component`, `create-form`, `create-table`, `figma-to-code`, `extract-component` | These fill in the UI. Need the page from Layer 2. |
| 4 - Assets | `add-icon`, `add-translations` | These add supporting assets. Need UI from Layer 3 to know what's needed. |
| 5 - Workflow | `git-workflow`, `changelog`, `document-component` | These run after building is done. |

### Auto-Add Rules

Automatically append skills when these conditions are detected — the user doesn't need to ask for them:

| Condition | Action | Rationale |
|-----------|--------|-----------|
| Any skill from Layer 2 or Layer 3 is selected (creates UI) | Append `add-translations` to Layer 4 | New UI always needs i18n keys |
| Message contains a `figma.com` URL | Prepend `figma-to-code` to Layer 3 | Figma design should be converted before building on top of it |
| Message contains a ticket number pattern (e.g., `DM-210`, `PROJ-45`) | Append `git-workflow` to Layer 5 | Ticket context means they want proper branch/commit workflow |

### Conflict Resolution — When to Ask

If the message is ambiguous or matches conflicting paths, ask **one** clarifying question before proceeding. Do NOT guess.

| Ambiguity | What to ask |
|-----------|-------------|
| No trigger signals match at all | "Can you describe what you're building? I'll pick the right tools." |
| "Create a component" — shared or view-specific? | "Is this a reusable shared component (used across features), or a view component for a specific feature page?" |
| "Add an API" — standalone or part of a full feature? | "Do you need just the API pipeline (endpoint, DTOs, handler, hook), or a full feature with page and UI too?" |
| "Build a form" — standalone or part of a feature? | "Is this form for an existing feature, or should I scaffold the full feature first?" |
| Matched both `scaffold-feature` AND `create-api` with no subsumption context | "It sounds like you need a full feature. Should I scaffold everything (page, API, hooks, routes), or just the API layer?" |
| Matched `debug-build` AND creation skills | "Are you trying to fix a broken build, or build something new? I'll handle one at a time." |
```

- [ ] **Step 2: Verify the section is well-formed**

Read the file and verify all tables render correctly and no broken markdown.

- [ ] **Step 3: Commit**

```bash
git add skills/forge/SKILL.md
git commit -m "feat: add routing intelligence rules (subsumption, ordering, auto-add, conflicts)"
```

---

### Task 4: Write the 6-step Workflow section

**Files:**
- Modify: `skills/forge/SKILL.md` (append after routing intelligence)

- [ ] **Step 1: Append workflow section**

Append the following to `skills/forge/SKILL.md`:

```markdown

---

## Workflow

Follow these 6 steps every time this skill is invoked.

### Step 1 — Analyze the Message

Read the user's message after `/forge` and extract:

1. **Intent signals**: Scan the message against every skill's trigger signals (technical + casual + problem-oriented). A skill is a candidate if ANY signal matches.
2. **Shared inputs**: Extract any information that multiple skills will need:
   - Feature/entity name (e.g., "orders" → feature: orders, entity: Order)
   - Endpoint URLs or patterns
   - Figma URLs
   - Ticket numbers (DM-xxx, PROJ-xxx, etc.)
   - CRUD operations mentioned (list, create, update, delete, detail)
   - Specific fields or columns mentioned
3. **Explicit skill mentions**: If the user names a skill directly (e.g., "use create-table"), always include it regardless of other signals.

### Step 2 — Select and Order Skills

1. Build the **candidate list** from Step 1 matches
2. Apply **subsumption rules** — remove skills already covered by a broader selection
3. Apply **auto-add rules** — append `add-translations`, prepend `figma-to-code`, append `git-workflow` when conditions are met
4. Apply **standalone rules** — if `debug-build` or `i18n-sync` matched, run it alone and discard other candidates
5. **Sort by execution layer** (0 → 1 → 2 → 3 → 4 → 5)

### Step 3 — Handle Ambiguity

If after Step 2:
- The candidate list is **empty** → ask a clarifying question (see Conflict Resolution table)
- The candidate list has **conflicting paths** → ask a clarifying question
- Otherwise → proceed to Step 4

Ask only **one** question. Do not ask multiple questions at once.

### Step 4 — Present the Plan

Show the user exactly what will run before executing anything:

```
Based on your request, I'll run these skills in order:

1. forge:scaffold-feature — create the full orders feature
2. forge:create-table — add the orders data table
3. forge:create-form — add create/edit order forms
4. forge:add-translations — add i18n keys for all new UI

Shared context I'll pass to each:
- Feature: orders
- Entity: Order
- CRUD: list, create, update, delete

Proceed? (y/n)
```

**Wait for user confirmation.** Do not invoke any skill until the user says yes.

If the user says no or wants changes, adjust the plan and re-present.

### Step 5 — Execute Skills Sequentially

For each skill in the plan:
1. Invoke it via the `Skill` tool: `Skill("forge:<skill-name>", args: "<shared context>")`
2. Include the shared inputs as the skill's arguments so the skill doesn't re-ask for information the user already provided
3. Let the skill run to completion
4. Move to the next skill

**Input forwarding format**: Pass the shared context as a natural-language string in the `args` parameter. Example:
```
Skill("forge:create-table", args: "Entity: Order. Columns: name, status, total, date. Features: search, pagination, sorting. This table is part of the orders feature at /dashboard/orders.")
```

### Step 6 — Summary

After all skills complete, show a brief recap:

```
Done. Here's what was created:

- scaffold-feature: DTOs, handler, hooks, page, routes for orders ✓
- create-table: OrdersTable with search + pagination ✓
- create-form: OrderForm with Zod validation ✓
- add-translations: 24 keys added to en.json and ar.json ✓

Next steps:
- Run forge:review-code to verify everything follows standards
- Test the feature in the browser
```

Always suggest `forge:review-code` as a follow-up.
```

- [ ] **Step 2: Verify all 6 steps are present**

```bash
grep -c "^### Step" skills/forge/SKILL.md
```

Expected: `6`

- [ ] **Step 3: Commit**

```bash
git add skills/forge/SKILL.md
git commit -m "feat: add 6-step workflow to forge router skill"
```

---

### Task 5: Write the Checklist and Excluded Skills section

**Files:**
- Modify: `skills/forge/SKILL.md` (append at end)

- [ ] **Step 1: Append checklist and excluded skills sections**

Append the following to `skills/forge/SKILL.md`:

```markdown

---

## Excluded Skills

These 6 skills are **NOT** dispatched by the forge router. They have their own entry points:

| Skill | How to invoke | Why excluded |
|-------|--------------|--------------|
| `review-code` | `/forge:review-code` | Quality gate, not creation |
| `audit-a11y` | Invoked automatically by `review-code` | Sub-skill of review |
| `audit-dark-mode` | Invoked automatically by `review-code` | Sub-skill of review |
| `audit-rtl` | Invoked automatically by `review-code` | Sub-skill of review |
| `audit-imports` | Invoked automatically by `review-code` | Sub-skill of review |
| `refactor-to-standards` | `/forge:refactor-to-standards` | Modifies existing code, not creation |

If the user's message sounds like a review, audit, or refactoring task, tell them:
> "That sounds like a quality/review task. Use `/forge:review-code` for reviews and audits, or `/forge:refactor-to-standards` for refactoring."

## Checklist

Verify before executing:

- [ ] At least one skill was matched from the catalog
- [ ] Subsumption rules applied (no redundant skills in the plan)
- [ ] Execution order follows the layer table (Infrastructure → Structure → UI → Assets → Workflow)
- [ ] Auto-add rules checked (translations for UI, figma-to-code for URLs, git-workflow for tickets)
- [ ] Standalone skills (debug-build, i18n-sync) are not mixed with other skills
- [ ] Shared inputs extracted and will be forwarded to each skill
- [ ] Plan was presented to the user and they confirmed before execution started
- [ ] Each skill invocation includes the shared context in the `args` parameter
```

- [ ] **Step 2: Verify the complete file structure**

Read the full file and verify it has these sections in order:
1. Frontmatter (name, description)
2. H1 title + intro
3. Skill Catalog (17 entries)
4. Routing Intelligence (subsumption, execution order, auto-add, conflict resolution)
5. Workflow (6 steps)
6. Excluded Skills (table)
7. Checklist

- [ ] **Step 3: Commit**

```bash
git add skills/forge/SKILL.md
git commit -m "feat: add excluded skills section and verification checklist"
```

---

### Task 6: Final review and single squashed commit

**Files:**
- Review: `skills/forge/SKILL.md`

- [ ] **Step 1: Read the complete SKILL.md and verify against the spec**

Read `skills/forge/SKILL.md` from top to bottom. Cross-reference with `docs/superpowers/specs/2026-03-29-forge-router-design.md` and verify:

1. All 17 skills are in the catalog with trigger signals
2. Subsumption rules match the spec
3. Execution order layers match the spec
4. Auto-add rules match the spec (3 rules)
5. Conflict resolution table has all ambiguity cases
6. Workflow has all 6 steps
7. Excluded skills table lists all 6
8. Frontmatter description is comprehensive enough to trigger on relevant messages

- [ ] **Step 2: Verify file line count is reasonable**

```bash
wc -l skills/forge/SKILL.md
```

Expected: approximately 250-350 lines (similar in scope to review-code's 410 lines but slightly shorter since it has no reference files).

- [ ] **Step 3: Final commit if any fixes were needed**

```bash
git add skills/forge/SKILL.md
git commit -m "feat: forge router skill — smart dispatcher for 17 creation/workflow skills"
```
