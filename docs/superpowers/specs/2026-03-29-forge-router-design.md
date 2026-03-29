# Forge Router Skill Design

A single entry-point skill (`forge:forge`, invoked as `/forge`) that analyzes the user's message and automatically dispatches the right creation and workflow skills in sequence.

## Problem

The forge-skills collection has 23 skills. Team members must know which skill to invoke for each task. This creates friction — they either invoke the wrong one, forget one, or don't know the skill exists.

## Solution

One router skill that:
1. Reads the user's natural-language request
2. Matches it against a catalog of 17 creation/workflow skills
3. Selects the right combination, orders them by dependency, and runs them sequentially

Quality skills (review-code, audits, refactor-to-standards) are excluded — they're handled by `forge:review-code`.

## Skill Identity

- **Name**: `forge:forge`
- **Location**: `skills/forge/SKILL.md`
- **Invocation**: `/forge <describe what you need>`
- **Scope**: Creation and workflow skills only (17 of 23)

## Skill Catalog

The router contains a catalog of 17 skills. Each entry has: name, purpose, trigger signals (technical + casual + problem-oriented), and required inputs.

### Skills and Trigger Signals

**scaffold-feature** — Full feature vertical slice (DTOs, handler, hooks, page, views, routes)
- Technical: "scaffold", "bootstrap", "vertical slice", "CRUD module", "feature skeleton", "full feature", "module"
- Casual: "build everything for", "set up the whole thing", "I need a full [X]", "create all files for", "start [X] from scratch", "new section in the app", "I have a new entity"
- Problem: "I need pages, API, forms, the whole thing for [X]", "new entity and need all the pieces"
- Inputs: feature name, entity name, CRUD operations, route path

**create-api** — API endpoint + DTOs + handler + React Query hook
- Technical: "API integration", "endpoint", "handler", "query hook", "mutation hook", "REST endpoint", "API layer", "backend integration"
- Casual: "connect to backend", "fetch data from", "call the server", "hook up the API", "wire up", "get data from", "send data to", "talk to the backend"
- Problem: "I need to get [X] from the server", "backend has an endpoint for [X] and I need to use it"
- Inputs: entity name, endpoint URL, operations

**create-component** — Reusable shared component with CVA variants
- Technical: "shared component", "reusable component", "compound component", "CVA variants", "component library"
- Casual: "build a [card/badge/chip]", "make a UI piece", "new component", "make something I can reuse", "build a [widget]"
- Problem: "I need a [X] that I can use in multiple places", "this UI element is needed across pages"
- Inputs: component name, variants

**create-form** — React Hook Form + Zod form
- Technical: "form", "Zod schema", "form validation", "React Hook Form", "form fields", "create/edit form"
- Casual: "build a form", "add inputs", "user fills in", "data entry for", "sign up form", "edit screen", "input fields", "submission form"
- Problem: "users need to enter [data]", "I need to collect info", "need a way to create/edit [X]"
- Inputs: entity name, fields, validation rules

**create-table** — TanStack table with search/pagination/sorting
- Technical: "data table", "TanStack table", "list view", "sortable table", "paginated list", "columns", "grid view"
- Casual: "show a list of", "display data in rows", "table with data", "show all [items]", "list of [items]", "rows and columns"
- Problem: "I need to show lots of [items]", "users need to browse/search [items]", "display [items] with filtering"
- Inputs: entity name, columns, features (search/sort/pagination)

**create-page** — Route-level page with lazy loading + guards
- Technical: "route", "page component", "lazy loading", "AuthGuard", "layout", "route path", "nested route"
- Casual: "new page", "new screen", "add a page for", "dashboard section", "add a place for [X]", "new view"
- Problem: "users need to navigate to [X]", "need a new section at /[path]"
- Inputs: page name, layout, guard, route path

**create-context** — React Context + Provider + hook
- Technical: "context", "provider", "global state", "shared state", "React Context", "context hook"
- Casual: "share data between components", "global data", "state that everything can access", "pass data around", "need the same data everywhere"
- Problem: "multiple components need the same [data]", "I keep passing the same props down through 3 levels"
- Inputs: context name, state shape

**figma-to-code** — Figma design to production component
- Technical: "Figma", "design to code", "design spec", "pixel perfect", "design implementation"
- Casual: any figma.com URL, "implement this UI", "build what the designer made", "match this mockup", "looks like this design", "designer gave me this"
- Problem: "I have a design that needs to become code", "here's the Figma, build it"
- Inputs: Figma URL, target location

**extract-component** — Extract repeated JSX into reusable component
- Technical: "extract component", "DRY", "refactor duplication", "shared abstraction", "reduce repetition"
- Casual: "this code is repeated", "same thing in multiple places", "too much copy paste", "reuse this block", "I keep writing the same thing"
- Problem: "this JSX block appears in 3 files", "two components have the same chunk of code"
- Inputs: source file, which JSX block

**migrate-endpoint** — Update existing API integration
- Technical: "migrate endpoint", "DTO update", "endpoint URL changed", "response shape changed", "API contract changed"
- Casual: "backend changed", "API is different now", "endpoint moved", "server response changed", "update the API call", "backend team changed something"
- Problem: "the [X] endpoint broke because backend changed it", "API response doesn't match our types anymore"
- Inputs: which endpoint, what changed

**add-icon** — SVG to icon component
- Technical: "icon component", "SVG to component", "custom icon", "icon asset", "SVG markup"
- Casual: "add icon", "new icon", "I have an SVG", "put an icon", "need a [X] icon"
- Problem: "I need an icon that doesn't exist in Lucide", "designer gave me a custom SVG"
- Inputs: SVG source

**add-translations** — Add new i18n keys to both locales
- Technical: "i18n keys", "translation keys", "locale entries", "internationalization", "localization"
- Casual: "add translations", "translate this", "add labels", "text in Arabic", "need both languages", "add the Arabic version"
- Problem: "new UI text needs to be in both languages", "I added a screen and it needs translations"
- Inputs: keys and values

**i18n-sync** — Audit and sync locale files
- Technical: "sync locales", "translation audit", "missing keys", "locale diff", "orphaned keys"
- Casual: "check translations", "are all translations there", "find missing translations", "translations out of sync"
- Problem: "some text might not be translated", "en.json and ar.json might be out of sync"
- Inputs: none

**git-workflow** — Branch naming, commits, PR creation
- Technical: "branch", "commit", "pull request", "PR", "push", "feature branch", "merge request"
- Casual: "save my work", "create a branch", "push changes", "open a PR", "start working on ticket [X]", "ready to submit"
- Problem: "I need to commit and push this", "how do I name this branch", "ready to open a PR"
- Inputs: ticket number

**changelog** — Generate changelog from git history
- Technical: "changelog", "release notes", "commit summary", "version history", "release log"
- Casual: "what changed", "summarize changes", "list of changes", "what did we do since last release"
- Problem: "need to tell the team what's in this release"
- Inputs: date range or tag

**document-component** — Generate component usage docs
- Technical: "component docs", "API documentation", "usage guide", "props documentation", "JSDoc"
- Casual: "write docs for", "how to use this component", "document this", "usage examples", "explain how to use"
- Problem: "someone new needs to know how to use this component", "there's no documentation for [X]"
- Inputs: component path

**debug-build** — Diagnose and fix build errors
- Technical: "build error", "type error", "compilation failure", "tsc error", "Vite build failure"
- Casual: "build is broken", "it won't compile", "red errors", "build fails", "can't build", "everything is red", "npm run build doesn't work"
- Problem: "the project won't build", "getting errors when I run build", "CI is failing on build step"
- Inputs: error message

## Routing Intelligence

### Subsumption Rules

When a broader skill is selected, narrower skills it already covers are removed:

- `scaffold-feature` selected -> remove `create-api` and `create-page`
- Keep `create-form`, `create-table`, `add-translations` — scaffold doesn't cover those

### Execution Order

Skills run in dependency order:

| Layer | Skills | Rationale |
|-------|--------|-----------|
| 1 - Infrastructure | create-api, create-context, migrate-endpoint | No UI dependency |
| 2 - Structure | scaffold-feature, create-page | Needs API/context to exist |
| 3 - UI | create-component, create-form, create-table, figma-to-code, extract-component | Needs page/structure |
| 4 - Assets | add-icon, add-translations | Needs UI to know what keys/icons are needed |
| 5 - Workflow | git-workflow, changelog, document-component | After building |
| 0 - Standalone | debug-build, i18n-sync | Always run alone, never combined |

### Auto-Add Rules

| Condition | Action |
|-----------|--------|
| Any UI-creating skill selected | Append `add-translations` |
| Figma URL detected in message | Prepend `figma-to-code` |
| Ticket number detected (e.g., DM-xxx) | Append `git-workflow` |

### Conflict Resolution

When the message is ambiguous between paths, ask one clarifying question:

| Ambiguity | Question |
|-----------|----------|
| No trigger signals match | "Can you describe what you're building? I'll pick the right tools." |
| "Create a component" — shared or view? | "Is this a reusable shared component, or a view component for a specific feature?" |
| "Add an API" — standalone or full feature? | "Do you need just the API pipeline, or a full feature with page and UI?" |
| "Build a form" — standalone or part of feature? | "Is this form for an existing feature, or should I scaffold the feature too?" |

## Workflow

### Step 1 — Analyze Message

Read the user's message and extract:
- Intent signals: match against trigger catalog (technical + casual + problem-oriented)
- Shared inputs: feature name, entity name, endpoint URLs, ticket numbers, Figma URLs
- Explicit skill mentions: if the user names a skill directly, always include it

### Step 2 — Select Skills

1. Match message against trigger signals to build candidate list
2. Apply subsumption rules (remove redundant skills)
3. Apply auto-add rules (append translations, prepend Figma, append git)
4. Apply standalone rules (debug-build and i18n-sync run alone)

### Step 3 — Handle Ambiguity

If the message doesn't clearly map or maps to conflicting paths, ask one clarifying question.

### Step 4 — Present Plan

Show the user what will run before executing:

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

Wait for user confirmation.

### Step 5 — Execute Sequentially

Invoke each skill via the Skill tool in the planned order. Before each invocation, include the shared context as the skill's arguments so skills don't re-ask for inputs the user already provided. For example: `Skill("forge:create-table", args: "Entity: Order, columns: name/status/total/date, features: search + pagination + sorting")`.

### Step 6 — Summary

After all skills complete, show a brief recap of what was created.

## Excluded Skills

These 6 skills are NOT dispatched by the router — they have their own entry points:

| Skill | Entry Point |
|-------|-------------|
| review-code | `/forge:review-code` |
| audit-a11y | Run by review-code |
| audit-dark-mode | Run by review-code |
| audit-rtl | Run by review-code |
| audit-imports | Run by review-code |
| refactor-to-standards | `/forge:refactor-to-standards` |
