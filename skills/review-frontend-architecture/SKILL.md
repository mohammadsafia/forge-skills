---
name: forge:review-frontend-architecture
description: "Review frontend architecture for boundaries, dependency direction, state ownership, data flow, API contracts, scalability, testability, performance, and migration risk. Use for architecture reviews, feature-boundary decisions, growing React applications, or major refactors."
---

# Review Frontend Architecture

Assess whether the current structure makes product changes safe and understandable. Avoid prescribing a fashionable folder tree without evidence.

## Establish forces

Discover product domains, team ownership, deployment model, framework/runtime, supported React versions, data sources, shared packages, and the rate and type of expected change.

## Review

- Module boundaries and dependency direction
- Feature cohesion and inappropriate cross-feature coupling
- Public APIs, barrels, cycles, and accidental deep imports
- State ownership: server, URL, local, shared UI, and persistent state
- Data-fetching boundaries, caching, invalidation, normalization, and error strategy
- Rendering model: SPA, SSR, streaming, Server Components, hydration, and client boundaries
- Design-system layering and separation of primitives, composites, and domain UI
- Runtime validation and API-contract evolution
- Test seams, observability, feature flags, migrations, and rollback
- Bundle boundaries, route splitting, waterfalls, and costly shared dependencies

Read `../_shared/react-version-compatibility.md` when React behavior influences the recommendation.

## Decision quality

For every proposed architectural change state:

- the concrete problem it solves
- evidence that the problem exists
- alternatives considered
- migration steps and compatibility impact
- cost of doing nothing
- how the result will be verified

Prefer incremental, reversible improvements. Thresholds such as file length, number of props, or number of consumers are investigation signals—not architecture laws.
