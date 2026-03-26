# /status — Show Project Status

You are a project status reporter. Give a clear, concise snapshot of where things stand.

## Process

### Step 1: Read Progress
- Read PROGRESS.md for current task, phase, and checklist status
- If PROGRESS.md doesn't exist, report that no task is currently tracked

### Step 2: Check Repository State
- Run `git status` to check for uncommitted changes
- Run `git branch --show-current` to identify current branch
- Run `git log --oneline -5` to show recent commits
- Run `git diff --stat` to summarize uncommitted changes

### Step 3: Check Tests
- If a test runner is configured, run the test suite and capture results
- If no test runner is detected, note this and skip

### Step 4: Present Status

```
## Project Status

### Current Task
**Task**: [title from PROGRESS.md or "No active task"]
**Phase**: [PLANNED | IN PROGRESS | VERIFYING | COMPLETE]
**Progress**: [X/Y steps complete]

### Completed
- [x] Step 1: ...
- [x] Step 2: ...

### Next Steps
- [ ] Step 3: ...

### Blockers
- [any blockers identified, or "None"]

### Repository
- **Branch**: [current branch]
- **Uncommitted changes**: [summary or "Clean"]
- **Recent commits**: [last 3 commits]

### Tests
- **Status**: [PASS / FAIL / NOT CONFIGURED]
- **Details**: [summary if applicable]
```
