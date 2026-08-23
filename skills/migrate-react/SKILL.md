---
name: forge:migrate-react
description: "Plan and implement React upgrades, especially React 18 to React 19 and incremental React Compiler adoption. Use when upgrading React, React DOM, type packages, JSX transforms, deprecated APIs, refs, Actions, tests, hydration, or Compiler configuration."
---

# Migrate React

Upgrade React deliberately while preserving behavior, third-party compatibility, and rollback options.

## Establish the migration surface

Read `../_shared/react-version-compatibility.md`, then inspect exact React/React DOM/type versions, framework support, JSX transform, bundler plugins, test renderer, SSR/hydration entrypoints, Strict Mode, peer dependencies, and packages that integrate with React internals.

Verify current behavior against official React and framework documentation before changing version-specific APIs.

## React 18 to 19 sequence

1. Record a clean baseline: build, typecheck, tests, critical browser flows, hydration warnings, and bundle/performance signals.
2. Check framework and dependency peer compatibility before changing packages.
3. Update React, React DOM, and type packages together with the modern JSX transform.
4. Apply official codemods where appropriate, then review their diff rather than trusting them blindly.
5. Replace removed APIs and assess deprecated APIs such as `element.ref` and `react-test-renderer`.
6. Verify refs, Context, form behavior, Suspense, Strict Mode, SSR/hydration, testing utilities, and TypeScript changes.
7. Adopt React 19 features only when they simplify an existing requirement; upgrading does not require rewriting stable flows to Actions or ref props.

## React Compiler adoption

- Treat Compiler adoption as a separate, incremental migration unless the framework already enables and supports it.
- Detect the compilation mode and verify compiled components with supported tooling.
- Fix Rules-of-React violations surfaced by the compiler.
- Keep existing manual memoization initially; remove it only with focused tests and performance verification.
- Use directives sparingly and document temporary opt-outs.
- Roll out by feature or package when risk warrants it, with an explicit disable path.

## Completion

Report dependency changes, codemods, manual migrations, checks run, compatibility gaps, warnings remaining, and rollback instructions. Do not claim completion if supported critical flows or hydration behavior were not verified.
