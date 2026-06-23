---
name: forge:forge
description: "Smart skill router — analyzes the user's request and automatically invokes the right creation and workflow skills in sequence. Use when the user describes what they want to build, create, set up, add, scaffold, connect, wire up, or implement. Single entry point for all building tasks. Invoke as /forge followed by a description of what you need. Examples: 'scaffold a full feature', 'add a new API endpoint', 'build a form', 'convert this Figma design', 'create a data table', 'add an icon from SVG'. Do NOT use this for code review, audits, or refactoring — those use forge:review-code or forge:refactor-to-standards directly."
---

# Forge — Smart Skill Router

Analyze what the user wants to build and automatically invoke the right forge skills in the right order.

**This skill is for building. For quality checks, use forge:review-code. For refactoring, use forge:refactor-to-standards.**

---

## Skill Catalog

You have 18 creation and workflow skills available. Use the trigger signals below to match the user's message. Signals are grouped by register — technical (developer jargon), casual (plain language), and problem-oriented (describing the need, not the solution). Match against ALL three levels.

### scaffold-feature

**What it does:** Full feature vertical slice — DTOs, handler, hooks, page, views, routes.

**Trigger signals:**
- **Technical:** "scaffold", "bootstrap", "vertical slice", "CRUD module", "feature skeleton", "full feature", "module"
- **Casual:** "build everything for", "set up the whole thing", "I need a full [X]", "create all files for", "start [X] from scratch", "new section in the app", "I have a new entity"
- **Problem:** "I need pages, API, forms, the whole thing for [X]", "new entity and need all the pieces"

**Inputs needed:** feature name, entity name, CRUD operations, route path

### create-api

**What it does:** API endpoint + DTOs + handler + React Query hook.

**Trigger signals:**
- **Technical:** "API integration", "endpoint", "handler", "query hook", "mutation hook", "REST endpoint", "API layer", "backend integration"
- **Casual:** "connect to backend", "fetch data from", "call the server", "hook up the API", "wire up", "get data from", "send data to", "talk to the backend"
- **Problem:** "I need to get [X] from the server", "backend has an endpoint for [X] and I need to use it"

**Inputs needed:** entity name, endpoint URL, operations

### create-component

**What it does:** Reusable shared component with CVA variants following compound pattern.

**Trigger signals:**
- **Technical:** "shared component", "reusable component", "compound component", "CVA variants", "component library"
- **Casual:** "build a [card/badge/chip]", "make a UI piece", "new component", "make something I can reuse", "build a [widget]"
- **Problem:** "I need a [X] that I can use in multiple places", "this UI element is needed across pages"

**Inputs needed:** component name, variants

### create-form

**What it does:** Form using React Hook Form + Zod + FormProvider pattern.

**Trigger signals:**
- **Technical:** "form", "Zod schema", "form validation", "React Hook Form", "form fields", "create/edit form"
- **Casual:** "build a form", "add inputs", "user fills in", "data entry for", "sign up form", "edit screen", "input fields", "submission form"
- **Problem:** "users need to enter [data]", "I need to collect info", "need a way to create/edit [X]"

**Inputs needed:** entity name, fields, validation rules

### create-table

**What it does:** Data table using TanStack React Table 8 with search, pagination, sorting.

**Trigger signals:**
- **Technical:** "data table", "TanStack table", "list view", "sortable table", "paginated list", "columns", "grid view"
- **Casual:** "show a list of", "display data in rows", "table with data", "show all [items]", "list of [items]", "rows and columns"
- **Problem:** "I need to show lots of [items]", "users need to browse/search [items]", "display [items] with filtering"

**Inputs needed:** entity name, columns, features (search/sort/pagination)

### create-page

**What it does:** Route-level page with lazy loading + guards.

**Trigger signals:**
- **Technical:** "route", "page component", "lazy loading", "AuthGuard", "layout", "route path", "nested route"
- **Casual:** "new page", "new screen", "add a page for", "dashboard section", "add a place for [X]", "new view"
- **Problem:** "users need to navigate to [X]", "need a new section at /[path]"

**Inputs needed:** page name, layout, guard, route path

### create-context

**What it does:** React Context + Provider + hook.

**Trigger signals:**
- **Technical:** "context", "provider", "global state", "shared state", "React Context", "context hook"
- **Casual:** "share data between components", "global data", "state that everything can access", "pass data around", "need the same data everywhere"
- **Problem:** "multiple components need the same [data]", "I keep passing the same props down through 3 levels"

**Inputs needed:** context name, state shape

### figma-to-code

**What it does:** Figma designs to production-ready React components.

**Trigger signals:**
- **Technical:** "Figma", "design to code", "design spec", "pixel perfect", "design implementation"
- **Casual:** any figma.com URL, "implement this UI", "build what the designer made", "match this mockup", "looks like this design", "designer gave me this"
- **Problem:** "I have a design that needs to become code", "here's the Figma, build it"

**Inputs needed:** Figma URL, target location

### add-motion

**What it does:** Add Motion (Framer Motion) animations — enter/exit, staggered lists, hover/tap/scroll gestures, layout/shared-element transitions, and page transitions. Enforces reduced-motion a11y, GPU-friendly performance, RTL-aware direction, and centralized variants.

**Trigger signals:**
- **Technical:** "Motion", "Framer Motion", "AnimatePresence", "variants", "whileHover", "layout animation", "layoutId", "page transition", "stagger"
- **Casual:** "animate this", "add an animation", "make it slide/fade/scale in", "add a transition", "animate the modal/list", "hover effect", "animate on scroll", "smooth it out"
- **Problem:** "this appears too abruptly", "the list should reveal in sequence", "I want the route change to feel smooth", "needs some life/polish"

**Inputs needed:** target element/component, desired effect (enter/exit, gesture, layout, page)

### extract-component

**What it does:** Extract repeated JSX into reusable component.

**Trigger signals:**
- **Technical:** "extract component", "DRY", "refactor duplication", "shared abstraction", "reduce repetition"
- **Casual:** "this code is repeated", "same thing in multiple places", "too much copy paste", "reuse this block", "I keep writing the same thing"
- **Problem:** "this JSX block appears in 3 files", "two components have the same chunk of code"

**Inputs needed:** source file, which JSX block

### migrate-endpoint

**What it does:** Update existing API endpoint — URL, DTOs, handler, propagate.

**Trigger signals:**
- **Technical:** "migrate endpoint", "DTO update", "endpoint URL changed", "response shape changed", "API contract changed"
- **Casual:** "backend changed", "API is different now", "endpoint moved", "server response changed", "update the API call", "backend team changed something"
- **Problem:** "the [X] endpoint broke because backend changed it", "API response doesn't match our types anymore"

**Inputs needed:** which endpoint, what changed

### add-icon

**What it does:** SVG markup to icon component.

**Trigger signals:**
- **Technical:** "icon component", "SVG to component", "custom icon", "icon asset", "SVG markup"
- **Casual:** "add icon", "new icon", "I have an SVG", "put an icon", "need a [X] icon"
- **Problem:** "I need an icon that doesn't exist in Lucide", "designer gave me a custom SVG"

**Inputs needed:** SVG source

### add-translations

**What it does:** Add i18n keys to both locale files.

**Trigger signals:**
- **Technical:** "i18n keys", "translation keys", "locale entries", "internationalization", "localization"
- **Casual:** "add translations", "translate this", "add labels", "text in Arabic", "need both languages", "add the Arabic version"
- **Problem:** "new UI text needs to be in both languages", "I added a screen and it needs translations"

**Inputs needed:** keys and values

### i18n-sync

**What it does:** Audit/sync locale files for missing keys and mismatches.

**Trigger signals:**
- **Technical:** "sync locales", "translation audit", "missing keys", "locale diff", "orphaned keys"
- **Casual:** "check translations", "are all translations there", "find missing translations", "translations out of sync"
- **Problem:** "some text might not be translated", "en.json and ar.json might be out of sync"

**Inputs needed:** none

### git-workflow

**What it does:** Branch naming, commits, PR creation.

**Trigger signals:**
- **Technical:** "branch", "commit", "pull request", "PR", "push", "feature branch", "merge request"
- **Casual:** "save my work", "create a branch", "push changes", "open a PR", "start working on ticket [X]", "ready to submit"
- **Problem:** "I need to commit and push this", "how do I name this branch", "ready to open a PR"

**Inputs needed:** ticket number

### changelog

**What it does:** Generate changelog from git history.

**Trigger signals:**
- **Technical:** "changelog", "release notes", "commit summary", "version history", "release log"
- **Casual:** "what changed", "summarize changes", "list of changes", "what did we do since last release"
- **Problem:** "need to tell the team what's in this release"

**Inputs needed:** date range or tag

### document-component

**What it does:** Generate component usage docs.

**Trigger signals:**
- **Technical:** "component docs", "API documentation", "usage guide", "props documentation", "JSDoc"
- **Casual:** "write docs for", "how to use this component", "document this", "usage examples", "explain how to use"
- **Problem:** "someone new needs to know how to use this component", "there's no documentation for [X]"

**Inputs needed:** component path

### debug-build

**What it does:** Diagnose/fix TypeScript and Vite build failures.

**Trigger signals:**
- **Technical:** "build error", "type error", "compilation failure", "tsc error", "Vite build failure"
- **Casual:** "build is broken", "it won't compile", "red errors", "build fails", "can't build", "everything is red", "npm run build doesn't work"
- **Problem:** "the project won't build", "getting errors when I run build", "CI is failing on build step"

**Inputs needed:** error message

---

## Routing Intelligence

### Subsumption Rules

When a higher-level skill already includes the work of a lower-level skill, remove the lower-level skill from the plan.

| If selected | Remove | Reason |
|---|---|---|
| scaffold-feature | create-api | scaffold-feature generates the full API layer |
| scaffold-feature | create-page | scaffold-feature generates the page and route |

Skills **not** subsumed by scaffold-feature (always keep if selected): create-form, create-table, create-component, create-context, add-icon, add-translations.

### Execution Order

Execute selected skills in layer order. Within the same layer, order does not matter.

| Layer | Name | Skills |
|---|---|---|
| 0 | Standalone | debug-build, i18n-sync |
| 1 | Infrastructure | create-api, create-context, migrate-endpoint |
| 2 | Structure | scaffold-feature, create-page |
| 3 | UI | create-component, create-form, create-table, figma-to-code, extract-component, add-motion |
| 4 | Assets | add-icon, add-translations |
| 5 | Workflow | git-workflow, changelog, document-component |

### Auto-Add Rules

These skills are automatically appended or prepended based on context.

| Condition | Action | Skill |
|---|---|---|
| Any UI skill selected (create-component, create-form, create-table, create-page, figma-to-code) — but NOT scaffold-feature (it handles translations internally) | Append | add-translations |
| Message contains a figma.com URL | Prepend | figma-to-code |
| Message contains a ticket number pattern (e.g., PROJ-123, #123) | Append | git-workflow |

### Conflict Resolution

When the request is ambiguous, ask **one** clarifying question before proceeding.

| Ambiguity | What to ask |
|---|---|
| No trigger signals match at all | "Can you describe what you're building? I'll pick the right tools." |
| "Create a component" — shared or view-specific? | "Is this a reusable shared component (used across features), or a view component for a specific feature page?" |
| "Add an API" — standalone or part of a full feature? | "Do you need just the API pipeline (endpoint, DTOs, handler, hook), or a full feature with page and UI too?" |
| "Build a form" — standalone or part of a feature? | "Is this form for an existing feature, or should I scaffold the full feature first?" |
| Matched both `scaffold-feature` AND `create-api` with no subsumption context | "It sounds like you need a full feature. Should I scaffold everything (page, API, hooks, routes), or just the API layer?" |
| Matched `debug-build` AND creation skills | "Are you trying to fix a broken build, or build something new? I'll handle one at a time." |

---

## Workflow

### Step 1 — Analyze Message

Read the user's message and extract:
1. **Intent signals** — verbs and nouns that match trigger signals in the catalog above
2. **Shared inputs** — check the **Inputs needed** field for each matched skill, then extract those values from the message: entity names, endpoint URLs, Figma URLs, ticket numbers, CRUD operations, field/column lists, route paths
3. **Explicit skill mentions** — if the user names a specific skill (e.g., "use create-api"), include it directly

### Step 2 — Select and Order Skills

1. Build a **candidate list** by matching intent signals to skills in the catalog
2. Apply **subsumption rules** — remove skills that are already covered by a higher-level skill
3. Apply **auto-add rules** — append or prepend skills based on detected context
4. Check for **standalone skills** (Layer 0) — if debug-build or i18n-sync is selected, run it alone and stop
5. **Sort** the final list by execution layer (0 → 5)

### Step 3 — Handle Ambiguity

If the candidate list is empty or contains a conflict from the Conflict Resolution table:
- Ask **one** clarifying question
- Wait for the user's answer before proceeding
- Do not ask multiple questions — pick the most impactful ambiguity

### Step 4 — Present Plan

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

### Step 5 — Execute Sequentially

For each skill in the plan:
1. Invoke it via the `Skill` tool: `Skill("forge:<skill-name>", args: "<shared context>")`
2. Include the shared inputs as the skill's arguments so the skill doesn't re-ask for information the user already provided
3. Let the skill run to completion before invoking the next one
4. Carry forward any outputs that downstream skills need (e.g., DTO names created by create-api are needed by create-form)

**Input forwarding format**: Pass the shared context as a natural-language string in the `args` parameter. Example:
```
Skill("forge:create-table", args: "Entity: Order. Columns: name, status, total, date. Features: search, pagination, sorting. This table is part of the orders feature at /dashboard/orders.")
```

### Step 6 — Summary

After all skills complete:
1. Recap what was created — list all files and artifacts
2. Note any manual steps remaining
3. Suggest running `forge:review-code` on the generated code to verify standards compliance

---

## Excluded Skills

These skills are **not** dispatched by the router. They are invoked directly or run as part of other skills.

| Skill | How to invoke |
|---|---|
| review-code | Invoke directly as `/forge:review-code` |
| audit-a11y | Run automatically by review-code |
| audit-dark-mode | Run automatically by review-code |
| audit-rtl | Run automatically by review-code |
| audit-imports | Run automatically by review-code |
| refactor-to-standards | Invoke directly as `/forge:refactor-to-standards` |

---

## Checklist

- [ ] User's intent was correctly mapped to one or more skills
- [ ] Subsumption rules were applied — no redundant skills in the plan
- [ ] Auto-add rules were applied — translations added for UI skills, figma-to-code prepended for Figma URLs
- [ ] Execution order follows the layer table (0 → 5)
- [ ] Shared context (entity name, endpoint, fields) was passed to all skills that need it
- [ ] Each skill was invoked sequentially, not in parallel
- [ ] Outputs from earlier skills were carried forward to later skills
- [ ] Summary lists all created files and suggests forge:review-code
