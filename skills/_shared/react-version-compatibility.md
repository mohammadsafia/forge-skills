# React Version Compatibility

Discover the installed `react`, `react-dom`, type-package versions, JSX transform, framework, and React Compiler configuration before applying version-specific advice. Do not infer Compiler usage from React 19 alone.

## Decision matrix

| Area | React 18 | React 19 without Compiler | React 19 with Compiler |
|---|---|---|---|
| Manual memoization | Use `useMemo`, `useCallback`, and `memo` only for expensive calculations or meaningful identity boundaries | Same guidance | Prefer Compiler optimization for new code; retain existing manual memoization unless careful testing supports removal |
| Refs | `forwardRef` is the standard way for a function component to receive a ref | Function components can receive `ref` as a prop; `forwardRef` remains compatible but is no longer necessary for new React 19-only code | Same as React 19 |
| Context provider | `<Context.Provider value={...}>` | `<Context value={...}>` is supported; Provider syntax remains useful for cross-version libraries | Same as React 19 |
| Form mutations | Library handlers and ordinary submit callbacks | Actions, function-valued `action`/`formAction`, `useActionState`, `useFormStatus`, and `useOptimistic` are available | Same as React 19 |
| Document metadata | Framework or head-management solution | React can render `title`, `meta`, and `link` in component output; keep using framework conventions when they provide routing/SSR integration | Same as React 19 |
| Testing | Prefer Testing Library; `react-test-renderer` may exist | `react-test-renderer` is deprecated; prefer Testing Library | Same as React 19 |
| JSX transform | Modern transform recommended | Modern transform required | Modern transform required |

## Memoization rules

- `useMemo` is a performance optimization, not a semantic guarantee. Code must remain correct without it.
- Without Compiler, add memoization only for expensive recalculation, a memoized child boundary, or stable dependencies required by another hook/library.
- With Compiler, do not request manual memoization by default. Verify whether the component is compiled and use escape hatches only when needed.
- Do not remove existing memoization mechanically in Compiler-enabled projects; behavior and compilation output must be tested.
- Check dependency correctness in every version. Compiler support does not excuse impure rendering or incorrect effects.

## Compatibility strategy

- Application targeting only React 19: prefer React 19 APIs when they simplify behavior and fit the framework.
- Shared library supporting React 18 and 19: preserve the React 18-compatible public surface unless the package declares a React 19 peer requirement.
- Migration work: use the official React upgrade guide and codemods, then verify Strict Mode, tests, types, hydration, and third-party compatibility.
- Never rewrite a stable library-based form or state flow solely to use a newer React API; require a concrete product or maintenance benefit.

## Review checks

- React and `@types/react` major versions agree.
- React 19 uses the modern JSX transform.
- New React 19-only APIs are not introduced into packages that still support React 18.
- `element.ref`, legacy Context, string refs, and removed ReactDOM APIs are not used on React 19 paths.
- Actions expose pending, error, rollback, and duplicate-submission behavior correctly.
- Optimistic state reconciles with authoritative server state after success and failure.
- Hydration and Server/Client Component boundaries are reviewed according to the framework, not generic React assumptions.

When version behavior may have changed, verify against current official React documentation before editing or reporting a finding.
