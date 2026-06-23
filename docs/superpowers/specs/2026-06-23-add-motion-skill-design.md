# Design: `forge:add-motion` skill

**Date:** 2026-06-23
**Status:** Approved

## Purpose

Add a single `forge:add-motion` skill that teaches Claude to apply Motion (formerly
Framer Motion, the `motion` package) animations to React 19 + TypeScript components,
following the same Audit → Apply → Verify workflow used by other forge skills.

## Decisions

- **Library:** Motion (`motion` package, `motion/react`). Not CSS-first, not GSAP.
- **Scope:** One skill, `forge:add-motion`. No separate audit skill.
- **Use-cases covered (all four):**
  1. Enter/exit + staggered lists (`AnimatePresence`)
  2. Gestures & micro-interactions (`whileHover`/`whileTap`/`whileFocus`/`whileInView`)
  3. Layout & shared-element transitions (`layout`, `layoutId`)
  4. Page transitions with React Router 6
- **Mandatory standards (all four):**
  1. Reduced-motion a11y (`useReducedMotion` / `MotionConfig`)
  2. Performance (transform/opacity only, `LazyMotion` + `domAnimation`)
  3. RTL-aware motion (direction-flipped, no hardcoded `x` offsets)
  4. Reusable variants centralized in a presets file, barrel-imported

## File Structure

```
skills/add-motion/
├── SKILL.md
└── references/
    ├── motion-setup.md          # install, LazyMotion provider, MotionConfig, presets file
    ├── motion-presets.md        # reusable variants/transitions catalog (source of truth)
    ├── patterns-catalog.md      # the 4 use-cases as copy-paste templates
    └── violations-and-fixes.md  # correct/incorrect examples (mirrors review-code style)
```

## SKILL.md workflow

Three phases:

1. **Audit** — detect Motion install; check for reduced-motion setup; identify what is
   being animated; pick the pattern via a decision tree.
2. **Apply** — pull the matching template from references; centralize variants in the
   presets file; wire `LazyMotion`/`m` where appropriate.
3. **Verify** — checklist: transform/opacity only, reduced-motion respected, RTL
   direction flipped, variants centralized, lazy features used.

## Integration

- Add `forge:add-motion` to the `forge:forge` router catalog as a Layer 3 (UI) skill,
  with trigger signals (technical/casual/problem).
- `add-translations` auto-add does **not** apply (motion adds no user-facing text).

## Non-goals (YAGNI)

- No separate `audit-motion` skill (verification lives in SKILL.md).
- No CSS/Tailwind-only animation path.
- No page-transition skill split out — it is one pattern in the catalog.
