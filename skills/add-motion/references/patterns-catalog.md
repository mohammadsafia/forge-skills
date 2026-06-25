# Patterns Catalog

Copy-paste templates for the four use-cases. All examples use `m` (with `LazyMotion` at the
root — see motion-setup.md), pull variants from `@utils/motion`, and respect reduced motion.

---

## §1 — Enter/exit & staggered lists

### Enter/exit (modal, toast, conditional block)

Anything that mounts/unmounts conditionally must live inside `AnimatePresence` so its `exit`
variant runs before it leaves the DOM.

```tsx
import { AnimatePresence, m } from 'motion/react';

import { fadeInUp } from '@utils/motion';

type ToastProps = {
  open: boolean;
  message: string;
};

const Toast: FC<ToastProps> = ({ open, message }) => (
  <AnimatePresence>
    {open && (
      <m.div
        key="toast"
        data-slot="toast"
        variants={fadeInUp}
        initial="hidden"
        animate="visible"
        exit="exit"
        className="fixed bottom-4 end-4 rounded-lg bg-tokens-neutral p-4 shadow-md"
      >
        {message}
      </m.div>
    )}
  </AnimatePresence>
);
```

Notes:
- Each `AnimatePresence` child needs a **stable, unique `key`**.
- Use `end-4` (logical) not `right-4` so positioning is RTL-safe.
- **`AnimatePresence` is the one place to use raw `{cond && …}`, not `Conditional.If`.**
  `AnimatePresence` detects unmounts by diffing the keys of its **direct children**; a
  `Conditional.If` wrapper is always present (it returns `null` internally), so the child never
  appears to leave and the `exit` variant never runs. Keep the conditional inline here.

### Staggered list

The `ul` is the stagger container; each `li` plays an item variant. Reveal on mount, or on
scroll with `whileInView` (see §2).

```tsx
import { m } from 'motion/react';

import { staggerContainer, fadeInUp } from '@utils/motion';

type ItemListProps = {
  items: Array<{ id: string; label: string }>;
};

const ItemList: FC<ItemListProps> = ({ items }) => (
  <m.ul
    data-slot="item-list"
    variants={staggerContainer}
    initial="hidden"
    animate="visible"
    className="flex flex-col gap-2"
  >
    {items.map((item) => (
      <m.li key={item.id} variants={fadeInUp} data-slot="item-list-item">
        {item.label}
      </m.li>
    ))}
  </m.ul>
);
```

---

## §2 — Gestures & micro-interactions

`whileHover` / `whileTap` / `whileFocus` are local interaction states. `whileInView` triggers
when the element scrolls into view.

```tsx
import { m } from 'motion/react';

import { hoverLift, tapScale, transitions } from '@utils/motion';

const AnimatedCard: FC<{ children: ReactNode }> = ({ children }) => (
  <m.div
    data-slot="animated-card"
    whileHover={hoverLift}
    whileTap={tapScale}
    transition={transitions.spring}
    className="rounded-lg border border-tokens-outline bg-background p-4"
  >
    {children}
  </m.div>
);
```

Scroll-triggered reveal (animates once when 30% visible):

```tsx
import { m } from 'motion/react';

import { fadeInUp } from '@utils/motion';

<m.section
  variants={fadeInUp}
  initial="hidden"
  whileInView="visible"
  viewport={{ once: true, amount: 0.3 }}
/>;
```

For interactive **buttons/links**, keep gestures subtle and pair with focus styles —
`whileFocus` should mirror `whileHover` so keyboard users get the same affordance.

---

## §3 — Layout & shared-element transitions

> **Requires `domMax`.** `layout` and `layoutId` are not part of `domAnimation`. Before using
> these patterns, upgrade the root `LazyMotion` provider to `features={domMax}` (see
> motion-setup.md) — otherwise, with `strict`, they silently do nothing.

### Auto-animate size/position changes with `layout`

When an element resizes or reorders, the `layout` prop animates the change for you — without
animating `width`/`height` directly (Motion uses transforms under the hood).

```tsx
import { m } from 'motion/react';

import { Conditional } from '@components/shared';

const Accordion: FC<{ open: boolean; children: ReactNode }> = ({ open, children }) => (
  <m.div layout data-slot="accordion" className="overflow-hidden rounded-lg border">
    <Conditional.If condition={open}>
      <m.div layout="position">{children}</m.div>
    </Conditional.If>
  </m.div>
);
```

### Shared element with `layoutId`

Two elements with the same `layoutId` animate from one to the other across mount/unmount —
ideal for thumbnail → detail, tab indicators, etc.

```tsx
import { m } from 'motion/react';

// Active tab underline that slides between tabs:
{tabs.map((tab) => (
  <button key={tab.id} className="relative px-3 py-2">
    {tab.label}
    <Conditional.If condition={tab.id === activeId}>
      <m.span
        layoutId="tab-underline"
        data-slot="tab-underline"
        className="absolute inset-x-0 bottom-0 h-0.5 bg-tokens-primary"
      />
    </Conditional.If>
  </button>
))}
```

Reordering lists: give each item `layout` and a stable `key`; Motion animates position swaps.

---

## §4 — Page transitions (React Router 6)

Animate route changes by keying `AnimatePresence` on the current location. Use `mode="wait"`
so the outgoing page finishes its exit before the next enters.

```tsx
import { AnimatePresence, m } from 'motion/react';
import { useLocation, useOutlet } from 'react-router-dom';

import { fade } from '@utils/motion';

const AnimatedOutlet: FC = () => {
  const location = useLocation();
  const outlet = useOutlet();

  return (
    <AnimatePresence mode="wait">
      <m.main
        key={location.pathname}
        data-slot="page"
        variants={fade}
        initial="hidden"
        animate="visible"
        exit="exit"
      >
        {outlet}
      </m.main>
    </AnimatePresence>
  );
};
```

Use `<AnimatedOutlet />` in place of `<Outlet />` inside the layout route. Keep page
transitions short (`transitions.fast`/`base`) — long route animations feel sluggish.

> `useOutlet()` snapshots the current outlet so the exiting page keeps rendering during its
> exit animation; a plain `<Outlet />` would unmount immediately and skip the exit.
