---
name: forge:add-translations
description: "Add new translation keys to both en.json and ar.json locale files. Use when the user wants to add new i18n keys, translate new UI text, add labels for a new feature, or says 'add translations', 'add i18n keys', 'translate this', 'add labels for', 'new translation keys'. Triggers whenever new translation entries need to be added to both locale files."
---

# Add Translations

Add new translation keys to every locale the project supports (usually English and Arabic), in the layout the project
uses, and say which text still needs a person's approval.

## Step 1 — Read the Locale Layout

Projects keep copy in one of two shapes. Find which before adding anything:

| Shape | Looks like | Namespace is |
|---|---|---|
| One file per language | `locales/en.json`, `locales/ar.json` | a top-level key inside the file |
| One file per namespace | `src/locales/en/<namespace>.json`, `src/locales/ar/<namespace>.json` | the file name |

If `kit.lock.json` exists at the repository root, the app is built on the RSK kit: it uses one file per namespace, loads
every file in `src/locales/{en,ar}/` automatically, and `tests/i18n/parity.test.ts` fails when a key exists in one
language only. Read `../_shared/rsk-kit.md` section 7.

Also read the project's rules (`AGENTS.md`, `CLAUDE.md`, `docs/`) for: who writes or approves Arabic, and how
unapproved text is marked.

## Step 2 — Gather Keys

Determine the keys from the user's request, the components being built (`t('...')` calls), or the designs.

## Step 3 — Choose the Namespace

- A feature area gets its own namespace (RSK: a new pair of files `src/locales/en/<area>.json` and
  `src/locales/ar/<area>.json`; the hook is `useAppTranslation('<area>')`).
- Words used across areas (Save, Cancel) go in `common`. In RSK, sidebar labels go in `nav` under the menu entry's `id`,
  and the kit's own messages live in `errors` and `common`: reuse them, do not copy them.

## Step 4 — Messages From the Server

Decide how each server message reaches the screen before adding keys for it:

| The API sends | Do |
|---|---|
| An error code (`code: 'visit_full'`) | Add a key per code (e.g. `errors.api.visit_full`) in both languages, map code → key in the page, and keep a general fallback key for unknown codes. |
| Text already in the person's language (the API reads `Accept-Language` or a `lang` parameter) | Show it as sent; add no key. Check that the client sends the language. |
| Text in one language only | Do not show it to people in the other language. Ask the API owner for codes; until then map the status to a general key. |

Validation messages that the client checks itself are keys like any other copy (RSK: `errors:validation.*` exists).

## Step 5 — Add to Every Locale File

- Same key structure in every language; nested objects, not dotted keys, unless the project uses flat keys.
- English text is written in full.
- Arabic text: follow the project's rule for who writes and approves it. Text an assistant or engineer writes is a
  proposal until the approver named by the project accepts it.
  - If the project marks unapproved text (for example a `[AR]` prefix, or a list in the pull request), use its mark.
  - If the project says nothing, write your best Arabic and list every new Arabic key under "Arabic to review" in the
    output and the pull request, for the person the project names (ask who, if nobody is named). Never call it approved.
  - Never leave an Arabic value empty or identical to the English one without saying so in that list.
- Plurals: Arabic needs `_zero`, `_one`, `_two`, `_few`, `_many`, `_other`; English `_one`, `_other`. Pass `count`.
- Interpolation variables (`{{name}}`) are the same in both languages. Values that are names, codes or amounts are
  shown in `dir="ltr"` or `<bdi>` by the component (see `forge:audit-rtl`).

## Rules

- Add to all locale files in the same change; run the parity check if the project has one (RSK: `vp test tests/i18n`).
- Never add asterisks (`*`) to labels; the field's `required` prop shows the marker.
- Do not delete keys that look unused because a literal search found no `t('…')` call; keys are often built at run time.

## Output

List the files changed, the new keys per namespace, the server-message mapping (code → key), and "Arabic to review"
with each key, its Arabic text, and who is asked to approve it.
