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

Before writing code, read these files:
1. An existing form in `src/views/` that uses the reusable Form component
2. Existing form components in `src/components/forms/`
3. An existing Zod schema in a `views/<feature>/schemas.ts` file
4. The mutation hook that will handle submission

See `references/form-pattern.md` for the complete form template.
See `references/validation-patterns.md` for Zod validation examples.
See `references/form-components.md` for available form components.

## Step 3 — Generate Files

### 3a. Create Zod Schema

File: `src/views/<feature>/schemas.ts`

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
const { mutateAsync } = useCreateEntityMutation();

const handleSubmit = async (values: EntityFormValues) => {
  await mutateAsync(values);
};
```

### 3d. Update Barrel Exports

Add exports to the feature's `index.ts`.

## Rules

- All forms use the reusable Form component (FormProvider-based)
- Zod schemas in `src/views/<feature>/schemas.ts`, never in `src/types/`
- Use `import type` for Zod-inferred types when importing elsewhere
- Inputs integrate through existing form components
- No manual `register()` calls — use the form component abstraction
- Do not add asterisks to translation labels — use `required` prop
- Debounce search inputs (300ms) that trigger API calls

## Reference Files

- `references/form-pattern.md` — Form templates for create and edit modes
- `references/validation-patterns.md` — Common Zod validation patterns
- `references/form-components.md` — Available form component inventory
