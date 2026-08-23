# Optional Companion Skills

Forge remains self-contained. Companion skills may deepen a task when they are already available in the host environment; never assume they are installed, install them silently, or make ordinary Forge workflows depend on them.

| Capability | Preferred companion | Use when |
|---|---|---|
| Structured ideation | `brainstorming` from `obra/superpowers` | The user explicitly wants collaborative exploration or approval of a design before implementation |
| React/Next.js performance | `vercel-react-best-practices` from `vercel-labs/agent-skills` | Deepen `forge:performance-audit` when performance is in scope and the target actually uses React or Next.js |
| React composition | `vercel-composition-patterns` from `vercel-labs/agent-skills` | Designing shared component APIs or refactoring boolean-prop-heavy components |
| Interface design | `frontend-design` or a locally available UI/UX design skill | Creating or substantially reshaping visual UI |
| Web interface review | `web-design-guidelines` from `vercel-labs/agent-skills` | Reviewing a rendered interface for design and UX quality |
| Browser verification | A Playwright skill | Deepen `forge:test-frontend` when responsive layout, keyboard flow, or browser behavior must be verified |
| QA strategy | A QA engineering skill | Deepen `forge:test-frontend` when a feature needs broader risk-based test design |

## Invocation rules

1. Prefer the user's explicitly named skill.
2. Check whether the companion exists in the current host before referring to it as executable.
3. Use the smallest set that adds unique value; avoid running overlapping reviewers that produce duplicate findings.
4. Apply React-version compatibility before performance or composition advice.
5. Preserve the user's scope: a companion review does not authorize fixes, dependency installation, or external mutations.

If a useful companion is unavailable, continue with Forge's native capability and optionally mention the installable enhancement afterward.
