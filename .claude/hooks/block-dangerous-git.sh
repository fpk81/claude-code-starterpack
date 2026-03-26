#!/bin/bash
# block-dangerous-git.sh — PreToolUse hook for Bash tool
# Blocks destructive git operations and rm -rf commands.
# Exit 2 = block the tool call. Exit 0 = allow.
# Fails open: any error in this script allows the command through.

# Intentionally NO set -e: this script must fail-open on errors.
# If any check fails unexpectedly, we allow the command through rather than blocking legitimate work.

# Read JSON input from stdin
INPUT=$(cat)

# Extract the command string from tool_input.command
# Uses parameter expansion to avoid jq dependency
COMMAND=$(echo "$INPUT" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)"/\1/p' | head -1)

# If we couldn't extract a command, fail open
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Normalize: collapse whitespace, lowercase for matching
CMD_LOWER=$(echo "$COMMAND" | tr '[:upper:]' '[:lower:]' | tr -s '[:space:]' ' ')

# --- Block: rm -rf ---
if echo "$CMD_LOWER" | grep -qE '(^|[;&|]\s*)rm\s+(-[a-z]*r[a-z]*f|-[a-z]*f[a-z]*r)\b'; then
  echo "BLOCKED: 'rm -rf' is a destructive operation. Remove files individually or use a safer approach." >&2
  exit 2
fi

# --- Block: git push --force / -f to main/master ---
if echo "$CMD_LOWER" | grep -qE 'git\s+push\s+.*(-f|--force)'; then
  if echo "$CMD_LOWER" | grep -qE '\b(main|master)\b'; then
    echo "BLOCKED: Force push to main/master is destructive and not allowed." >&2
    exit 2
  fi
  # Force push to non-protected branches: warn but allow
  echo "WARNING: Force push detected. Ensure this is intentional." >&2
  exit 0
fi

# --- Block: git reset --hard ---
if echo "$CMD_LOWER" | grep -qE 'git\s+reset\s+.*--hard'; then
  echo "BLOCKED: 'git reset --hard' discards uncommitted changes. Use 'git stash' instead." >&2
  exit 2
fi

# --- Block: git clean -f ---
if echo "$CMD_LOWER" | grep -qE 'git\s+clean\s+.*-[a-z]*f'; then
  echo "BLOCKED: 'git clean -f' permanently deletes untracked files. Remove files individually." >&2
  exit 2
fi

# --- Block: git checkout -- . (destructive restore of all files) ---
if echo "$CMD_LOWER" | grep -qE 'git\s+checkout\s+--\s+\.'; then
  echo "BLOCKED: 'git checkout -- .' discards all unstaged changes. Restore specific files instead." >&2
  exit 2
fi

# --- Block: git restore . (destructive restore of all files) ---
if echo "$CMD_LOWER" | grep -qE 'git\s+restore\s+\.'; then
  echo "BLOCKED: 'git restore .' discards all unstaged changes. Restore specific files instead." >&2
  exit 2
fi

# --- Block: git branch -D main/master ---
if echo "$CMD_LOWER" | grep -qE 'git\s+branch\s+-D\s+(main|master)\b'; then
  echo "BLOCKED: Deleting the main/master branch is not allowed." >&2
  exit 2
fi

# All checks passed — allow
exit 0
