---
name: forge:create-form
description: "Create forms using React Hook Form + Zod + FormProvider pattern. Use when the user wants to build a form, add a create/edit form, set up form validation, or says 'create form', 'add form for', 'build edit form', 'new form with validation', 'set up form schema'. Triggers whenever form UI with validation needs to be built."
---

# Create Form

Generate forms with React Hook Form, Zod and the project's form wrapper and field components.

## Step 1 — Gather Information

Ask the user if not provided:
- **Entity name** (e.g., "User", "Order")
- **Form mode**: create-only, edit-only, or both
- **Fields**: name, type, required/optional, validation rules; any group that repeats (1..N)
- **Where it shows**: a page, a sheet or dialog, a step of a wizard
- **Submit action**: which mutation hook, and what the person sees after success and after failure

## Step 2 — Read the Project's Form Kit

1. If `kit.lock.json` exists at the repository root, the app is built on the RSK kit. Read `../_shared/rsk-kit.md`
   sections 1, 2 and 5, and the kit's `src/component-docs/guides/forms.mdx`. The facts that matter most:
   - `FormContainer` takes the `useForm` result as `formContext`, so the page or view that renders the form calls
     `useForm` itself. That is the kit's pattern, not a violation.
   - Resolver: `formResolver<Values>(schema)` from `@utils`.
   - Footer: `FormContainer.Actions` (Cancel and Submit, loading state, `confirmOnCancel`).
2. Otherwise read the project's form wrapper, its field components, and one existing form; use them.

For each field type you need, open the field's source and its test in the app to see its props and value format before
using it (RSK: `src/components/forms/<field>/`). See `references/form-components.md` for the field list and
`references/validation-patterns.md` for Zod patterns. See `../_shared/code-standards.md` section 7.

## Step 3 — Schema

- Put the schema where the project keeps feature schemas (RSK: `src/views/<feature>/schemas.ts`), not in the types folder.
- Messages are translation keys or translated text, never English literals.
- Date values: the RSK `FormDatePicker` holds an ISO date string (`'2026-03-14'`); `FormTimePicker` holds `'10:30 AM'`
  (or `'10:30'` with `use24hFormat`). Validate those shapes, and combine date and time only when sending.

## Step 4 — The Form

- One `useForm` per form, in the component that renders it, with `defaultValues` for every field (edit mode: `reset`
  with the loaded values once they arrive).
- Use the project's field components; never a raw `<input {...register()}>` when a wrapper exists.
- Choosing from a list: a fixed short list → select field (RSK `FormSelect`); a long or searchable list →
  combobox field (RSK `FormCombobox`, or `FormMultiCombobox` for several). Both take `options`, `getOptionLabel`,
  `getOptionValue`.
- Group related fields so the group has a name: a heading per part (RSK `FormSection`), and for a set of controls that
  answer one question (radio or checkbox sets, a repeated contact, an address) a `<fieldset>` with a `<legend>`, or
  `role="group"` with `aria-labelledby`. RSK `FormRadioGroup` and `FormCheckboxGroup` are named groups already.
- Repeating groups: `useFieldArray({ control: form.control, name: 'contacts' })` inside the same form. Key rows by the
  `id` it returns (never the index), name each row's fields `contacts.${index}.name`, give each row a heading or legend
  with its number ("Contact 2"), an Add button and a Remove button named with the row ("Remove contact 2"), and move
  focus to the new row's first field after Add and to a sensible place after Remove.
- Exactly one submit button per form, and it is the form's own (RSK: `FormContainer.Actions`). Every other button is
  `type="button"`, so Enter in a field submits through the intended button. In an RSK kit older than `bf12e1d`,
  `Button` defaulted to submit: check `src/components/ui/button/Button.tsx`.

## Step 5 — Submit and Feedback

```typescript
const createEntity = useCreateEntityMutation();

const handleSubmit = (values: EntityFormValues) =>
  createEntity.mutateAsync(values).then(handleSaved, (error: unknown) =>
    form.setError('root', { message: errorMessage(error, t('saveFailed')) }),
  );
```

- Field errors from the server go to their fields with `form.setError(name, …)`; others to a form-level message.
- Prevent double submission (the RSK Submit shows loading while the handler's promise runs).
- Success feedback is the page's choice (redirect, close the sheet, toast). See `forge:create-api`.

## Rules

- Follow `../_shared/code-standards.md` (sections 5, 7). Where the project's form wrapper needs `useForm` in the page or
  view, that is where it goes.
- Use existing field components; don't rebuild them.
- All labels and messages are translated (`forge:add-translations`); no `*` in labels.

## Checklist

- [ ] Form kit read first (RSK detected by `kit.lock.json`, or the project's own files)
- [ ] Schema in the feature folder; messages translated
- [ ] `useForm` in the rendering component; `defaultValues` for every field
- [ ] Project field components used; field value formats checked in their source or test
- [ ] Groups named (section heading; fieldset/legend or labelled group for sets)
- [ ] Repeating groups with `useFieldArray`, keyed by `id`, rows numbered and their buttons named
- [ ] One submit button; every other button `type="button"`
- [ ] Server errors mapped to fields or a form message; double submit prevented

## Reference Files

- `references/form-pattern.md` — Form templates for create and edit modes (generic)
- `references/validation-patterns.md` — Common Zod validation patterns
- `references/form-components.md` — Form component inventory
