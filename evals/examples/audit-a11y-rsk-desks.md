# Input: audit-a11y in an RSK app

The repository is a React app. It has `kit.lock.json` at its root (`"target": "vite"`). You cannot open the repository: work from the skill and the files it points to, and write your answer as text (file paths and code). Do not run commands.

The project's docs/design.md says touch targets are at least 40 px. Audit this page, `src/pages/desks/DesksPage.tsx`:

```tsx
const [editing, setEditing] = useState<DeskListDto | null>(null);

<PageHeader title={t('title')} />
<Table aria-label={t('title')}>
  {desks.map((desk) => (
    <Table.Row key={desk.id}>
      <Table.Cell>{desk.name}</Table.Cell>
      <Table.Cell>
        <DropdownMenu>
          <DropdownMenu.Trigger asChild><IconButton size="sm" aria-label={t('actions', { name: desk.name })}><MoreHorizontal /></IconButton></DropdownMenu.Trigger>
          <DropdownMenu.Content><DropdownMenu.Item onSelect={() => setEditing(desk)}>{t('edit')}</DropdownMenu.Item></DropdownMenu.Content>
        </DropdownMenu>
      </Table.Cell>
    </Table.Row>
  ))}
</Table>
<Sheet open={!!editing} onOpenChange={(open) => !open && setEditing(null)}>
  <Sheet.Content className="focus-visible:ring-2 focus-visible:ring-tokens-primary">
    <FormContainer formContext={form} onSuccess={handleSave}>
      <FormInput name="name" label={t('name')} />
      <div className="font-medium">{t('kind')}</div>
      <Checkbox name="kind-standing" /> <span>{t('standing')}</span>
      <Checkbox name="kind-sitting" /> <span>{t('sitting')}</span>
      <button onClick={handleClearName}><X /></button>
      <FormContainer.Actions />
    </FormContainer>
  </Sheet.Content>
</Sheet>
```

The kit commit in kit.lock.json is unknown to you. The sidebar links to this page.
