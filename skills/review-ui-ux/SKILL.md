---
name: forge:review-ui-ux
description: "Review a frontend interface, implementation, screenshot, or flow for usability, visual hierarchy, interaction quality, responsive behavior, accessibility, and design-system consistency. Use for UI critique, UX review, design QA, or pre-release interface polish."
---

# Review UI/UX

Evaluate whether the interface helps its intended users complete the intended task clearly, efficiently, and confidently.

## Discover context

Identify the audience, primary task, device range, supported themes/locales, design system, and product constraints. Review the rendered interface when browser access is available; code alone cannot prove visual quality.

## Review dimensions

- Information architecture and task flow
- Visual hierarchy, typography, spacing, density, and alignment
- Affordance, feedback, system status, error prevention, and recovery
- Loading, empty, error, offline, permission, destructive, and success states
- Keyboard, focus, semantics, contrast, target size, zoom, motion, and screen-reader behavior
- Responsive reflow, touch behavior, content expansion, localization, and RTL when supported
- Component and token consistency without flattening intentional visual emphasis
- Perceived performance, layout stability, and interaction latency

Prioritize user blockers and confusing behavior over aesthetic taste. Distinguish objective accessibility/usability issues, verified design-system deviations, and subjective visual suggestions.

## Report

For each issue provide the affected screen/component, scenario, user impact, severity, and concrete improvement. Group recommendations into:

- Blockers
- High-value improvements
- Polish
- Validation needing user testing or product evidence

Avoid generic advice such as “improve hierarchy.” Name the element, the competing signals, and the proposed change.
