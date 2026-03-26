#!/bin/bash
# traceability-log.sh — PostToolUse hook for Bash tool
# Logs significant operations to .trace-log for traceability.
# Never blocks (PostToolUse cannot block). Fails silently on errors.

# Do NOT use set -e — this script must never fail visibly
set +e

TRACE_FILE=".trace-log"

# Read JSON input from stdin
INPUT=$(cat 2>/dev/null) || true

# Extract the command from tool_input
COMMAND=$(echo "$INPUT" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\(.*\)"/\1/p' 2>/dev/null | head -1) || true

# If no command extracted, nothing to log
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Determine if this is a significant operation worth logging
SIGNIFICANT=false
SUMMARY=""

case "$COMMAND" in
  *"git commit"*)   SIGNIFICANT=true; SUMMARY="git-commit" ;;
  *"git merge"*)    SIGNIFICANT=true; SUMMARY="git-merge" ;;
  *"git push"*)     SIGNIFICANT=true; SUMMARY="git-push" ;;
  *"git pull"*)     SIGNIFICANT=true; SUMMARY="git-pull" ;;
  *"git checkout"*) SIGNIFICANT=true; SUMMARY="git-checkout" ;;
  *"git branch"*)   SIGNIFICANT=true; SUMMARY="git-branch" ;;
  *"npm install"*)  SIGNIFICANT=true; SUMMARY="npm-install" ;;
  *"npm run"*)      SIGNIFICANT=true; SUMMARY="npm-run" ;;
  *"yarn "*)        SIGNIFICANT=true; SUMMARY="yarn-cmd" ;;
  *"pip install"*)  SIGNIFICANT=true; SUMMARY="pip-install" ;;
  *"docker "*)      SIGNIFICANT=true; SUMMARY="docker-cmd" ;;
  *"make "*)        SIGNIFICANT=true; SUMMARY="make-cmd" ;;
  *"cargo "*)       SIGNIFICANT=true; SUMMARY="cargo-cmd" ;;
  *"chmod "*)       SIGNIFICANT=true; SUMMARY="chmod" ;;
  *"mv "*)          SIGNIFICANT=true; SUMMARY="file-move" ;;
  *"cp "*)          SIGNIFICANT=true; SUMMARY="file-copy" ;;
  *"rm "*)          SIGNIFICANT=true; SUMMARY="file-remove" ;;
  *"mkdir "*)       SIGNIFICANT=true; SUMMARY="dir-create" ;;
esac

if [ "$SIGNIFICANT" = false ]; then
  exit 0
fi

# Truncate command for log entry (first 120 chars)
CMD_SHORT=$(echo "$COMMAND" | head -1 | cut -c1-120)

# Append log entry — fail silently if we can't write
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || echo "unknown-time")
echo "${TIMESTAMP} [${SUMMARY}] ${CMD_SHORT}" >> "$TRACE_FILE" 2>/dev/null || true

exit 0
