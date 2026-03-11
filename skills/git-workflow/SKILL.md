---
name: git-workflow
description: "Follow Jira-integrated git workflow — branch naming, commit messages, and PR creation with ticket numbers. Use when the user wants to create a branch, write a commit message, open a pull request, or says 'create branch', 'commit this', 'open PR', 'start working on DM-xxx', 'push changes'. Triggers whenever git operations need to follow the project's Jira-linked conventions."
---

# Git Workflow

Enforce Jira-integrated branch naming, commit messages, and PR conventions.

## Branch Naming

Format: `<type>/<ticket>-<short-description>` (kebab-case)

Types: `feature`, `fix`, `refactor`, `chore`, `hotfix`

```bash
# CORRECT
feature/DM-210-add-provider-dashboard
fix/DM-199-consumer-profile-link
refactor/DM-150-cleanup-auth-flow

# WRONG
fix/consumer-profile-link          # Missing ticket number
feature/DM-210                     # Missing description
Feature/DM-210-AddDashboard        # PascalCase not allowed
```

For no Jira ticket: `chore/no-ticket-<description>`

## Commit Messages

Format: `<TICKET>: <imperative description>`

```bash
# CORRECT
DM-136: Rename Organization Type to Entity Type
DM-200: Fix private sector registration redirect to login

# With body for complex changes
DM-200: Fix private sector registration redirect to login

The SignupBusiness route path was empty, causing navigation to fail.
Fixed route path, added router entry, and set accountType in context.

# WRONG
Fix login bug                      # Missing ticket number
DM-200 - fixed the redirect       # Use colon, not dash
DM-200: Fixed the redirect        # Use imperative mood
```

Rules:
- Subject under 72 characters
- Imperative mood: "Fix", "Add", "Update", "Remove" — not past tense
- Do NOT add `Co-Authored-By` lines
- One logical change per commit

## Pull Requests

Title: `<TICKET>: <short title>` (under 72 characters)

See `references/pr-template.md` for the full PR body template.

Body must include:
- **Summary** — what and why (1-5 bullets)
- **Jira Ticket(s)** — linked
- **Changes** — detailed file/area list
- **Testing** — verification steps
- **Screenshots** — for UI changes

Rules:
- Keep PRs scoped — don't mix unrelated features
- Link all related Jira tickets
- Add screenshots for UI changes

## Workflow

1. **Start work**: Create branch from `development`
   ```bash
   git checkout development && git pull
   git checkout -b feature/DM-XXX-short-description
   ```

2. **Commit**: Use ticket-prefixed messages
   ```bash
   git add <specific-files>
   git commit -m "DM-XXX: Add entity list page"
   ```

3. **Push**: Push with upstream tracking
   ```bash
   git push -u origin feature/DM-XXX-short-description
   ```

4. **PR**: Create with template
   ```bash
   gh pr create --title "DM-XXX: Short title" --body "..."
   ```

## Reference Files

- `references/pr-template.md` — Full PR body template
