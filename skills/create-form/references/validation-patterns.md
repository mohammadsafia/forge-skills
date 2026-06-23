# Zod Validation Patterns

## Common Field Validations

> **Important:** All user-facing validation messages must use `t()` translation keys, not hardcoded English strings. Import `t` from your i18n setup or pass it as a parameter to the schema factory.

```typescript
import { z } from 'zod';

import { t } from '@i18n'; // or accept t as a parameter: (t: TFunction) => z.object({...})

// Required string
name: z.string().min(1, t('validation.required'))

// Email
email: z.string().email(t('validation.invalid_email'))

// URL
website: z.string().url(t('validation.invalid_url')).optional()

// Phone
phone: z.string().regex(/^\+?[0-9]{7,15}$/, t('validation.invalid_phone'))

// Number range
age: z.number().min(18, t('validation.min_age', { min: 18 })).max(120)
price: z.number().positive(t('validation.must_be_positive'))

// String length
description: z.string().max(500, t('validation.max_characters', { max: 500 })).optional()
code: z.string().length(6, t('validation.exact_length', { length: 6 }))

// Enum / literal union
status: z.enum(['active', 'inactive', 'pending'])
role: z.union([z.literal('admin'), z.literal('user'), z.literal('moderator')])

// Date string
startDate: z.string().min(1, t('validation.required'))
endDate: z.string().optional()

// Boolean
agreeToTerms: z.boolean().refine(val => val === true, t('validation.must_agree'))

// Array
tags: z.array(z.string()).min(1, t('validation.min_items', { min: 1 }))

// File upload
file: z.instanceof(File).optional()
```

## Conditional Validation

```typescript
// Field required only when another field has a value
const schema = z.object({
  hasDiscount: z.boolean(),
  discountAmount: z.number().optional(),
}).refine(
  data => !data.hasDiscount || (data.hasDiscount && data.discountAmount),
  { message: t('validation.discount_required'), path: ['discountAmount'] }
);

// Cross-field validation
const dateSchema = z.object({
  startDate: z.string().min(1),
  endDate: z.string().min(1),
}).refine(
  data => new Date(data.endDate) > new Date(data.startDate),
  { message: t('validation.end_date_after_start'), path: ['endDate'] }
);
```

## Reusable Schema Fragments

```typescript
// Compose schemas for create vs edit
const baseEntityFields = {
  name: z.string().min(1, t('validation.required')),
  description: z.string().max(500).optional(),
  status: z.enum(['active', 'inactive']),
};

export const entityCreateSchema = z.object({
  ...baseEntityFields,
  password: z.string().min(8, t('validation.min_characters', { min: 8 })),
});

export const entityUpdateSchema = z.object({
  ...baseEntityFields,
  // Password optional on update
  password: z.string().min(8).optional(),
});
```

## Schema File Location

Schemas always live with the feature:
```
src/views/<feature>/Feature.schemas.ts    ← CORRECT
src/types/schemas.ts              ← WRONG
src/validations/<feature>.ts      ← WRONG (legacy, avoid)
```

## Extracting Types

```typescript
// Infer form values from schema
export type EntityFormValues = z.infer<typeof entityFormSchema>;

// Use in other files
import type { EntityFormValues } from '../schemas';
```
