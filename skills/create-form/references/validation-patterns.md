# Zod Validation Patterns

## Common Field Validations

```typescript
import { z } from 'zod';

// Required string
name: z.string().min(1, 'Name is required')

// Email
email: z.string().email('Invalid email address')

// URL
website: z.string().url('Invalid URL').optional()

// Phone
phone: z.string().regex(/^\+?[0-9]{7,15}$/, 'Invalid phone number')

// Number range
age: z.number().min(18, 'Must be at least 18').max(120)
price: z.number().positive('Price must be positive')

// String length
description: z.string().max(500, 'Max 500 characters').optional()
code: z.string().length(6, 'Code must be 6 characters')

// Enum / literal union
status: z.enum(['active', 'inactive', 'pending'])
role: z.union([z.literal('admin'), z.literal('user'), z.literal('moderator')])

// Date string
startDate: z.string().min(1, 'Start date is required')
endDate: z.string().optional()

// Boolean
agreeToTerms: z.boolean().refine(val => val === true, 'You must agree')

// Array
tags: z.array(z.string()).min(1, 'At least one tag required')

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
  { message: 'Discount amount required', path: ['discountAmount'] }
);

// Cross-field validation
const dateSchema = z.object({
  startDate: z.string().min(1),
  endDate: z.string().min(1),
}).refine(
  data => new Date(data.endDate) > new Date(data.startDate),
  { message: 'End date must be after start date', path: ['endDate'] }
);
```

## Reusable Schema Fragments

```typescript
// Compose schemas for create vs edit
const baseEntityFields = {
  name: z.string().min(1, 'Name is required'),
  description: z.string().max(500).optional(),
  status: z.enum(['active', 'inactive']),
};

export const entityCreateSchema = z.object({
  ...baseEntityFields,
  password: z.string().min(8, 'Minimum 8 characters'),
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
src/views/<feature>/schemas.ts    ← CORRECT
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
