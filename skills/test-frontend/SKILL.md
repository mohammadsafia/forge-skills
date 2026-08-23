---
name: forge:test-frontend
description: "Design, add, review, or improve frontend tests across unit, component, integration, contract, and end-to-end layers. Use when the user asks for tests, coverage, regression protection, Playwright, Testing Library, flaky-test fixes, or a frontend QA strategy."
---

# Test Frontend

Build confidence around user-visible behavior and high-risk boundaries. Do not optimize for a coverage percentage or reproduce implementation details in tests.

## Discover the test contract

Inspect the framework, React version, test runners, browser tools, existing fixtures, CI commands, accessibility tooling, and neighboring tests. Preserve established conventions unless they are causing a demonstrated problem.

Read `../_shared/react-version-compatibility.md` for React-specific testing constraints. React 19 deprecates `react-test-renderer`; prefer user-facing tests with Testing Library or the project's equivalent.

## Choose the cheapest credible layer

- Unit: pure transformations, reducers, validators, state machines, and edge-heavy utilities.
- Component: rendering, accessibility semantics, interaction, and local state.
- Integration: components plus router, cache, forms, storage, or mocked network boundaries.
- Contract: frontend/backend request and response compatibility when teams or releases are independent.
- E2E: a small set of critical journeys and cross-system behavior that lower layers cannot prove.

Bias toward integration/component tests for frontend behavior. Use E2E for critical paths, not every validation branch.

## Workflow

1. Convert requirements, bugs, and risk areas into observable scenarios.
2. Cover the primary path, meaningful failure paths, permissions, loading/empty states, and regression trigger.
3. Use accessible queries and user-like interactions. Prefer roles, labels, names, and visible outcomes over internal selectors.
4. Keep data isolated and deterministic. Avoid shared mutable fixtures, real clocks, uncontrolled network access, and fixed sleeps.
5. Give every test a meaningful assertion. Avoid snapshots when a focused semantic assertion is clearer.
6. Run the narrowest relevant command, then broader checks when risk justifies them.
7. Treat flakiness as a defect: fix synchronization or isolation rather than adding retries.

Do not add a testing dependency without authorization. If the repository has no test infrastructure, propose the smallest compatible setup and explain the tradeoff before introducing it.

## Output

Report scenarios covered, files changed, commands run, results, remaining risk, and any test that could not be made deterministic.
