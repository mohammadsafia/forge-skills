# Available Form Components

## Form Component Inventory

Check the project's form component folder (often `src/components/forms/`) before using any name below.

In an RSK app (`kit.lock.json` at the root) the fields are: `FormInput`, `FormTextarea`, `FormNumber`, `FormSelect`,
`FormCombobox`, `FormMultiCombobox`, `FormCheckbox`, `FormCheckboxGroup`, `FormRadioGroup`, `FormDatePicker`,
`FormDateRange`, `FormTimePicker`, `FormChipInput`, `FormFileUploader`, with `FormSection` and `FormWizard` around them,
all from `@components/forms`, inside `FormContainer`. There is no `FormSwitch` or `FormFileUpload`. Option fields take
`options`, `getOptionLabel`, `getOptionValue`. See `../../_shared/rsk-kit.md` section 5.

Generic inventory (names vary by project):

| Component | Purpose | Key Props |
|-----------|---------|-----------|
| `FormInput` | Text/number input | `name`, `label`, `type`, `placeholder`, `required` |
| `FormTextarea` | Multi-line text | `name`, `label`, `rows`, `placeholder`, `required` |
| `FormSelect` | Dropdown select | `name`, `label`, `options`, `placeholder`, `required` |
| `FormCheckbox` | Checkbox input | `name`, `label` |
| `FormSwitch` | Toggle switch | `name`, `label` |
| `FormDatePicker` | Date picker | `name`, `label`, `required` |
| `FormFileUpload` | File upload | `name`, `label`, `accept`, `maxSize` |
| `FormRadioGroup` | Radio buttons | `name`, `label`, `options`, `required` |

## Usage with FormProvider

All form components connect to the form context through the `name` prop. RSK apps wrap them in
`<FormContainer formContext={form} onSuccess={handleSubmit}>` instead of the raw provider below:

```tsx
<FormProvider {...methods}>
  <form onSubmit={methods.handleSubmit(handleSubmit)}>
    <FormInput
      name="name"
      label={t('name')}
      placeholder={t('enter_name')}
      required
    />
    <FormSelect
      name="status"
      label={t('status')}
      options={statusOptions}
      required
    />
    <FormTextarea
      name="description"
      label={t('description')}
      rows={4}
    />
  </form>
</FormProvider>
```

## Key Rules

- The `required` prop renders the required indicator — never add `*` to labels
- Form components get their error messages from the Zod schema automatically
- No manual `register()` calls needed
- Check actual project form components before building — scan `src/components/forms/`
