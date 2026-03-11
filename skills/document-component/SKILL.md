---
name: forge:document-component
description: "Generate usage documentation for a component — props, variants, examples, and guidelines. Use when the user wants to document a component, create usage docs, write component API docs, or says 'document this component', 'write docs for', 'component API', 'usage examples', 'how to use this component'. Triggers whenever component documentation or usage guides need to be created."
---

# Document Component

Generate usage documentation for an existing component.

## Step 1 — Read the Component

Read the target component file and extract:
- Component name and purpose
- Props (types, defaults, required/optional)
- Variants (if CVA)
- Sub-components (if compound)
- Internal context (if any)

## Step 2 — Generate Documentation

### Structure

```markdown
# ComponentName

Brief description of what the component does and when to use it.

## Import

\`\`\`tsx
import { ComponentName } from '@components/shared';
\`\`\`

## Props

| Prop | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| variant | 'default' \| 'primary' \| 'danger' | 'default' | No | Visual style |
| size | 'sm' \| 'md' \| 'lg' | 'md' | No | Component size |
| children | ReactNode | — | Yes | Content |
| className | string | — | No | Additional CSS classes |

## Variants

### Default
\`\`\`tsx
<ComponentName>Default content</ComponentName>
\`\`\`

### Primary
\`\`\`tsx
<ComponentName variant="primary">Primary content</ComponentName>
\`\`\`

## Sub-Components (if compound)

### ComponentName.Header
| Prop | Type | Description |
|------|------|-------------|
| className | string | Additional CSS classes |
| children | ReactNode | Header content |

## Examples

### Basic Usage
\`\`\`tsx
<ComponentName>
  <ComponentName.Header>Title</ComponentName.Header>
  <ComponentName.Content>Body</ComponentName.Content>
</ComponentName>
\`\`\`

### With Actions
\`\`\`tsx
<ComponentName variant="primary">
  <ComponentName.Header>Title</ComponentName.Header>
  <ComponentName.Content>Body</ComponentName.Content>
  <ComponentName.Footer>
    <Button>Action</Button>
  </ComponentName.Footer>
</ComponentName>
\`\`\`

## Guidelines

- When to use this component vs alternatives
- Accessibility notes
- RTL considerations
- Dark mode notes
```

## Step 3 — Verify Accuracy

- Ensure every prop is documented
- Ensure examples actually compile
- Check that variant names match the implementation
- Verify sub-component list is complete

## Rules

- Documentation reflects the actual code — don't document features that don't exist
- Include at least 2-3 usage examples covering common scenarios
- Note any accessibility requirements
- Mention RTL behavior if the component has directional styling
- Keep examples minimal — show one concept per example
