---
name: forge:audit-a11y
description: "Audit components for accessibility issues — ARIA, keyboard navigation, focus management, screen readers. Use when the user asks about accessibility, a11y, ARIA, or says 'check accessibility', 'is this accessible', 'audit a11y', 'add aria labels'. Also triggers when reviewing interactive UI components."
---

# Audit Accessibility

Find accessibility defects in code, with file:line references and fixes, and say plainly what a code audit could not
check. A static audit does not replace a keyboard walk: the faults that hurt most (where focus goes after an action,
which button Enter presses) only show when the screen is used.

## Step 1 — Read the Project

- Its component kit, focus utilities, design tokens and stated rules (`AGENTS.md`, `docs/design.md` or similar: a
  touch-target size, a contrast target).
- If `kit.lock.json` exists at the repository root, the app is built on the RSK kit: read `../_shared/rsk-kit.md`
  sections 3, 5, 8 and 9. Prescribe the kit's own utilities and tokens (`focus-ring`, `focus-ring-input`,
  `state-invalid`, `h-control-*`, `text-fg-muted` …); never invent class recipes or token names the project does not
  have. Audit the app's code; a defect inside a kit component is reported as a kit defect, not patched in the app.

## Step 2 — Names, Roles and Structure

1. Icon-only buttons and links have an accessible name (`aria-label`, or a visually hidden text).
2. No clickable `div`/`span`: use a `button` or a link. (A `role="button"` element needs `tabIndex={0}` and both
   Enter and Space handling; prefer the real element.)
3. Images have `alt` (`alt=""` when decorative).
4. Every form control has a label linked to it.
5. Related controls are a named group: a `<fieldset>` with a `<legend>`, or `role="group"`/`radiogroup` with
   `aria-labelledby` (radio and checkbox sets, a repeated block such as "Contact 2", an address).
6. One `h1` per page; headings in order; one `main` landmark (the RSK shell renders it; a page must not add another).
7. Tables have a name (caption or label); row actions are named with their row.
8. Information shown by colour alone also has text or an icon.
9. When wrapping Radix primitives, leave ARIA, focus and keyboard to Radix.

## Step 3 — Focus

1. **Visible focus**: every interactive element shows focus with the project's utility (RSK: `focus-ring`).
2. **Route change**: after following a link inside the app, focus moves to the new page's heading (or `main`). Check
   the app's layout; the RSK kit does not do it by itself. If nothing moves focus, it stays on the link of a page that
   is gone: report it.
3. **Sheets and dialogs opened by state** (a row action, a menu item, after a request): when they close, focus returns
   to what opened them, or to a deliberate place when that is gone (a deleted row → the list heading or the next row).
   Radix returns focus only to its own `Trigger`. RSK kit `bf12e1d` and later do this for `Dialog` and `Sheet`
   (`useReturnFocusOnClose` exists in `src/components/ui/dialog/`); in an older kit, or a custom overlay, check each
   one.
4. **After a change on the page** (a row removed, a form saved and closed, a message shown in place), focus lands on
   something that explains the result, not on `body`.

## Step 4 — Forms and the Keyboard

1. **Default button**: pressing Enter in a text field clicks the form's first submit button in tree order. Every button
   in a form other than its submit (a date field's clear button, a show-password toggle, "Add another") must be
   `type="button"`. RSK kit `bf12e1d` and later make `Button`/`IconButton` default to `type="button"`; check
   `src/components/ui/button/Button.tsx` for older kits and check raw `<button>` elements always.
2. Errors are linked to their fields (`aria-invalid`, `aria-describedby`) and announced; the first invalid field takes
   focus on submit.
3. Disabled controls look disabled through the project's own style (the RSK kit uses its disabled field look, not
   opacity) and are not the only way to explain why an action is unavailable.

## Step 5 — Size, Contrast, Motion

1. **Target size**: interactive targets meet the project's stated size; with none stated, at least 24 × 24 CSS px
   (WCAG 2.5.8), and the project's touch size on coarse pointers. RSK control heights are 28 / 32 / 40 px
   (`h-control-sm|md|lg`): a 28 px control on a touch screen fails a 40 px project rule.
2. Contrast comes from tokens checked by the project (RSK: `contrast.test.ts`); flag only text placed on surfaces the
   test does not cover, or literal colours.
3. Motion respects reduced-motion settings.

## Step 6 — Run What the Project Already Checks

RSK: `vp test tests/design-system` (icon-button labels, contrast, code standards) and, when a browser is installed,
`pnpm a11y:audit` (axe over every page, light and dark, English and Arabic). Report their results; do not re-report what
they already catch.

## Step 7 — The Keyboard Walk

When a browser is available, walk each changed screen with the keyboard only, and record what happened:

1. Tab from the top of the page to the end: every stop visible, in reading order, nothing unreachable, no trap.
2. Follow a sidebar link with Enter: where is focus on the new page?
3. Open each sheet, dialog and menu with the keyboard; close it with Escape and with its buttons: where is focus?
4. In each form, press Enter in a text field: which button acted? Submit with an error: where is focus?
5. Repeat at phone width and in Arabic.

When no browser is available, write these steps for a person under "Not verified".

## Report Format

```markdown
## Accessibility Audit

### Errors
- `OrderPage.tsx:25` — icon button without a name → `aria-label={t('edit', { name })}`
- `OrderSheet.tsx:40` — sheet opened from a row menu; focus is lost on close → return it to the row's menu button

### Warnings
- `Filters.tsx:60` — 28 px control in a touch layout; project rule is 40 px

### Checked by the project's tools
- vp test tests/design-system: …; pnpm a11y:audit: run / not run

### Not verified (needs the keyboard walk)
- focus after route change on …; Enter in the … form; …

### Summary
X errors, Y warnings, Z items not verified
```
