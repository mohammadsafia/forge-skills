---
name: forge:brainstorm-feature
description: "Explore and shape a frontend feature before implementation. Use when the user asks to brainstorm, ideate, compare approaches, clarify UX, or make an architecture decision with multiple viable options. Produces a concise approved design direction; does not implement unless requested afterward."
---

# Brainstorm Feature

Turn an incomplete idea into a decision-ready frontend design without forcing heavyweight process onto simple work.

## Workflow

1. Inspect relevant repository context, existing product patterns, and constraints.
2. Identify the user, job-to-be-done, success signal, primary flow, and important failure/empty/loading states.
3. Ask only questions whose answers materially change the solution. Ask one at a time when interaction is needed.
4. Generate two or three genuinely different approaches when meaningful alternatives exist.
5. Compare them across user value, complexity, accessibility, performance, architectural fit, delivery risk, and reversibility.
6. Recommend one direction and explain the decisive tradeoff.
7. Present the design at the depth appropriate to the task: flow, state model, component boundaries, data contract, responsive behavior, accessibility, analytics, rollout, and test strategy as relevant.

Do not write code while the user is explicitly brainstorming. Once the direction is accepted, summarize the decisions and unresolved questions so an implementation or technical plan can consume them.

## Output

- Problem and target user
- Goals and explicit non-goals
- Options considered
- Recommended direction and rationale
- UX states and edge cases
- Architecture/data implications
- Risks and validation plan
- Open decisions, if any
