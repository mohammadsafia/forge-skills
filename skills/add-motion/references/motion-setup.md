# Motion Setup

How to install Motion, wire the app-level providers, and where shared variants live.

## Install

```bash
npm install motion
```

Import everything from `motion/react`:

```typescript
import { LazyMotion, domAnimation, m, AnimatePresence, useReducedMotion } from 'motion/react';
```

> Legacy projects on `framer-motion` import from `framer-motion` instead. All APIs below are identical.

## App-level provider: LazyMotion + MotionConfig

Wrap the app once at the root. `LazyMotion` lets feature code use the lightweight `m` component
(~5kb) instead of `motion` (~34kb). `MotionConfig reducedMotion="user"` makes every animation
automatically respect `prefers-reduced-motion`.

```tsx
import { LazyMotion, domAnimation, MotionConfig } from 'motion/react';
import { type FC, type ReactNode } from 'react';

type MotionProviderProps = {
  children: ReactNode;
};

const MotionProvider: FC<MotionProviderProps> = ({ children }) => (
  <LazyMotion features={domAnimation} strict>
    <MotionConfig reducedMotion="user">{children}</MotionConfig>
  </LazyMotion>
);

export default MotionProvider;
```

Place `<MotionProvider>` near the root (e.g. wrapping the router in `App.tsx`).

The `strict` prop on `LazyMotion` throws if any code uses the heavy `motion.*` component,
keeping the bundle small by forcing `m.*` everywhere.

### Choose the feature bundle: `domAnimation` vs `domMax`

`LazyMotion` only loads the features you give it. Pick the smallest one that covers your patterns:

| Feature pack | Size | Includes | Use when |
|--------------|------|----------|----------|
| `domAnimation` | ~17kb | animations, variants, exit (`AnimatePresence`), hover/tap/focus gestures | enter/exit, stagger, gestures, scroll reveal (§1, §2) |
| `domMax` | ~25kb | everything in `domAnimation` **plus layout animations (`layout`/`layoutId`) and drag** | you use `layout`, `layoutId`, or shared-element transitions (§3) |

> **Important:** `layout` and `layoutId` are **not** in `domAnimation`. With `strict`, they will
> silently do nothing. If any code in the app uses layout/shared-element transitions (§3), the
> root provider MUST load `domMax`:
>
> ```tsx
> import { LazyMotion, domMax, MotionConfig } from 'motion/react';
>
> <LazyMotion features={domMax} strict>
>   <MotionConfig reducedMotion="user">{children}</MotionConfig>
> </LazyMotion>;
> ```
>
> Use `domAnimation` by default; upgrade the single root provider to `domMax` only when a layout
> pattern is introduced.

## Use `m`, not `motion`

With `LazyMotion strict`, feature code MUST use `m`:

```tsx
import { m } from 'motion/react';

<m.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} />;
```

`m.div`, `m.button`, `m.ul`, `m.li` … mirror every `motion.*` element.

## Per-component reduced motion

`MotionConfig reducedMotion="user"` handles most cases automatically. When you need to
branch logic (e.g. skip a large translate but keep a fade), use the hook:

```tsx
import { m, useReducedMotion } from 'motion/react';

const shouldReduce = useReducedMotion();
const offset = shouldReduce ? 0 : 40;
```

## Where variants live

Centralize reusable variants and transition tokens in a single presets module so they are
imported via the barrel rather than redefined inline:

```
src/utils/motion/
├── presets.ts     # variants + transition tokens (see motion-presets.md)
└── index.ts       # export * from './presets'
```

```typescript
// src/utils/motion/index.ts
export * from './presets';
```

Consume them with the path alias:

```typescript
import { fadeInUp, staggerContainer, transitions } from '@utils/motion';
```
