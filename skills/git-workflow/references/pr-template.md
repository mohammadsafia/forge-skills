# Pull Request Template

## Template

```markdown
## Summary
- Brief description of what this PR does and why
- List the key changes (1-5 bullet points)

## Ticket(s)
- [PROJ-XXX](https://your-domain.atlassian.net/browse/PROJ-XXX)

## Changes
- Detailed list of files/areas changed and what was done
- Group by category if many files changed

## Testing
- Steps to verify the changes work correctly
- Edge cases considered
- [ ] Tested in light mode
- [ ] Tested in dark mode
- [ ] Tested in RTL (if applicable)
- [ ] Tested responsive (mobile, tablet, desktop)

## Screenshots (if UI changes)
| Before | After |
|--------|-------|
| screenshot | screenshot |
```

## Example

```markdown
## Summary
- Add user dashboard page with analytics cards and recent activity table
- Implement responsive grid layout with dark mode and RTL support

## Ticket(s)
- [PROJ-210](https://your-domain.atlassian.net/browse/PROJ-210)

## Changes
- Added `UserDashboardPage` in `src/pages/user-dashboard/`
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
