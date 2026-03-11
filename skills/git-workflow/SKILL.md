---
name: forge:git-workflow
description: "Follow a structured git workflow — branch naming with ticket numbers, commit messages, and PR creation. Use when the user wants to create a branch, write a commit message, open a pull request, or says 'create branch', 'commit this', 'open PR', 'start working on PROJ-xxx', 'push changes'. Triggers whenever git operations need to follow ticket-linked conventions."
---

# Git Workflow

Enforce ticket-integrated branch naming, commit messages, and PR conventions.

## Branch Naming

Format: `<type>/<ticket>-<short-description>` (kebab-case)

Types: `feature`, `fix`, `refactor`, `chore`, `hotfix`

```bash
# CORRECT
feature/PROJ-210-add-user-dashboard
fix/PROJ-199-login-redirect-loop
refactor/PROJ-150-cleanup-auth-flow

# WRONG
fix/login-redirect-loop            # Missing ticket number
feature/PROJ-210                   # Missing description
Feature/PROJ-210-AddDashboard      # PascalCase not allowed
```

For no ticket: `chore/no-ticket-<description>`

## Commit Messages

Format: `<TICKET>: <imperative description>`

```bash
# CORRECT
PROJ-136: Rename Organization Type to Entity Type
PROJ-200: Fix login redirect to correct dashboard

# With body for complex changes
PROJ-200: Fix login redirect to correct dashboard

The signup route path was empty, causing navigation to fail.
Fixed route path, added router entry, and set accountType in context.

# WRONG
Fix login bug                       # Missing ticket number
PROJ-200 - fixed the redirect      # Use colon, not dash
PROJ-200: Fixed the redirect       # Use imperative mood
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
- **Ticket(s)** — linked
- **Changes** — detailed file/area list
- **Testing** — verification steps
- **Screenshots** — for UI changes

Rules:
- Keep PRs scoped — don't mix unrelated features
- Link all related tickets
- Add screenshots for UI changes

## Workflow

1. **Start work**: Create branch from base branch
   ```bash
   git checkout main && git pull
   git checkout -b feature/PROJ-XXX-short-description
   ```

2. **Commit**: Use ticket-prefixed messages
   ```bash
   git add <specific-files>
   git commit -m "PROJ-XXX: Add entity list page"
   ```

3. **Push**: Push with upstream tracking
   ```bash
   git push -u origin feature/PROJ-XXX-short-description
   ```

4. **PR**: Create with template
   ```bash
   gh pr create --title "PROJ-XXX: Short title" --body "..."
   ```

## Reference Files

- `references/pr-template.md` — Full PR body template
