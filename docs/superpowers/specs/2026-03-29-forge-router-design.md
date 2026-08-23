# Forge Router Design

## Status

Implemented and maintained by `skills/forge/SKILL.md`. This document describes current behavior; the skill file is the executable source of truth.

## Purpose

`forge:forge` is a portable entry point for selecting and coordinating Forge building and workflow skills from a natural-language request. It reduces the need to know individual skill names while preserving direct invocation for specialized reviews and audits.

The repository currently contains 34 skills. The router catalog intentionally includes only skills that can participate in a building workflow. Focused quality reviews remain direct entry points so ordinary implementation does not trigger overlapping audits.

## Design principles

- Preserve user intent and authorization boundaries.
- Discover repository structure, versions, and conventions before applying defaults.
- Prefer the smallest non-overlapping skill set.
- Carry shared context forward instead of asking for the same information repeatedly.
- Order dependencies while allowing independent work to run concurrently when the host supports it safely.
- Remain portable across agents; never assume a particular `Skill(...)` tool exists.
- Work without optional third-party companion skills.
- Use confirmation based on risk or material ambiguity, not as a gate for every reversible edit.

## Routed capabilities

### Discovery

- `brainstorm-feature` — product, UX, and architecture exploration before implementation

When brainstorming is explicitly requested, it runs without implementation skills. For a clear implementation request, brainstorming is not imposed as a mandatory gate.

### Standalone diagnosis and migration

- `debug-build`
- `i18n-sync`
- `migrate-react`

These run alone when they are the primary task because combining diagnosis or framework migration with unrelated generation obscures scope and verification.

### Infrastructure

- `create-api`
- `create-context`
- `migrate-endpoint`
- `design-system`

### Structure

- `scaffold-feature`
- `create-page`

### UI

- `create-component`
- `create-form`
- `create-table`
- `figma-to-code`
- `extract-component`
- `add-motion`

### Assets and localization

- `add-icon`
- `add-translations`

### Verification

- `test-frontend`

Testing is suggested when changed behavior has meaningful regression risk. The router must not silently install test infrastructure or add broad dependencies.

### Workflow

- `git-workflow`
- `changelog`
- `document-component`

External mutations such as pulling, pushing, committing, or opening a PR remain subject to user authorization and host approval rules.

## Direct-entry quality skills

The router can recommend these skills but does not silently append them to ordinary building work:

- `review-code`
- `review-ui-ux`
- `review-frontend-architecture`
- `performance-audit`
- `observability-review`
- `super-security-review`
- `refactor-to-standards`
- focused accessibility, dark-mode, RTL, and import audits

This separation prevents duplicate findings and avoids expanding a build request into an unsolicited audit.

## Routing model

### Intent matching

Catalog entries include purpose, trigger language, and required inputs. Matching considers:

- explicit skill mentions
- technical vocabulary
- casual user language
- problem-oriented descriptions
- artifacts such as Figma URLs, endpoint paths, SVG markup, or ticket identifiers

Explicit skill selection takes precedence when it is compatible with the request.

### Subsumption

`scaffold-feature` subsumes `create-api` and `create-page` because it produces those layers. It does not automatically subsume forms, tables, reusable shared components, icons, or translations.

Subsumption is based on actual output overlap, not merely similar trigger words.

### Dependency layers

Execution follows this dependency order:

1. Discovery
2. Standalone diagnosis/migration
3. Infrastructure
4. Structure
5. UI
6. Assets/localization
7. Verification
8. Workflow

Dependent skills run sequentially. Independent work may run concurrently when the host supports it and file ownership does not overlap.

### Auto-add behavior

- UI creation may add translations when the feature does not already handle them.
- A Figma URL selects `figma-to-code` before downstream UI work.
- Ticket context may select `git-workflow`, but does not authorize commits, pushes, or PR creation by itself.
- Testing is recommended based on regression risk rather than appended universally.

### Ambiguity

The router asks one focused question only when the missing answer materially changes the selected workflow. Otherwise, it makes a narrow documented assumption and proceeds.

## React compatibility

Every React workflow discovers:

- installed `react` and `react-dom` versions
- matching type-package versions
- framework and rendering model
- JSX transform
- React Compiler presence and compilation mode

It then applies `skills/_shared/react-version-compatibility.md`, distinguishing React 18, React 19 without Compiler, and React 19 with Compiler. React 19 alone must never be treated as proof that automatic memoization is enabled.

## Companion skills

`skills/forge/references/companion-skills.md` lists optional capabilities such as structured brainstorming, Vercel React performance/composition guidance, interface review, Playwright, and QA engineering.

Companions are used only when available and relevant. Forge remains self-contained, does not install them silently, and avoids combining overlapping reviewers.

## Host portability

The router uses the host's supported skill-loading mechanism. If programmatic invocation is unavailable, the agent reads and applies the selected skill instructions directly. The design does not prescribe a Claude-, Codex-, Cursor-, or IDE-specific API.

## User interaction

A short plan is useful for multi-skill or materially ambiguous work. Confirmation is required only when:

- a material product or architecture choice remains unresolved
- an action is destructive or externally mutating
- new authority is required
- the host environment requires approval

Clear, reversible, in-scope edits can proceed from the user's implementation request.

## Completion contract

The router reports:

- selected capabilities and meaningful assumptions
- files or artifacts created or changed
- verification performed and its result
- unresolved risks or manual work
- an appropriate follow-up review when useful

It must not claim completion when a required downstream skill failed or relevant verification was not performed.

## Validation

Repository validation must confirm:

- all skill names match their folders and remain unique
- router references resolve
- README and repository skill counts match the filesystem
- Markdown fences are balanced
- `npm run validate` and `git diff --check` pass

Behavioral evaluation should additionally cover single-skill routing, multi-skill dependency ordering, subsumption, explicit brainstorming, React migration, unavailable companions, authorization boundaries, and ambiguous requests.
