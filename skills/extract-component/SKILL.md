---
name: extract-component
description: "Extract repeated JSX into a reusable component — identify duplication and DRY it up. Use when the user wants to extract a component, reduce duplication, DRY up repeated JSX, or says 'extract component', 'this is repeated', 'DRY this up', 'make this reusable', 'too much duplication'. Triggers whenever repeated UI code should become a shared component."
---

# Extract Component

Identify repeated JSX patterns and extract them into reusable components.

## Step 1 — Find Duplication

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

- Extract at **3+ repetitions** (or 2 with clear future reuse)
- Varying parts become props — never hardcode
- Always accept `className?` for style extension
- Use `cn()` to merge base styles with passed className
- Follow the component quality checklist (accessibility, dark mode, RTL)
- Do not over-abstract — if variations are too different, they might not be the same component
- Prefer composition (children/slots) over configuration (many boolean props)
