#!/bin/bash
# protect-config.sh — PreToolUse hook for Edit|Write tools
# Defense-in-depth protection for critical configuration files.
# The deny rules in settings.json are the primary defense; this is a backup.
# Exit 2 = block. Exit 0 = allow.
# Fails open on errors.

# Intentionally NO set -e: fail-open on unexpected errors.

# Read JSON input from stdin
INPUT=$(cat)

# Extract the file_path from tool_input
FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
fi

# If we couldn't extract a file path, fail open
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Normalize: strip leading ./
NORMALIZED=$(echo "$FILE_PATH" | sed 's|^\./||')

# Block: .claude/settings.json
if [ "$NORMALIZED" = ".claude/settings.json" ]; then
  echo "BLOCKED: .claude/settings.json is a protected file and cannot be modified." >&2
  exit 2
fi

# Block: .claude/hooks/*
if echo "$NORMALIZED" | grep -q '^\.claude/hooks/'; then
  echo "BLOCKED: Hook scripts in .claude/hooks/ are protected and cannot be modified." >&2
  exit 2
fi

# Block: CLAUDE.md
if [ "$NORMALIZED" = "CLAUDE.md" ]; then
  echo "BLOCKED: CLAUDE.md modification blocked. This file is managed by the StarterPack." >&2
  exit 2
fi

# All checks passed — allow
exit 0
