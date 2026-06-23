---
name: forge:create-form
description: "Create forms using React Hook Form + Zod + FormProvider pattern. Use when the user wants to build a form, add a create/edit form, set up form validation, or says 'create form', 'add form for', 'build edit form', 'new form with validation', 'set up form schema'. Triggers whenever form UI with validation needs to be built."
---

# Create Form

Generate forms using the FormProvider + React Hook Form + Zod pattern.

## Step 1 — Gather Information

Ask the user if not provided:
- **Entity name** (e.g., "User", "Order", "Community")
- **Form mode**: create-only, edit-only, or dual (create + edit)
- **Fields**: name, type, required/optional, validation rules
- **Submit action**: which mutation hook to use

## Step 2 — Scan Existing Patterns

Before writing code, read:
1. The project's form components: `src/components/forms/form-container/FormContainer.tsx`
2. Field components: `form-input/FormInput.tsx`, `form-select/FormSelect.tsx`, `form-checkbox/FormCheckbox.tsx`, `form-date-picker/FormDatePicker.tsx`, `form-textarea/FormTextarea.tsx`
3. An existing form in `src/views/` for wiring patterns
4. Shared submit buttons: `src/components/shared/form-submit-button/FormSubmitButton.tsx`

See `references/form-pattern.md` for the form template.
See `references/validation-patterns.md` for Zod patterns.
See `_shared/code-standards.md` for all project rules.

## Step 3 — Generate Files

### 3a. Create Zod Schema

File: `src/views/<feature>/Feature.schemas.ts`

Schemas live with the feature, NOT in `src/types/`:
```typescript
import { z } from 'zod';

export const entityFormSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Invalid email'),
  description: z.string().optional(),
});

export type EntityFormValues = z.infer<typeof entityFormSchema>;
```

### 3b. Create Form Component

File: `src/views/<feature>/entity-form/EntityForm.tsx`

The form MUST use the reusable Form component with FormProvider — never manage form state with raw React Hook Form in the view.

### 3c. Wire to Mutation

Connect the form's `onSubmit` to the mutation hook:
```typescript
const createEntityMutation = useCreateEntityMutation();

const handleSubmit = async (values: EntityFormValues) => {
  await createEntityMutation.mutateAsync(values);
};
```

### 3d. Update Barrel Exports

Add exports to the feature's `index.ts`.

## Rules

See `_shared/code-standards.md` for all project rules (sections 5, 7). Form-specific rules:

- All forms use `FormProvider`-based `FormContainer` — no raw `useForm` in pages
- Use existing form field wrappers (`FormInput`, `FormSelect`, etc.) — don't rebuild
- Zod schema in `src/views/<feature>/Feature.schemas.ts`
- Guard optional callbacks with `Conditional.If`
- All validation messages use `t()` translation keys

## Reference Files

- `references/form-pattern.md` — Form templates for create and edit modes
- `references/validation-patterns.md` — Common Zod validation patterns
- `references/form-components.md` — Available form component inventory
