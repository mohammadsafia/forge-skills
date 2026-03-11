# forge-skills

Professional Claude Code skills for React + TypeScript development. Standards-driven code generation, review, and scaffolding.

23 skills covering the full development lifecycle — from Figma design to production code, API integration, component creation, code review, and git workflow.

## Install

### Claude Code (Plugin Marketplace)

**Step 1** — Register the marketplace:
```
/plugin marketplace add mohammadsafia/forge-skills
```

**Step 2** — Install all skills at once:
```
/plugin install forge-all@forge-skills
```

Or install by category:
```
/plugin install forge-design@forge-skills
/plugin install forge-create@forge-skills
/plugin install forge-quality@forge-skills
/plugin install forge-refactor@forge-skills
/plugin install forge-workflow@forge-skills
```

### Manual Install (any agent)

Clone and copy to your personal skills directory:

```bash
git clone https://github.com/mohammadsafia/forge-skills.git
cp -r forge-skills/skills/* ~/.claude/skills/
```

## Plugins

| Plugin | Skills | Description |
|--------|--------|-------------|
| `forge-all` | All 23 | Everything in one install |
| `forge-design` | 1 | Figma-to-code workflow |
| `forge-create` | 7 | Code generation (API, components, forms, tables, pages, contexts, features) |
| `forge-quality` | 5 | Code review and auditing (imports, dark mode, RTL, a11y) |
| `forge-refactor` | 3 | Refactoring (standards, extraction, migration) |
| `forge-workflow` | 7 | Git, changelog, i18n, icons, build debugging, docs |

## Skills

### Design
| Skill | Description |
|-------|-------------|
| `figma-to-code` | Convert Figma designs into production-ready React components with correct design tokens, spacing, dark mode, RTL, and responsive behavior |

### Creation
| Skill | Description |
|-------|-------------|
| `create-api` | Full API integration pipeline — endpoint, DTOs, handler, React Query hook |
| `create-component` | Reusable component with audit → build → verify workflow |
| `create-form` | Form with Zod validation, FormProvider, and API integration |
| `create-table` | TanStack React Table with columns, search, pagination, sorting |
| `create-page` | New page with routing, layout, guards, and translations |
| `create-context` | React Context with provider and custom hook |
| `scaffold-feature` | Complete feature skeleton — page, views, API, hooks, types, translations |

### Quality
| Skill | Description |
|-------|-------------|
| `review-code` | Full standards audit with structured report |
| `audit-a11y` | Check ARIA, keyboard nav, focus management, screen readers |
| `audit-dark-mode` | Find hardcoded colors that break in dark mode |
| `audit-rtl` | Find directional styling issues for right-to-left support |
| `audit-imports` | Check barrel usage, path aliases, import ordering |

### Refactoring
| Skill | Description |
|-------|-------------|
| `refactor-to-standards` | Bring non-compliant code to full compliance |
| `extract-component` | DRY up repeated JSX into reusable components |
| `migrate-endpoint` | Update full API chain when backend endpoint changes |

### Workflow
| Skill | Description |
|-------|-------------|
| `git-workflow` | Branch naming, commit messages, PR creation with ticket conventions |
| `i18n-sync` | Keep locale files in sync (find missing keys, orphaned entries) |
| `add-translations` | Add i18n keys to both locale files simultaneously |
| `add-icon` | Add custom SVG icon to the icon system with barrel export |
| `debug-build` | Diagnose and fix TypeScript, Vite, and ESLint build failures |
| `changelog` | Generate changelog from git history grouped by type |
| `document-component` | Generate usage docs for existing components |

## Tech Stack Support

These skills are built for projects using:

- **React 19** + **TypeScript 5** (strict mode)
- **Vite 6** build system
- **Tailwind CSS 4** with design token system
- **shadcn/ui** components (Radix UI)
- **TanStack React Query 5** for server state
- **TanStack React Table 8** for data tables
- **React Hook Form** + **Zod** for forms
- **React Router 6** for routing
- **i18next** for internationalization (with RTL support)
- **Axios** with typed HTTP client
- **Lucide React** for icons

## Standards Enforced

Every skill enforces these standards automatically:

- **Types**: `type` over `interface`, no `any`, DTO naming conventions
- **Imports**: barrel-only imports, path aliases, strict ordering
- **Components**: Conditional rendering, `cn()` utility, compound pattern, data-slot attributes
- **Styling**: theme-aware tokens (no hardcoded colors), Tailwind spacing scale, dark mode, RTL
- **API**: handler pattern with string queryKeys, typed DTOs, React Query hooks
- **Forms**: FormProvider-based, Zod validation, no raw useForm
- **Git**: ticket conventions for branches, commits, and PRs

## Configuration

These skills read your project's configuration at runtime:

- `CLAUDE.md` — Project-specific rules and patterns
- `src/index.css` — Available design tokens
- `src/components/*/index.ts` — Available components
- `tsconfig.json` — Path aliases

This makes the skills portable across projects that follow similar patterns.

## License

MIT
