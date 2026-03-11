---
name: forge:i18n-sync
description: "Audit and sync locale files — find missing keys, untranslated values, and structural mismatches between en.json and ar.json. Use when the user wants to check translations, find missing keys, sync locale files, or says 'sync translations', 'check i18n', 'find missing translations', 'audit locales', 'are translations complete'. Triggers whenever locale file consistency needs to be verified."
---

# i18n Sync

Audit and synchronize locale files to find missing keys and structural mismatches.

## Step 1 — Load Locale Files

Read both locale files:
- `src/locales/en.json` — English (source of truth)
- `src/locales/ar.json` — Arabic

## Step 2 — Compare Keys

### Find missing keys

Walk both JSON trees recursively and identify:
1. **Keys in en.json missing from ar.json** — needs Arabic translation
2. **Keys in ar.json missing from en.json** — orphaned keys (stale)
3. **Structural mismatches** — key is a string in one file but an object in the other

### Find untranslated values

Flag ar.json entries where the value is identical to en.json — these are likely placeholders that were never translated.

### Find unused keys

Scan `src/` files for translation key usage (`t('key')`, `t("key")`) and identify keys in locale files that are never referenced in code.

## Step 3 — Generate Report

```markdown
## i18n Sync Report

### Missing in ar.json (need Arabic translation)
- `dashboard.analytics.title`
- `orders.status.pending`
- `communities.form.description_placeholder`

### Missing in en.json (orphaned — consider removing)
- `old_feature.deprecated_key`

### Untranslated (ar.json value = en.json value)
- `settings.notifications` — "Notifications" (same in both)

### Structural Mismatches
- `errors.validation` — string in en.json, object in ar.json

### Unused Keys (in locale files but not in code)
- `legacy.old_page_title`

### Summary
- X keys missing Arabic translation
- Y orphaned keys
- Z untranslated values
```

## Step 4 — Auto-Fix (when user confirms)

1. Add missing keys to ar.json with English value as placeholder (prefixed with `[AR] `)
2. Remove orphaned keys from ar.json
3. Fix structural mismatches
4. Sort both files alphabetically by key for consistency

## Rules

- en.json is the **source of truth** for key structure
- Never delete keys from en.json during sync
- Arabic text direction is RTL — no special JSON handling needed
- Never add asterisks to translation labels (the `required` prop handles indicators)
- Keep JSON keys in consistent order (alphabetical within each namespace)
