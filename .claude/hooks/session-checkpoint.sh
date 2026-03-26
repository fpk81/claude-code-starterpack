#!/bin/bash
# session-checkpoint.sh — Stop hook
# Reminds about uncommitted work and open tasks when a session ends.
# Output goes to stdout (injected into Claude's context).
# Never blocks, just informs. Fails silently on errors.

# Do NOT use set -e — this script must never fail visibly
set +e

REMINDERS=""

# --- Check for uncommitted git changes ---
if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  # Check for staged changes
  STAGED=$(git diff --cached --stat 2>/dev/null)
  # Check for unstaged changes
  UNSTAGED=$(git diff --stat 2>/dev/null)
  # Check for untracked files
  UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | head -5)

  if [ -n "$STAGED" ] || [ -n "$UNSTAGED" ] || [ -n "$UNTRACKED" ]; then
    REMINDERS="${REMINDERS}## Uncommitted Changes\n"

    if [ -n "$STAGED" ]; then
      REMINDERS="${REMINDERS}- Staged changes exist (ready to commit)\n"
    fi
    if [ -n "$UNSTAGED" ]; then
      REMINDERS="${REMINDERS}- Unstaged modifications detected\n"
    fi
    if [ -n "$UNTRACKED" ]; then
      COUNT=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
      REMINDERS="${REMINDERS}- ${COUNT} untracked file(s)\n"
    fi
    REMINDERS="${REMINDERS}\n"
  fi
fi

# --- Check PROGRESS.md for open tasks ---
PROGRESS_FILE="PROGRESS.md"
if [ -f "$PROGRESS_FILE" ]; then
  # Count open checkboxes (- [ ] items)
  OPEN_TASKS=$(grep -c '^\s*-\s*\[ \]' "$PROGRESS_FILE" 2>/dev/null || echo "0")
  DONE_TASKS=$(grep -c '^\s*-\s*\[x\]' "$PROGRESS_FILE" 2>/dev/null || echo "0")

  if [ "$OPEN_TASKS" -gt 0 ] 2>/dev/null; then
    REMINDERS="${REMINDERS}## Open Tasks (PROGRESS.md)\n"
    REMINDERS="${REMINDERS}- ${OPEN_TASKS} task(s) still open, ${DONE_TASKS} completed\n"

    # Show up to 5 open tasks
    TASK_LIST=$(grep '^\s*-\s*\[ \]' "$PROGRESS_FILE" 2>/dev/null | head -5 | sed 's/^\s*-\s*\[ \]/  -/')
    if [ -n "$TASK_LIST" ]; then
      REMINDERS="${REMINDERS}${TASK_LIST}\n"
    fi
    REMINDERS="${REMINDERS}\n"
  fi
fi

# --- Output reminders if any ---
if [ -n "$REMINDERS" ]; then
  echo ""
  echo "---"
  echo "SESSION CHECKPOINT REMINDER"
  echo "---"
  echo -e "$REMINDERS"
  echo "Consider committing your work before ending the session."
fi

exit 0
