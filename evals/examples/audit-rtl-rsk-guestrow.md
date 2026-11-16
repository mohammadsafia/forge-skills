# Input: audit-rtl in an RSK app

The repository is a React app. It has `kit.lock.json` at its root (`"target": "vite"`). You cannot open the repository: work from the skill and the files it points to, and write your answer as text (file paths and code). Do not run commands.

Audit this file, `src/pages/bookings/GuestRow.tsx`, for RTL:

```tsx
<div className="flex items-center ml-4 pr-2">
  <ChevronRight className="size-4 rtl:rotate-180" />
  <span className="ms-2 rtl:me-2 text-left">{t('guestAdded', { name: guest.fullName })}</span>
  <span>{guest.phone}</span>
  <textarea name="note" className="border-l ps-2" />
</div>
```

`guest.fullName` is typed by reception in English or Arabic. `t('guestAdded')` is "{{name}} was added" /
"تمت إضافة {{name}}".
