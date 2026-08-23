---
name: forge:design-system
description: "Design, evolve, or review a frontend design system covering tokens, component APIs, states, accessibility contracts, documentation, governance, and migration. Use for component libraries, token systems, UI consistency, design-system architecture, or duplicated interface patterns."
---

# Design System

Turn recurring product and brand decisions into a durable interface system. Do not create abstractions merely to make a component catalog larger.

## Discover

Inventory existing tokens, primitives, shared components, product-specific composites, supported themes/locales, framework versions, styling tools, design sources, and consumers. Identify actual inconsistency and duplication before proposing a new layer.

## System layers

- Foundations: color roles, typography, spacing, radius, elevation, motion, breakpoints, density, and iconography.
- Primitives: semantic low-level controls with complete interaction and accessibility behavior.
- Composites: reusable product-neutral patterns built from primitives.
- Domain UI: feature-specific components that should not leak into the shared system prematurely.

## Component contract

Define anatomy, semantic element, content rules, variants, sizes, states, keyboard behavior, focus management, responsive behavior, localization/RTL behavior, theming, composition API, escape hatches, and test expectations.

Prefer semantic tokens such as surface, content, border, accent, and status roles over component-specific literal colors. Token additions require a clear semantic purpose and coverage for supported themes.

## Governance

- Define ownership and contribution/review expectations.
- Document when to reuse, extend, compose, or create a new component.
- Use semantic versioning or an equivalent migration policy for shared public APIs.
- Provide codemods or staged migrations for broad breaking changes when practical.
- Track adoption, duplicate patterns, accessibility regressions, and deprecated APIs.

Read `../_shared/react-version-compatibility.md` before designing refs or public APIs for React libraries. Cross-version libraries should not expose React 19-only APIs unless their peer requirements say so.

Deliver decisions, component/token contracts, migration steps, and validation criteria—not only a visual style guide.
