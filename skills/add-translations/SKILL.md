---
name: forge:add-translations
description: "Add new translation keys to both en.json and ar.json locale files. Use when the user wants to add new i18n keys, translate new UI text, add labels for a new feature, or says 'add translations', 'add i18n keys', 'translate this', 'add labels for', 'new translation keys'. Triggers whenever new translation entries need to be added to both locale files."
---

# Add Translations

Add new translation keys to both English and Arabic locale files.

## Step 1 — Gather Keys

Determine the keys to add from:
- The user's request (explicit keys and values)
- A new feature being built (scan components for `t('...')` calls)
- Figma designs (extract visible text)

## Step 2 — Determine Namespace

Translation keys are organized by feature namespace:

```json
{
  "common": { "save": "Save", "cancel": "Cancel" },
  "orders": { "title": "Orders", "status": { "pending": "Pending" } },
  "communities": { "title": "Communities" }
}
```

Place keys in the correct namespace. Create a new namespace if the feature doesn't have one yet.

## Step 3 — Add to Both Files

### en.json
Add the English values:
```json
{
  "feature": {
    "title": "Feature Title",
    "description": "Feature description text",
    "form": {
      "name_label": "Name",
      "name_placeholder": "Enter name",
      "submit": "Create"
    }
  }
}
```

### ar.json
Add the Arabic values. If Arabic text is not provided by the user, add a placeholder:
```json
{
  "feature": {
    "title": "[AR] Feature Title",
    "description": "[AR] Feature description text"
  }
}
```

Prefix with `[AR] ` so untranslated strings are visible in the UI.

## Rules

- Always add to **both** locale files in the same operation
- Maintain the same key structure in both files
- Use nested objects for grouping (not flat dot-notation keys)
- Keep keys sorted alphabetically within each namespace
- Never add asterisks (`*`) to labels — `required` prop handles the indicator
- Common/shared labels go in the `common` namespace
- Feature-specific labels go in the feature's namespace
- Use `useAppTranslation(namespace)` hook in components

## Common Patterns

```json
// CRUD operations
"create": "Create",
"edit": "Edit",
"delete": "Delete",
"save": "Save",
"cancel": "Cancel",
"confirm": "Confirm",

// Table/list
"search": "Search",
"no_results": "No results found",
"showing_of": "Showing {{count}} of {{total}}",

// Form
"required_field": "This field is required",
"invalid_email": "Invalid email address",

// Status
"status": {
  "active": "Active",
  "inactive": "Inactive",
  "pending": "Pending"
}
```
