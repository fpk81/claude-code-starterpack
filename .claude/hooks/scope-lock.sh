#!/bin/bash
# scope-lock.sh — PreToolUse hook for Edit|Write tools
# Prevents edits to files outside the declared scope in PROGRESS.md.
# Exit 2 = block. Exit 0 = allow.
# Fails open: if PROGRESS.md is missing or has no scope section, all edits allowed.

# Intentionally NO set -e: fail-open on unexpected errors.

PROGRESS_FILE="PROGRESS.md"

# If PROGRESS.md doesn't exist, fail open — no scope lock active
if [ ! -f "$PROGRESS_FILE" ]; then
  exit 0
fi

# Read JSON input from stdin
INPUT=$(cat)

# Extract the file_path from tool_input
# Handle both "file_path" and "path" field names
FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
fi

# If we couldn't extract a file path, fail open
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Extract the scope section from PROGRESS.md
# Look for a section like "## Scope" or "## Files in Scope" followed by file paths
SCOPE_SECTION=$(sed -n '/^##.*[Ss]cope/,/^##/p' "$PROGRESS_FILE" 2>/dev/null | head -50)

# If no scope section found, fail open
if [ -z "$SCOPE_SECTION" ]; then
  exit 0
fi

# Extract file paths from the scope section (lines starting with - or * followed by a path)
SCOPE_FILES=$(echo "$SCOPE_SECTION" | grep -oE '[-*]\s+`?[^`\s]+`?' | sed 's/^[-*]\s*`\?//;s/`\?$//' | grep -v '^$')

# If no files listed in scope, fail open
if [ -z "$SCOPE_FILES" ]; then
  exit 0
fi

# Normalize the target file path (strip leading ./)
NORMALIZED_PATH=$(echo "$FILE_PATH" | sed 's|^\./||')

# Always allow edits to PROGRESS.md and common project files
case "$NORMALIZED_PATH" in
  PROGRESS.md|CHANGELOG.md|.project-config.json|.trace-log)
    exit 0
    ;;
esac

# Check if the file is in scope
while IFS= read -r scope_file; do
  # Normalize scope file path
  scope_normalized=$(echo "$scope_file" | sed 's|^\./||')

  # Exact match
  if [ "$NORMALIZED_PATH" = "$scope_normalized" ]; then
    exit 0
  fi

  # Check if scope entry is a directory pattern (ends with / or /*)
  dir_pattern=$(echo "$scope_normalized" | sed 's|/\*$||; s|/$||')
  if echo "$NORMALIZED_PATH" | grep -q "^${dir_pattern}/"; then
    exit 0
  fi
done <<< "$SCOPE_FILES"

# File not in scope — block
echo "BLOCKED: '$FILE_PATH' is outside the declared scope in PROGRESS.md." >&2
echo "Add this file to the ## Scope section in PROGRESS.md before editing." >&2
exit 2
