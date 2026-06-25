# Motion Presets

The source of truth for reusable variants and transition tokens. Anything used in more than
one place lives here and is imported via `@utils/motion` — never re-declared inline.

All presets animate **transform/opacity only** and are **RTL-safe** (directional ones take a
direction argument instead of hardcoding `x`).

## Transition tokens

Shared durations and easings. Use these instead of magic numbers.

```typescript
import { type Transition } from 'motion/react';

export const transitions = {
  fast: { duration: 0.15, ease: 'easeOut' },
  base: { duration: 0.25, ease: 'easeOut' },
  slow: { duration: 0.4, ease: 'easeInOut' },
  spring: { type: 'spring', stiffness: 400, damping: 30 },
  springSoft: { type: 'spring', stiffness: 200, damping: 25 },
} satisfies Record<string, Transition>;
```

## Fade / slide variants

All variants below live in the same `presets.ts` as the `transitions` tokens above, so they
reference `transitions.*` directly — no cross-file import needed.

```typescript
import { type Variants } from 'motion/react';

export const fade: Variants = {
  hidden: { opacity: 0 },
  visible: { opacity: 1, transition: transitions.base },
  exit: { opacity: 0, transition: transitions.fast },
};

export const fadeInUp: Variants = {
  hidden: { opacity: 0, y: 16 },
  visible: { opacity: 1, y: 0, transition: transitions.base },
  exit: { opacity: 0, y: 16, transition: transitions.fast },
};

export const scaleIn: Variants = {
  hidden: { opacity: 0, scale: 0.96 },
  visible: { opacity: 1, scale: 1, transition: transitions.spring },
  exit: { opacity: 0, scale: 0.96, transition: transitions.fast },
};
```

## RTL-safe directional slide

Never hardcode a slide offset — derive it from document direction so it flips for RTL.
Read direction once (e.g. from your i18n/dir context) and pass it in.

```typescript
import { type Variants } from 'motion/react';

type Dir = 'ltr' | 'rtl';

// distance is the LOGICAL "from the start edge" offset; sign flips for RTL.
export const slideIn = (dir: Dir, distance = 40): Variants => {
  const x = dir === 'rtl' ? distance : -distance;
  return {
    hidden: { opacity: 0, x },
    visible: { opacity: 1, x: 0, transition: transitions.base },
    exit: { opacity: 0, x, transition: transitions.fast },
  };
};
```

Usage:

```tsx
import { useDirection } from '@hooks'; // your existing dir source

const dir = useDirection(); // 'ltr' | 'rtl'
<m.div variants={slideIn(dir)} initial="hidden" animate="visible" exit="exit" />;
```

## Stagger container + item

The container orchestrates children via `staggerChildren`; items use any item variant
(e.g. `fadeInUp`). Variant **names** must match between container children and items.

```typescript
import { type Variants } from 'motion/react';

export const staggerContainer: Variants = {
  hidden: {},
  visible: {
    transition: { staggerChildren: 0.06, delayChildren: 0.04 },
  },
};
```

## Gesture presets

```typescript
import { type TargetAndTransition } from 'motion/react';

export const tapScale: TargetAndTransition = { scale: 0.97 };
export const hoverLift: TargetAndTransition = { y: -2, scale: 1.02 };
```

## Rules

- Every preset animates `transform`/`opacity` only.
- Directional presets are **functions** that take `dir` — there are no hardcoded `x: -N` constants.
- Variant state names are consistent: `hidden` / `visible` / `exit`.
- Transitions reference `transitions.*` tokens, not inline numbers.
- Export everything through `@utils/motion` so consumers import from the barrel.
