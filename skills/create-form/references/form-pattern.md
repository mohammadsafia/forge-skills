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
  const { mutateAsync, isPending } = useCreateEntityMutation();

  const methods = useForm<EntityFormValues>({
    resolver: zodResolver(entityFormSchema),
    defaultValues: {
      name: '',
      description: '',
    },
  });

  const handleSubmit = async (values: EntityFormValues) => {
    await mutateAsync(values);
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
          <Button type="submit" disabled={isPending}>
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
  const { data: entity } = useEntityDetailsQuery(entityId);
  const { mutateAsync, isPending } = useUpdateEntityMutation();

  const methods = useForm<EntityFormValues>({
    resolver: zodResolver(entityFormSchema),
    defaultValues: {
      name: '',
      description: '',
    },
  });

  // Populate form when data loads
  useEffect(() => {
    if (entity) {
      methods.reset({
        name: entity.name,
        description: entity.description ?? '',
      });
    }
  }, [entity, methods]);

  const handleSubmit = async (values: EntityFormValues) => {
    await mutateAsync({ id: entityId, data: values });
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
          <Button type="submit" disabled={isPending}>
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
