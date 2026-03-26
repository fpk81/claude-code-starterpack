#!/bin/bash
# session-start.sh — SessionStart hook
# Injects project state into context at session start via stdout.
# Stdout from SessionStart hooks is added to Claude's context.
# Intentionally NO set -e: fail-open on errors.

# Check for PROGRESS.md and output its content if it exists
if [ -f "PROGRESS.md" ]; then
  echo "=== SESSION RECOVERY: PROGRESS.md ==="
  # Output last 50 lines to avoid overwhelming context
  tail -50 PROGRESS.md
  echo "=== END SESSION RECOVERY ==="
fi

# Check for .project-config.json
if [ -f ".project-config.json" ]; then
  echo "=== PROJECT CONFIG ==="
  cat .project-config.json
  echo "=== END PROJECT CONFIG ==="
fi

# Check for uncommitted changes
if git status --porcelain 2>/dev/null | head -5 | grep -q .; then
  echo "=== WARNING: Uncommitted changes detected ==="
  git status --short 2>/dev/null | head -10
  echo "=== END WARNING ==="
fi

# Check current branch
BRANCH=$(git branch --show-current 2>/dev/null)
if [ -n "$BRANCH" ]; then
  echo "Current branch: $BRANCH"
fi

exit 0
