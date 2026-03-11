# Available Form Components

## Form Component Inventory

Check `src/components/forms/` for the project's form component library. Common components:

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

All form components automatically connect to the form context via `name` prop:

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
