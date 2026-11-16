# Testing an App Built on the RSK Kit

Facts checked against the kit at commit `bf12e1d`. Before relying on one, open the kit's own test for the component you
drive (it sits beside the component in `src/components/**`): it is the working example.

## Per-file setup

```tsx
// @vitest-environment happy-dom
import { act, cleanup, fireEvent, render, screen, waitFor, within } from '@testing-library/react';
import { afterEach, describe, expect, it, vi } from 'vite-plus/test';

import i18n from '../../i18n'; // the app's i18n setup, so t() returns real copy

afterEach(async () => {
  cleanup();
  await act(() => i18n.changeLanguage('en'));
});
```

- Import test functions from `vite-plus/test`, not `vitest`. Run with `vp test <path>`.
- One field in isolation: wrap it in `FormHarness` from `src/test-utils/FormHarness.tsx` (form, query client, tooltip
  provider, optional pre-set errors).
- A kit part that links or navigates: wrap it in `MemoryKitRouter` from `src/lib/contexts/testing.tsx`.

## A whole-app render helper

Page tests render the real app: routes, `AuthGuard`, the shell, providers. The starter does not ship this helper. If
the app has one (often `src/test-utils/renderApp.tsx`), use it. If not, add it once, with a test of its own:

1. In `src/routes/router.tsx`, export the route array (for example `APP_ROUTES`) and build the browser router from it,
   so a test can build a memory router from the same routes.
2. In `src/bootstrap.tsx`, export the provider tree (theme, query client, direction, motion, nuqs, tooltip, auth, kit
   router adapter) as one component that takes a `client`, so tests and the app share it.
3. The helper:

```tsx
import { configure, render } from '@testing-library/react';
import { createMemoryRouter, RouterProvider } from 'react-router';
import { vi } from 'vite-plus/test';

import { createQueryClient } from '@api/config';
import { APP_ROUTES } from '@routes/router';

import { AppProviders } from '../bootstrap';

/** One findBy/waitFor. Pages load lazily, so the first lookup also waits for the page's code. */
export const WAIT_TIMEOUT_MS = 5000;
/** One test. Well above the wait, so a failed wait reports its own message, not a timeout. */
export const TEST_TIMEOUT_MS = 15_000;

configure({ asyncUtilTimeout: WAIT_TIMEOUT_MS });
vi.setConfig({ testTimeout: TEST_TIMEOUT_MS });

export function renderApp(path = '/') {
  const router = createMemoryRouter(APP_ROUTES, { initialEntries: [path] });
  const result = render(
    <AppProviders client={createQueryClient()}>
      <RouterProvider router={router} />
    </AppProviders>,
  );
  return Object.assign(result, { router });
}
```

4. Network: replace the adapter of the app's axios instance (`AxiosInstance.defaults.adapter` from
   `@api/config/AxiosInstance`) with one that answers listed paths, records every request (method, path, body), and
   refuses any path the test did not list. End a test with "no unexpected requests".
5. Signed-in state: put a session in `localStorage` under `SESSION_KEY` (from `@contexts`) before rendering, or answer
   the app's "who am I" request, whichever the app's `AuthProvider` reads. `beforeEach(() => localStorage.clear())`.
6. Add a test for the helper itself: the wait is below the test limit, an unlisted request is refused.

## Driving the kit's fields

Find a field by its label, which the kit wires to the control. A required field's label carries a marker, so match
the name with a regular expression (`/^Site/`) or the exact visible text.

| Field | Role and name | How to set a value |
|---|---|---|
| `FormInput`, `FormTextarea` | `textbox`, the label | `fireEvent.change(box, { target: { value: 'Text' } })` |
| `FormCombobox` (searchable) | `combobox`, the label | `fireEvent.click(combobox)`, then `fireEvent.click(await screen.findByRole('option', { name: 'Site B' }))` |
| `FormSelect` (Radix Select) | `combobox`, the label | open it as the kit's `Select.test.tsx` does (Radix opens on pointer down or keyboard, not every `click`), then click the `option` |
| `FormDatePicker` | `textbox`, the label | type the display format: `fireEvent.change(box, { target: { value: '03/14/2026' } })`; the form value is `'2026-03-14'`; seed with the ISO string |
| `FormTimePicker` | `combobox`, the label | click it; in `listbox` "Hours" click the `option` `'10'`, in "Minutes" click `'30'`, then the `button` "Confirm"; the value is `'10:30 AM'` (or `'10:30'` with `use24hFormat`) |
| `FormRadioGroup`, `FormCheckboxGroup` | `radio` / `checkbox` inside a named group | `fireEvent.click` the option |

Use `within(dialog)` when a sheet or dialog is open, so a field of the page behind it is not matched.

Submitting: click the form's own Submit (`FormContainer.Actions`, default name "Save"), or test Enter as the kit's
`form-implicit-submit.test.tsx` does (happy-dom does not perform implicit submission by itself).

## Toasts

`useToast` keeps its state in a module, outside React. `cleanup()` unmounts the `Toaster` but keeps the toast, which is
removed only after a delay, and the next test's `Toaster` shows it again. So:

- assert that a toast appeared by its text, right after the action;
- never assert that a toast is absent;
- the `Toaster` is mounted only inside the signed-in shell: a page rendered on its own shows no toast at all.

## Focus and keyboard

- After closing a sheet or dialog, assert where focus went (`document.activeElement`). Since kit `bf12e1d` it returns to
  the element that opened it, also when opened by state; when that element is gone, the page must choose.
- After navigating, assert focus is on the new page's heading if the app's layout moves it.
- A sheet may not listen for Escape on its first frame: wait until the dialog is found before pressing Escape.

## Commands

`vp test <file>` for one file; `vp test` for everything (the kit's own checks included: a full run takes minutes, not
seconds). Do not run the front-end suite beside another heavy suite on the same machine when timing matters.
