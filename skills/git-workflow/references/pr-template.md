# Pull Request Template

## Template

```markdown
## Summary
- Brief description of what this PR does and why
- List the key changes (1-5 bullet points)

## Jira Ticket(s)
- [DM-XXX](https://your-domain.atlassian.net/browse/DM-XXX)

## Changes
- Detailed list of files/areas changed and what was done
- Group by category if many files changed

## Testing
- Steps to verify the changes work correctly
- Edge cases considered
- [ ] Tested in light mode
- [ ] Tested in dark mode
- [ ] Tested in RTL (Arabic)
- [ ] Tested responsive (mobile, tablet, desktop)

## Screenshots (if UI changes)
| Before | After |
|--------|-------|
| screenshot | screenshot |
```

## Example

```markdown
## Summary
- Add provider dashboard page with analytics cards and recent orders table
- Implement responsive grid layout with dark mode and RTL support

## Jira Ticket(s)
- [DM-210](https://your-domain.atlassian.net/browse/DM-210)

## Changes
- Added `ProviderDashboardPage` in `src/pages/provider-dashboard/`
- Created `AnalyticsCard` shared component with 4 variants
- Added dashboard query hook using existing analytics handler
- Updated routes to include dashboard under DashboardLayout with AuthGuard
- Added en/ar translation keys for dashboard labels

## Testing
- [x] Analytics cards render with correct data
- [x] Table pagination works
- [x] Dark mode verified
- [x] RTL layout mirrors correctly
- [x] Mobile stacks to single column

## Screenshots
| Desktop | Mobile |
|---------|--------|
| ... | ... |
```
