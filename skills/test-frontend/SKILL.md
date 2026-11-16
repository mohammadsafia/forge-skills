---
name: forge:test-frontend
description: "Design, add, review, or improve frontend tests across unit, component, integration, contract, and end-to-end layers. Use when the user asks for tests, coverage, regression protection, Playwright, Testing Library, flaky-test fixes, or a frontend QA strategy."
---

# Test Frontend

Build confidence around user-visible behavior and high-risk boundaries. Do not optimize for a coverage percentage or reproduce implementation details in tests.

## Discover the test contract

Inspect the framework, React version, test runners, browser tools, existing fixtures, CI commands, accessibility tooling, and neighboring tests. Preserve established conventions unless they are causing a demonstrated problem.

Read `../_shared/react-version-compatibility.md` for React-specific testing constraints. React 19 deprecates `react-test-renderer`; prefer user-facing tests with Testing Library or the project's equivalent.

If `kit.lock.json` exists at the repository root, the app is built on the RSK kit: read `references/rsk-testing.md`
before writing a test. It gives the per-file setup, a whole-app render helper, and how to drive the kit's combobox,
select, date field and time picker.

## Choose the cheapest credible layer

- Unit: pure transformations, reducers, validators, state machines, and edge-heavy utilities.
- Component: rendering, accessibility semantics, interaction, and local state.
- Integration: components plus router, cache, forms, storage, or mocked network boundaries.
- Contract: frontend/backend request and response compatibility when teams or releases are independent.
- E2E: a small set of critical journeys and cross-system behavior that lower layers cannot prove.

Bias toward integration/component tests for frontend behavior. Use E2E for critical paths, not every validation branch.

## Workflow

1. Convert requirements, bugs, and risk areas into observable scenarios. When the project numbers its test cases, name each test by its case ID.
2. Cover the primary path, meaningful failure paths, permissions, loading/empty states, and regression trigger.
3. Render a page the way the app runs it: real routes, guards, layout and providers, with only the network replaced (see "Page tests"). Use accessible queries and user-like interactions. Prefer roles, labels, names, and visible outcomes over internal selectors.
4. Keep data isolated, deterministic and invented (no real people's names, accounts or credentials). Avoid shared mutable fixtures, real clocks, uncontrolled network access, and fixed sleeps. Refuse unlisted requests so a screen cannot call something unnoticed.
5. Give every test a meaningful assertion. Avoid snapshots when a focused semantic assertion is clearer.
6. Run the narrowest relevant command, then broader checks when risk justifies them.
7. Treat flakiness as a defect: fix synchronization or isolation rather than adding retries.

Do not add a testing dependency without authorization. If the repository has no test infrastructure, propose the smallest compatible setup and explain the tradeoff before introducing it.

## Page tests

- Pages are usually loaded lazily, so the first `findBy…` in a file waits for the page's code as well as its data. The library's default wait (1 s) passes on a laptop and fails on a busy pipeline. Set the wait once in the render helper (5 s works) and the test limit well above it (three times or more: 15 s). When the two are equal, the test is stopped before a wait can fail with its own message, and a real defect reads as a timeout.
- Never raise a limit to make a slow test pass without saying so; report it as a reliability finding.
- Assert what a person sees: headings, messages, fields and their values, where focus is after an action, and the request the screen sent (method, path, body).

## Things that are never asserted

- That a toast is absent. Toast state often lives outside React (the RSK `useToast` keeps it in a module) and outlives `cleanup()`, so a toast from the previous test can still be there, and an absence check passes or fails by test order. Assert what proves the outcome instead: the request that was or was not sent, the inline message, the page's state.
- Implementation details: component state, hook calls, class names (except where a class is the contract, such as a kit's invalid state).

## Output

Report scenarios covered, files changed, commands run, results, remaining risk, and any test that could not be made deterministic.
