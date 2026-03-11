# forge-skills

Professional Claude Code skills for React + TypeScript development. Standards-driven code generation, review, and scaffolding.

23 skills covering the full development lifecycle — from Figma design to production code, API integration, component creation, code review, and git workflow.

## Install

```bash
claude install-skill gh:mohammadsafia/forge-skills
```

## Skills

### Design
| Skill | Command | Description |
|-------|---------|-------------|
| Figma to Code | `forge:figma-to-code` | Convert Figma designs into production-ready React components with correct design tokens, spacing, dark mode, RTL, and responsive behavior |

### Creation
| Skill | Command | Description |
|-------|---------|-------------|
| Create API | `forge:create-api` | Full API integration pipeline — endpoint, DTOs, handler, React Query hook |
| Create Component | `forge:create-component` | Reusable component with audit → build → verify workflow |
| Create Form | `forge:create-form` | Form with Zod validation, FormProvider, and API integration |
| Create Table | `forge:create-table` | TanStack React Table with columns, search, pagination, sorting |
| Create Page | `forge:create-page` | New page with routing, layout, guards, and translations |
| Create Context | `forge:create-context` | React Context with provider and custom hook |
| Scaffold Feature | `forge:scaffold-feature` | Complete feature skeleton — page, views, API, hooks, types, translations |
| Add Icon | `forge:add-icon` | Add custom SVG icon to the icon system with barrel export |
| Add Translations | `forge:add-translations` | Add i18n keys to both locale files simultaneously |

### Quality
| Skill | Command | Description |
|-------|---------|-------------|
| Review Code | `forge:review-code` | Full standards audit with structured report |
| Audit Accessibility | `forge:audit-a11y` | Check ARIA, keyboard nav, focus management, screen readers |
| Audit Dark Mode | `forge:audit-dark-mode` | Find hardcoded colors that break in dark mode |
| Audit RTL | `forge:audit-rtl` | Find directional styling issues for right-to-left support |
| Audit Imports | `forge:audit-imports` | Check barrel usage, path aliases, import ordering |

### Refactoring
| Skill | Command | Description |
|-------|---------|-------------|
| Refactor to Standards | `forge:refactor-to-standards` | Bring non-compliant code to full compliance |
| Extract Component | `forge:extract-component` | DRY up repeated JSX into reusable components |
| Migrate Endpoint | `forge:migrate-endpoint` | Update full API chain when backend endpoint changes |

### Workflow
| Skill | Command | Description |
|-------|---------|-------------|
| Git Workflow | `forge:git-workflow` | Branch naming, commit messages, PR creation with Jira conventions |
| i18n Sync | `forge:i18n-sync` | Keep en.json and ar.json locale files in sync |
| Debug Build | `forge:debug-build` | Diagnose and fix TypeScript, Vite, and ESLint build failures |

### Documentation
| Skill | Command | Description |
|-------|---------|-------------|
| Document Component | `forge:document-component` | Generate usage docs for existing components |
| Changelog | `forge:changelog` | Generate changelog from git history with Jira ticket grouping |

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
- **Git**: Jira ticket conventions for branches, commits, and PRs

## Configuration

These skills read your project's configuration at runtime:

- `CLAUDE.md` — Project-specific rules and patterns
- `src/index.css` — Available design tokens
- `src/components/*/index.ts` — Available components
- `tsconfig.json` — Path aliases

This makes the skills portable across projects that follow similar patterns.

## License

MIT
