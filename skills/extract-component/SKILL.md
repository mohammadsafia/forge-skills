---
name: forge:extract-component
description: "Extract repeated JSX into a reusable component — identify duplication and DRY it up. Use when the user wants to extract a component, reduce duplication, DRY up repeated JSX, or says 'extract component', 'this is repeated', 'DRY this up', 'make this reusable', 'too much duplication'. Triggers whenever repeated UI code should become a shared component."
---

# Extract Component

Identify repeated JSX patterns and extract them into reusable components.

## Step 1 — Find Duplication

Before extracting, scan existing shared components:
- `src/components/shared/` — check if a similar component already exists
- Look at compound pattern examples (`PrimeCard`, `PrimeDialog`) for the target structure

See `_shared/code-standards.md` for all project rules (sections 5, 8).

Scan the target file(s) for:
- JSX blocks that appear 3+ times (or 2 times with slight variations)
- Similar structures with different data (cards, list items, badges)
- Copy-pasted sections with minor prop differences

## Step 2 — Analyze Variations

For each repeated block, document:
- What's the same across all instances (structure, classes)
- What varies (text, colors, icons, data)
- Where it's used (which files/pages)

The varying parts become **props**. The shared structure becomes the **component**.

## Step 3 — Decide Placement

| Used in... | Place in... |
|------------|------------|
| Single feature only | `src/views/<feature>/` |
| 2+ features | `src/components/shared/` |
| Is a form element | `src/components/forms/` |
| Is a UI primitive | `src/components/ui/` (rare — check shadcn first) |

## Step 4 — Extract

### Simple extraction (leaf component)

```typescript
// Before: repeated in multiple places
<div className="flex items-center gap-2 rounded-lg border p-3">
  <Icon className="h-5 w-5 text-muted-foreground" />
  <span className="text-sm font-medium">{label}</span>
</div>

// After: extracted component
type InfoItemProps = {
  icon: ReactNode;
  label: string;
  className?: string;
};

function InfoItem({ icon, label, className }: InfoItemProps) {
  return (
    <div className={cn('flex items-center gap-2 rounded-lg border p-3', className)}>
      {icon}
      <span className="text-sm font-medium">{label}</span>
    </div>
  );
}
```

### Complex extraction (compound component)

If the extracted component has 2+ semantic parts, use the compound pattern:
- Read `create-component` skill for the full workflow
- Ensure Phase 1 audit is done before building

## Step 5 — Replace All Instances

1. Create the component file with proper folder structure
2. Add barrel export
3. Replace every instance of the repeated code with the new component
4. Verify no functional changes were introduced

## Rules

See `_shared/code-standards.md` for all project rules. Extraction-specific rules:

- Check `src/components/shared/` before creating — may already exist
- Add `data-slot` to the extracted component's root element
- Ensure all visible strings use `t()` for i18n
- Interactive components must include `aria-label` or `aria-labelledby`
- Use compound pattern if the component has 3+ distinct sections
