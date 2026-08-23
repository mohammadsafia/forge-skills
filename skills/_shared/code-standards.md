# Forge React + TypeScript Standards

This is the default Forge profile. It is not a substitute for inspecting the target repository.

## Authority and precedence

Apply instructions in this order:

1. The user's explicit requirements.
2. Repository-local instructions such as `AGENTS.md`, `CLAUDE.md`, contribution docs, lint rules, and formatter configuration.
3. Patterns consistently established in nearby production code.
4. This Forge profile.

When sources disagree, follow the higher-precedence source and mention the conflict only when it affects the result.

Each rule has one of these levels:

- **Required** — correctness, security, accessibility, data integrity, or a verified build/runtime constraint.
- **Project** — enforce only when adopted by local instructions, tooling, or consistent codebase patterns.
- **Recommended** — a contextual improvement; do not report it as a defect without demonstrated impact.

Before applying Project rules, discover the repository's package versions, aliases, directory layout, design tokens, reusable components, state architecture, and localization setup. Paths and names below are examples, not guaranteed locations.

For React-specific decisions, read [react-version-compatibility.md](react-version-compatibility.md) and classify the target as React 18, React 19 without Compiler, or React 19 with Compiler.

## 1. Imports

| Level | Rule |
|---|---|
| Required | Imports resolve correctly and do not introduce circular runtime dependencies. |
| Required | Use `import type` when required by the project's TypeScript/compiler configuration. |
| Project | Follow the repository's alias, barrel, and import-order conventions. Do not invent aliases or barrels that do not exist. |
| Recommended | Prefer the shortest stable public import path that does not harm tree shaking or create cycles. |

Do not classify a relative import, direct-file import, or import grouping as defective until the local convention is verified.

## 2. Types

| Level | Rule |
|---|---|
| Required | Avoid implicit `any`, unjustified explicit `any`, unsafe assertions, and non-null assertions that hide reachable null states. |
| Required | External data is typed and validated at the trust boundary when runtime shape is not guaranteed. |
| Required | Discriminated states use types that prevent impossible combinations where practical. |
| Project | Follow local `type` versus `interface`, DTO naming, file naming, and export conventions. |
| Recommended | Name reusable nested shapes when doing so improves clarity; small local object shapes may remain inline. |

An assertion is not automatically a defect. Report it only when it is unsafe, unnecessary, or violates a verified policy.

## 3. API layer

| Level | Rule |
|---|---|
| Required | Use the correct HTTP method, URL, path parameters, query parameters, body, and response type for the contract. |
| Required | Validate or safely handle untrusted response data when the client cannot rely on a generated/verified contract. |
| Required | Do not expose secrets or treat client-side checks as authorization. |
| Project | Follow the repository's endpoint registry, request-client, handler, and key conventions. |
| Recommended | Centralize repeated endpoint and request behavior when it reduces drift. |

Never require `ApiEndpoints.ts`, plain-string endpoints, `pathBuilder`, or a particular handler shape unless the project uses them.

## 4. Server-state hooks

| Level | Rule |
|---|---|
| Required | Cache keys include every input that changes the result. |
| Required | Parameter-dependent queries cannot execute with invalid or missing parameters. |
| Required | Mutations reconcile affected cached data through invalidation, direct updates, or another documented strategy. |
| Required | Loading, error, empty, and success behavior is handled where each state is reachable. |
| Recommended | Avoid copying server state into local state unless editing, snapshotting, or another explicit synchronization need exists. |
| Project | Follow local hook locations, naming, key factories, notification behavior, and return-type conventions. |

Do not mandate invalidation when an optimistic update or direct cache update is correct. Do not require a toast for every error when an error boundary or inline error UI already provides feedback.

## 5. Components

| Level | Rule |
|---|---|
| Required | Interactive behavior is keyboard accessible, labeled, focus-visible, and semantically appropriate. |
| Required | Effects and subscriptions clean up resources and do not create stale-closure bugs. |
| Required | Rendered collections use stable keys whenever identity can change. |
| Project | Follow local component placement, exports, naming, composition, and `data-slot` conventions. |
| Recommended | Extract components when reuse, independent behavior, or readability justifies the abstraction. |

Line count, prop count, and reuse count are signals for investigation—not automatic violations.

## 6. Conditional rendering

| Level | Rule |
|---|---|
| Required | The chosen pattern preserves mount/unmount behavior, state, focus, and animation semantics. |
| Project | Use a local `Conditional` wrapper when the repository has adopted it. |
| Recommended | Prefer the clearest idiomatic expression for the actual branch. |

Inline conditionals may be necessary for `AnimatePresence`, short-circuit side-effect avoidance, or ordinary React idioms. Never replace them mechanically.

## 7. Forms

| Level | Rule |
|---|---|
| Required | Labels, validation, submitted fields, default values, and API payloads agree. |
| Required | Submission prevents accidental duplicates and exposes pending/failure state. |
| Required | Client validation improves UX but is not treated as server-side enforcement. |
| Project | Follow local form providers, field wrappers, schema locations, and translation conventions. |
| Recommended | Keep schema and form types derived from one source when the libraries support it. |

## 8. Styling and design tokens

| Level | Rule |
|---|---|
| Required | Text and controls meet applicable contrast, focus, zoom, and responsive requirements. |
| Required | UI supports the themes and writing directions the product actually claims to support. |
| Project | Use discovered semantic tokens, spacing scales, class utilities, and styling architecture. |
| Recommended | Prefer semantic tokens over literal colors for theme-sensitive surfaces. |

Do not assume Tailwind, a specific palette, dark mode, or RTL. When those capabilities exist, verify them against the actual configuration rather than token names alone.

## 9. File organization

| Level | Rule |
|---|---|
| Required | New files are reachable, exported when needed, and included in routing/build configuration. |
| Project | Match neighboring folder casing, barrel usage, co-location, and feature boundaries. |
| Recommended | Keep closely changing code together and avoid layers that only forward calls or props. |

## 10. Component internals and React behavior

| Level | Rule |
|---|---|
| Required | Hooks follow the Rules of Hooks and have correct dependencies. |
| Required | Async work handles races, cancellation/cleanup, and post-unmount effects where relevant. |
| Required | Derived values remain consistent with their sources. |
| Project | Follow an established internal ordering convention when the repository documents one. |
| Recommended | Use `useMemo` and `useCallback` only when identity or computation cost has a demonstrated consumer or measurable benefit. |

Do not report missing memoization solely because an object, array, or callback is created during render. React Compiler adoption and component behavior may make manual memoization unnecessary.

## 11. Date, time, and localization

| Level | Rule |
|---|---|
| Required | Date/time parsing and formatting uses the intended locale and timezone and avoids ambiguous input formats. |
| Required | Translation keys exist for supported locales and interpolation/pluralization variables match. |
| Required | Do not delete apparently unused keys based only on literal-call searches. |
| Project | Use the repository's localization hooks, namespaces, date helpers, and key naming. |
| Recommended | Keep user-facing copy translatable when localization is a product requirement. |

## 12. General quality

| Level | Rule |
|---|---|
| Required | No merge markers, reachable crashes, swallowed critical failures, leaked credentials, or sensitive production logs. |
| Required | Changed public APIs remain compatible or all consumers are migrated. |
| Required | New behavior has verification proportional to risk; tests should cover meaningful failure paths. |
| Project | Follow local event-handler naming, route-loading, dependency, logging, and commit conventions. |
| Recommended | Remove dead code and stale TODOs in the changed scope when doing so does not expand the task. |

## Review application

- Report only findings supported by code and relevant context.
- Separate defects from verified project-policy violations and optional improvements.
- State uncertainty when a dependency, runtime assumption, or product requirement cannot be confirmed.
- Prefer the smallest safe fix; do not redesign unrelated code during a review.
