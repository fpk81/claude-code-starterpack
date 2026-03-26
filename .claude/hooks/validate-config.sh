#!/bin/bash
# validate-config.sh — UserPromptSubmit hook
# Validates .project-config.json structure on each user prompt.
# Only runs the check if the file exists and has been modified recently.
# Intentionally NO set -e: fail-open on errors.

CONFIG_FILE=".project-config.json"

# If no config file, nothing to validate
if [ ! -f "$CONFIG_FILE" ]; then
  exit 0
fi

# Quick JSON syntax check using python3 if available, else try node
if command -v python3 &>/dev/null; then
  if ! python3 -c "import json; json.load(open('$CONFIG_FILE'))" 2>/dev/null; then
    echo "WARNING: .project-config.json has invalid JSON syntax. Run setup to fix." >&2
    exit 0  # Warn but don't block
  fi
elif command -v node &>/dev/null; then
  if ! node -e "JSON.parse(require('fs').readFileSync('$CONFIG_FILE','utf8'))" 2>/dev/null; then
    echo "WARNING: .project-config.json has invalid JSON syntax. Run setup to fix." >&2
    exit 0
  fi
fi

# If we can parse it, check for required fields
if command -v python3 &>/dev/null; then
  MISSING=$(python3 -c "
import json, sys
try:
    c = json.load(open('$CONFIG_FILE'))
    required = ['version', 'project', 'tier', 'methodology']
    missing = [r for r in required if r not in c]
    if missing:
        print('Missing fields: ' + ', '.join(missing))
except:
    pass
" 2>/dev/null)
  if [ -n "$MISSING" ]; then
    echo "WARNING: .project-config.json is incomplete. $MISSING. Run /setup to fix." >&2
  fi
fi

exit 0
