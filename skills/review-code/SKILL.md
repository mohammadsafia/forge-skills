---
name: forge:review-code
description: "Review code or changes for correctness, regressions, security, accessibility, and verified project-standard violations. Use for code reviews, PR reviews, pre-commit checks, or requests to assess code quality. Report evidence-backed findings with exact locations; do not modify code unless the user also asks for fixes."
---

# Review Code

Find actionable defects and regressions in the requested scope. Prioritize behavior and risk over stylistic preference.

## 1. Establish scope

- Specific files or directories: review those targets and the directly affected call sites.
- “My changes”: inspect staged and unstaged diffs, including untracked files relevant to the change.
- Branch or PR: discover the base branch, then inspect the merge-base diff. Do not assume `main`.
- Entire repository: sample architecture first, then review high-risk boundaries systematically.

Keep the review read-only unless the user explicitly asks to fix findings.

## 2. Discover the project contract

Before applying conventions, inspect the closest repository instructions and relevant configuration:

- `AGENTS.md`, `CLAUDE.md`, contribution or architecture documentation
- `package.json`, TypeScript, lint, formatter, test, bundler, and framework configuration
- nearby production code that demonstrates established patterns

Use [../_shared/code-standards.md](../_shared/code-standards.md) as the fallback profile. Its **Required** rules are general risk checks. Enforce **Project** rules only when local evidence confirms adoption. Never present a personal preference as a defect.

For React code, read [../_shared/react-version-compatibility.md](../_shared/react-version-compatibility.md) before making version-dependent recommendations.

## 3. Understand the change

Read the diff and enough surrounding code to answer:

1. What behavior is intended to change?
2. Which callers, consumers, routes, schemas, caches, exports, and tests depend on it?
3. What inputs and failure states can reach the changed code?
4. Which claims can be verified with available tests or static checks?

Review changed lines first, but report unchanged code when the change makes an existing defect reachable or materially worse. Do not inventory unrelated legacy issues.

## 4. Review by risk

Always check:

- correctness and edge cases
- runtime and async safety
- type and API-contract consistency
- backward compatibility and cross-file completeness
- security and sensitive-data handling
- accessibility for changed interactive UI
- test coverage or another credible verification path

Load detailed references only when relevant to the files under review:

| Changed area | Read |
|---|---|
| API handlers, endpoints, queries, mutations | `references/api-rules.md`, `references/correctness-rules.md` |
| React components and hooks | `references/component-rules.md`, `references/react-patterns-rules.md` |
| Runtime boundaries, storage, parsing, URLs | `references/runtime-safety-rules.md` |
| Shared component APIs | `references/reusability-rules.md` |
| Types, DTOs, schemas | `references/type-rules.md` |
| Imports, exports, naming | `references/import-rules.md`, `references/naming-rules.md` |
| Styling, themes, RTL | `references/styling-rules.md` |
| Architecture or broad refactors | `references/architecture-rules.md` |
| Cleanup and maintainability | `references/code-hygiene-rules.md` |

Use specialized audit skills only when requested or materially relevant. Route interface-level critique to `forge:review-ui-ux`, system-boundary analysis to `forge:review-frontend-architecture`, and deep threat analysis to `forge:super-security-review`. A generic review does not automatically run every audit.

## 5. Verify findings

For every candidate finding:

1. Re-read the exact lines and relevant definition or caller.
2. Confirm the problematic path is reachable under a realistic input or state.
3. Check whether local configuration, library behavior, or nearby code already handles it.
4. Identify the concrete impact and the smallest credible correction.
5. Run targeted tests, type checks, lint, or build commands when available and proportionate.

Do not report:

- speculative problems without a plausible failure path
- formatting or naming preferences not established by the project
- missing memoization without an identity/performance consequence
- `any`, assertions, optional chaining, relative imports, or inline conditionals merely because they exist
- pre-existing issues unrelated to the requested change
- generated or vendored files unless the change directly affects them

If evidence is incomplete, either omit the finding or label it as a question with the missing fact. Questions do not count as defects.

## 6. Severity

Classify by impact, not by rule wording:

| Severity | Criteria |
|---|---|
| **Critical** | Credible exploitation, data loss, credential exposure, or broad production outage. |
| **High** | Likely user-visible failure, broken primary flow, authorization flaw, persistent data corruption, or major regression. |
| **Medium** | Real defect with limited scope, reachable edge-case failure, accessibility barrier, or meaningful maintainability risk. |
| **Low** | Verified project-policy violation or minor behavior/UX issue with small impact. |

Optional improvements belong in a separate Suggestions section and are not counted as findings.

## 7. Report

Lead with findings ordered by severity. Each finding must contain:

- exact `path:line`
- concise title and severity
- the triggering scenario
- concrete impact
- smallest reasonable fix direction

Example:

```markdown
## Findings

- **High — Stale order data after successful update**
  `src/hooks/useUpdateOrder.ts:31`
  The mutation invalidates the detail key but not the list key. Returning to the list after an update continues to show the old status until the cache expires. Invalidate the list key as well, or update both caches from the response.

- **Medium — Submit remains active during the request**
  `src/views/orders/OrderForm.tsx:74`
  A second click can create a duplicate request because the button is not disabled while the mutation is pending. Bind its disabled/loading state to the mutation.

## Questions

- `src/api/orders.ts:18` — Is an empty `customerId` accepted by the backend? The local schema permits it, but the API contract is not present.

## Suggestions

- `src/views/orders/OrderSummary.tsx:20` — Consider extracting the repeated status presentation if another consumer is planned.

## Verification

- `npm test -- orders`: passed
- `npm run typecheck`: passed

## Summary

2 findings: 1 high, 1 medium. No critical issues found.
```

If there are no findings, say so directly and mention any important verification gaps. Do not fabricate a full report.

## Checklist

- [ ] Scope and base branch were discovered rather than assumed
- [ ] Local instructions and configuration were checked
- [ ] Findings are caused or exposed by the reviewed change
- [ ] Every finding has a verified location, trigger, impact, and fix direction
- [ ] Severity reflects user/system impact
- [ ] Suggestions are separated from defects
- [ ] Relevant checks were run, or the verification gap is stated
