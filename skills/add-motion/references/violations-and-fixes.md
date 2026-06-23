# Violations & Fixes

Correct/incorrect pairs for the four mandatory standards. Use these to verify (Step 3) and
to teach the fix.

---

## 1. Performance — animate transform/opacity only

Animating layout properties (`width`, `height`, `top`, `left`, `margin`, `padding`) triggers
layout + paint on every frame and janks. Animate `transform`/`opacity`, or use `layout` for
size/position changes.

❌ **Incorrect**

```tsx
<m.div animate={{ width: 320, height: 200, marginTop: 24 }} />
```

✅ **Correct**

```tsx
// Reveal with transform/opacity…
<m.div animate={{ scale: 1, opacity: 1 }} />

// …or let Motion handle a real size change via the layout prop:
<m.div layout />
```

---

## 2. Bundle size — LazyMotion + `m`, not `motion`

Importing `motion` pulls the full feature set (~34kb) into the bundle. With `LazyMotion`
`domAnimation` + `m`, it drops to ~5kb.

❌ **Incorrect**

```tsx
import { motion } from 'motion/react';

<motion.div animate={{ opacity: 1 }} />;
```

✅ **Correct**

```tsx
// Root (once):
<LazyMotion features={domAnimation} strict>{app}</LazyMotion>

// Feature code:
import { m } from 'motion/react';

<m.div animate={{ opacity: 1 }} />;
```

---

## 3. Reduced-motion accessibility

Animations must honor `prefers-reduced-motion`. Either set it globally with `MotionConfig`
or branch with `useReducedMotion`.

❌ **Incorrect**

```tsx
// Always animates a large translate, ignoring the user's OS setting.
<m.div initial={{ y: 80, opacity: 0 }} animate={{ y: 0, opacity: 1 }} />
```

✅ **Correct (global)**

```tsx
<MotionConfig reducedMotion="user">
  <App />
</MotionConfig>
```

✅ **Correct (per-component branch)**

```tsx
const shouldReduce = useReducedMotion();
<m.div
  initial={{ y: shouldReduce ? 0 : 80, opacity: 0 }}
  animate={{ y: 0, opacity: 1 }}
/>;
```

---

## 4. RTL-aware direction

A hardcoded `x` offset slides the wrong way in RTL layouts. Derive the offset from document
direction (use the `slideIn(dir)` preset).

❌ **Incorrect**

```tsx
// Always slides in from the left, even in RTL where it should come from the right.
<m.div initial={{ x: -40, opacity: 0 }} animate={{ x: 0, opacity: 1 }} />
```

✅ **Correct**

```tsx
import { slideIn } from '@utils/motion';

const dir = useDirection(); // 'ltr' | 'rtl'
<m.div variants={slideIn(dir)} initial="hidden" animate="visible" />;
```

Also prefer logical CSS positioning (`start-*`/`end-*`) over `left-*`/`right-*` on animated
elements.

---

## 5. Reusable variants — centralize, don't inline

Re-declaring the same variant object across files drifts out of sync. Define it once in the
presets module and import via the barrel.

❌ **Incorrect**

```tsx
// Repeated in five components, each slightly different.
<m.div
  initial={{ opacity: 0, y: 16 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.25 }}
/>
```

✅ **Correct**

```tsx
import { fadeInUp } from '@utils/motion';

<m.div variants={fadeInUp} initial="hidden" animate="visible" />;
```

---

## 6. AnimatePresence — exit animations & keys

An element that animates out must be inside `AnimatePresence`, and each child needs a stable
unique `key`, or the exit animation is skipped / janky.

❌ **Incorrect**

```tsx
// No AnimatePresence → exit variant never runs; element just disappears.
{open && <m.div exit={{ opacity: 0 }}>…</m.div>}
```

✅ **Correct**

```tsx
<AnimatePresence>
  {open && (
    <m.div key="panel" variants={fade} initial="hidden" animate="visible" exit="exit">
      …
    </m.div>
  )}
</AnimatePresence>
```

> **Exception to the `Conditional.If` house rule.** Inside `AnimatePresence`, use the raw
> `{open && …}` form. `AnimatePresence` tracks unmounts by diffing the keys of its direct
> children — a `Conditional.If` wrapper is always mounted (it returns `null` internally), so the
> animating child never appears to leave and `exit` never runs. This is the one place `&&` is
> required over `Conditional.If`.
