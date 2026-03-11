---
name: forge:changelog
description: "Generate a changelog from git history, grouped by type and linked to tickets. Use when the user wants to create a changelog, generate release notes, summarize recent changes, or says 'generate changelog', 'what changed since', 'release notes', 'summarize commits', 'changes since last release'. Triggers whenever commit history needs to be summarized."
---

# Changelog

Generate a structured changelog from git commit history.

## Step 1 — Determine Range

Ask the user if not provided:
- **Since**: tag, commit hash, date, or "last release"
- **Until**: HEAD (default), tag, or commit hash

```bash
# Between tags
git log v1.2.0..v1.3.0 --oneline

# Since date
git log --since="2024-01-01" --oneline

# Last N commits
git log -20 --oneline
```

## Step 2 — Parse Commits

Read the commit log and categorize by the ticket prefix and commit verb:

| Verb | Category |
|------|----------|
| Add, Create, Implement | Features |
| Fix, Resolve, Correct | Bug Fixes |
| Update, Improve, Enhance | Improvements |
| Refactor, Clean, Reorganize | Refactoring |
| Remove, Delete, Drop | Removals |
| Configure, Setup | Configuration |

Extract ticket numbers (e.g., `PROJ-XXX`) from each commit message.

## Step 3 — Generate Changelog

### Format

```markdown
# Changelog — [version or date range]

## Features
- **PROJ-210**: Add user dashboard with analytics cards
- **PROJ-215**: Implement search with debounce

## Bug Fixes
- **PROJ-199**: Fix login redirect loop
- **PROJ-203**: Correct date formatting in locale

## Improvements
- **PROJ-180**: Update orders table with sortable columns
- **PROJ-192**: Enhance dark mode token coverage

## Refactoring
- **PROJ-150**: Clean up auth flow and simplify guards

## Configuration
- **PROJ-220**: Configure ESLint rules for import ordering
```

### Rules

- Group by category, not by date
- Each entry links to a ticket when possible
- Use the commit message's imperative description (not the raw commit)
- De-duplicate: multiple commits for the same ticket become one entry
- Omit merge commits and CI-only changes
- Sort entries within each category by ticket number
