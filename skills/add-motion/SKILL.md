---
name: forge:add-motion
description: "Add Motion (Framer Motion) animations to React components — enter/exit transitions, staggered lists, hover/tap/scroll gestures, layout and shared-element transitions, and page transitions. Use when the user wants to animate a component, add motion, make something fade/slide/scale in, animate a list, add a hover or tap effect, animate route changes, add page transitions, or says things like 'animate this', 'add an animation', 'make it slide in', 'add a transition', 'animate the modal', 'stagger the list', 'animate on scroll', 'shared element transition'. Enforces reduced-motion accessibility, GPU-friendly performance, RTL-aware direction, and centralized reusable variants."
---

# Add Motion

Apply Motion (the `motion` package, formerly Framer Motion) animations using the three-phase workflow: **Audit → Apply → Verify**.

Every animation produced by this skill MUST satisfy four non-negotiable standards:
1. **Reduced-motion a11y** — respect `prefers-reduced-motion` (see references/motion-setup.md)
2. **Performance** — animate `transform`/`opacity` only; lazy-load features with `LazyMotion`
3. **RTL-aware** — directional motion flips for RTL; no hardcoded `x` offsets
4. **Reusable variants** — shared variants live in a presets file, imported via barrel (never inlined)

## Step 1 — Audit

Before writing any animation, gather context.

### Check the dependency

Confirm Motion is installed:
- Look for `motion` (preferred) or `framer-motion` (legacy) in `package.json`.
- If neither exists, install it: `npm install motion`. Import from `motion/react`.
- If `framer-motion` is present, imports come from `framer-motion`; the APIs in this skill are otherwise identical.

### Check the reduced-motion baseline

Search for an existing reduced-motion setup (`useReducedMotion`, `MotionConfig`, or a `LazyMotion` provider at the app root). If none exists, you MUST add one as part of this work — see references/motion-setup.md.

### Identify the animation target

Answer these before choosing a pattern:

| Question | Why it matters |
|----------|----------------|
| Does the element mount/unmount conditionally? | Needs `AnimatePresence` |
| Is it a list/grid of items? | Needs a stagger container |
| Is it triggered by user interaction? | Needs gestures (`whileHover`/`whileTap`/`whileFocus`) |
| Should it animate when scrolled into view? | Needs `whileInView` |
| Does its size/position change in the layout? | Needs `layout` / `layoutId` |
| Is it a whole route/page? | Needs page transitions |
| Does it slide from a side (left/right)? | Must be RTL-aware |

## Step 2 — Apply

### Pattern decision tree

```
Element mounts/unmounts (modal, toast, dropdown, conditional block)?
  YES → AnimatePresence + exit variants          (patterns-catalog.md §1)

List or grid that should reveal in sequence?
  YES → stagger container + item variants         (patterns-catalog.md §1)

Driven by hover / tap / focus / scroll-into-view?
  YES → gesture props (whileHover/Tap/Focus/InView) (patterns-catalog.md §2)

Element resizes, reorders, or moves between positions?
  YES → layout prop; shared element → layoutId      (patterns-catalog.md §3)

Animating between routes on navigation?
  YES → page transition wrapper + React Router      (patterns-catalog.md §4)
```

### Rules while applying

- **Centralize variants.** Pull from or add to the presets file (references/motion-presets.md). Never inline a variant object that could be reused.
- **Use `m` + `LazyMotion`, not `motion`,** in feature code to keep the bundle small (see references/motion-setup.md). Use `motion.*` only in throwaway prototypes.
- **Slide direction must be RTL-safe.** Use the direction-aware presets (`slideIn`) rather than a literal `x: -40`. See references/violations-and-fixes.md.
- **Animate transform/opacity only** — `x`, `y`, `scale`, `rotate`, `opacity`. Never animate `width`, `height`, `top`, `left`, `margin` (use `layout` for size/position changes instead).
- **Reduced motion** — gate distance/scale changes behind `useReducedMotion()`, or wrap the tree in `MotionConfig reducedMotion="user"`.

## Step 3 — Verify

Run this checklist before finishing. Full correct/incorrect examples are in references/violations-and-fixes.md.

- [ ] Only `transform`/`opacity` properties are animated (no `width`/`height`/`top`/`left`/`margin`)
- [ ] `prefers-reduced-motion` is respected (`useReducedMotion` or `MotionConfig reducedMotion="user"`)
- [ ] Directional/slide animations flip for RTL (no hardcoded `x: -N`)
- [ ] Reused variants are imported from the presets file, not inlined
- [ ] `LazyMotion` is in place and feature code uses `m.*` not `motion.*`; the feature pack is `domMax` if any `layout`/`layoutId` is used, otherwise `domAnimation`
- [ ] Every conditionally-rendered element that animates out is inside `AnimatePresence`, using raw `{cond && …}` (not `Conditional.If`) so exit is detected
- [ ] Elements inside `AnimatePresence` have a stable, unique `key`
- [ ] Transitions use shared duration/easing tokens, not magic numbers
- [ ] No `import type` needed for runtime values; imports come from barrels/path aliases

## Reference Files

- `references/motion-setup.md` — install, `LazyMotion` provider, `MotionConfig`, presets file location
- `references/motion-presets.md` — reusable variants & transition tokens (the source of truth)
- `references/patterns-catalog.md` — the four use-case templates
- `references/violations-and-fixes.md` — correct/incorrect examples for each standard
