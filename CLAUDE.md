# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**forge-skills** is a collection of 24 Claude Code skills for React + TypeScript development. It is a content-only package — no build step, no tests, no runtime code. All deliverables are markdown files distributed via `npx skills add mohammadsafia/forge-skills`.

## Repository Structure

```
skills/<skill-name>/
├── SKILL.md              # Skill definition (frontmatter + step-by-step workflow)
└── references/           # Optional — static rule books, templates, lookup tables
    └── *.md
```

- **SKILL.md** — YAML frontmatter (`name`, `description`) + numbered step sections + checklists. The `name` field is always prefixed with `forge:` (e.g., `forge:create-api`).
- **references/** — Companion docs referenced by SKILL.md. Contains code templates, rule tables, naming conventions, and violation/fix catalogs. Not all skills have references; simpler skills are self-contained.
- **evals/** — Directory reserved for skill evaluations (currently empty).
- **package.json** — Metadata only; no dependencies, no scripts.

## Skill Authoring Conventions

### Frontmatter Format
```yaml
---
name: forge:<skill-name>
description: "What the skill does. When to trigger it. Keywords that activate it."
---
```

The `description` field is critical — it determines when the skill is invoked. It should include: what the skill does, what the user is trying to accomplish, trigger keywords/phrases, and typical use cases.

### Skill Body Pattern
1. H1 title + one-line summary
2. Numbered `## Step N — Phase Name` sections with actionable instructions
3. Code blocks with language-tagged templates (TypeScript, TSX)
4. Final `## Checklist` section with `- [ ]` verification items
5. References linked inline as `references/filename.md`

### Reference File Pattern
- Standalone markdown with code templates, lookup tables (e.g., pixel-to-Tailwind), and correct/incorrect examples
- Referenced from SKILL.md — they are the source of truth for project standards
- Shared across skills (e.g., import rules appear in both `review-code` and `refactor-to-standards`)

## Skill Categories

| Category | Skills | Has References |
|----------|--------|---------------|
| Design | figma-to-code | Yes |
| Creation | create-api, create-component, create-form, create-table, create-page, create-context, scaffold-feature, add-motion | Most do |
| Quality | review-code, audit-a11y, audit-dark-mode, audit-rtl, audit-imports | review-code does |
| Refactoring | refactor-to-standards, extract-component, migrate-endpoint | refactor-to-standards does |
| Workflow | git-workflow, i18n-sync, add-translations, add-icon, debug-build, changelog, document-component | git-workflow does |

## Target Tech Stack

Skills generate code for: React 19, TypeScript 5 (strict), Vite 6, Tailwind CSS 4 with design tokens, shadcn/ui (Radix), TanStack React Query 5, TanStack React Table 8, React Hook Form + Zod, React Router 6, i18next, Axios, Lucide React.

## Key Standards Enforced Across Skills

These standards are embedded in skill instructions and reference files — they are the "rules" that skills teach Claude to follow:

- `type` over `interface`; no `any`; DTO naming: `ForReadDto`, `ForCreateDto`, `ForUpdateDto`, `ListDto`, `ListResponseDto`, `ParamsDto`
- Barrel-only imports; path aliases; strict import group ordering (React → third-party → UI → shared → contexts/hooks → utils → icons → types)
- `cn()` for conditional classes; `Conditional.If` instead of `&&` for conditional rendering; `data-slot` attributes
- Theme-aware tokens only (no hardcoded colors like `bg-white`); Tailwind spacing scale; mobile-first; RTL via `rtl:` prefix
- Handler pattern with string queryKeys; typed DTOs; React Query hooks with no explicit return types
- FormProvider-based forms with Zod validation
- Component code order: hooks → context → shared hooks → queries → state → memo → callbacks → effects → JSX

## Working on This Repository

Since this is a content-only repo, there are no build/test/lint commands. Changes are purely markdown edits. When modifying skills:

1. Keep the `forge:` namespace prefix on all skill names
2. Ensure SKILL.md frontmatter `description` is thorough — it controls skill triggering
3. Reference files should be factual/templated content, not procedural — workflow belongs in SKILL.md
4. All examples in skills must be generic (no project-specific names, paths, or references)
