# Form Pattern Templates

## Create Form

```typescript
// src/views/<feature>/entity-form/EntityForm.tsx

import { useForm, FormProvider } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';

import { Button } from '@components/ui';

import { Conditional } from '@components/shared';

import { useAppTranslation } from '@hooks/shared';
import { useCreateEntityMutation } from '@hooks/mutations';

import type { EntityFormValues } from '../schemas';
import { entityFormSchema } from '../schemas';

type EntityFormProps = {
  onSuccess?: () => void;
  onCancel?: () => void;
};

export default function EntityForm({ onSuccess, onCancel }: EntityFormProps) {
  const { t } = useAppTranslation('entity');
  const createMutation = useCreateEntityMutation();

  const methods = useForm<EntityFormValues>({
    resolver: zodResolver(entityFormSchema),
    defaultValues: {
      name: '',
      description: '',
    },
  });

  const handleSubmit = async (values: EntityFormValues) => {
    await createMutation.mutateAsync(values);
    onSuccess?.();
  };

  return (
    <FormProvider {...methods}>
      <form onSubmit={methods.handleSubmit(handleSubmit)} className="space-y-4">
        {/* Use project's reusable form components here */}

        <div className="flex justify-end gap-3">
          <Conditional.If condition={!!onCancel}>
            <Button type="button" variant="outline" onClick={onCancel}>
              {t('cancel')}
            </Button>
          </Conditional.If>
          <Button type="submit" disabled={createMutation.isPending}>
            {t('create')}
          </Button>
        </div>
      </form>
    </FormProvider>
  );
}
```

## Edit Form

```typescript
// src/views/<feature>/entity-form/EntityEditForm.tsx

import { useEffect } from 'react';
import { useForm, FormProvider } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';

import { Button } from '@components/ui';

import { useAppTranslation } from '@hooks/shared';
import { useEntityDetailsQuery } from '@hooks/queries';
import { useUpdateEntityMutation } from '@hooks/mutations';

import type { EntityFormValues } from '../schemas';
import { entityFormSchema } from '../schemas';

type EntityEditFormProps = {
  entityId: string;
  onSuccess?: () => void;
  onCancel?: () => void;
};

export default function EntityEditForm({ entityId, onSuccess, onCancel }: EntityEditFormProps) {
  const { t } = useAppTranslation('entity');
  const entityQuery = useEntityDetailsQuery(entityId);
  const updateMutation = useUpdateEntityMutation();

  const methods = useForm<EntityFormValues>({
    resolver: zodResolver(entityFormSchema),
    defaultValues: {
      name: '',
      description: '',
    },
  });

  // Populate form when data loads
  useEffect(() => {
    if (entityQuery.data) {
      methods.reset({
        name: entityQuery.data.name,
        description: entityQuery.data.description ?? '',
      });
    }
  }, [entityQuery.data, methods]);

  const handleSubmit = async (values: EntityFormValues) => {
    await updateMutation.mutateAsync({ id: entityId, data: values });
    onSuccess?.();
  };

  return (
    <FormProvider {...methods}>
      <form onSubmit={methods.handleSubmit(handleSubmit)} className="space-y-4">
        {/* Use project's reusable form components here */}

        <div className="flex justify-end gap-3">
          <Button type="button" variant="outline" onClick={onCancel}>
            {t('cancel')}
          </Button>
          <Button type="submit" disabled={updateMutation.isPending}>
            {t('save')}
          </Button>
        </div>
      </form>
    </FormProvider>
  );
}
```

## Dual-Mode Form (Create + Edit)

When a single form handles both modes, accept a `mode` and optional initial data:

```typescript
type EntityFormProps = {
  mode: 'create' | 'edit';
  entityId?: string;
  initialData?: EntityFormValues;
  onSuccess?: () => void;
  onCancel?: () => void;
};
```

Use the mode to:
- Select the correct mutation (create vs update)
- Set the submit button label
- Conditionally populate defaults
