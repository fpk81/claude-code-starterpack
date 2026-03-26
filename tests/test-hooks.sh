#!/bin/bash
# test-hooks.sh — Validate all StarterPack v4 hooks
# Run from the starterpack-v4 directory: bash tests/test-hooks.sh

PASS=0
FAIL=0
HOOKS_DIR=".claude/hooks"

echo "=== StarterPack v4 Hook Tests ==="
echo ""

# Helper: test a hook with given input, expect a specific exit code
test_hook() {
  local name="$1"
  local hook="$2"
  local input="$3"
  local expected_exit="$4"
  local description="$5"

  echo "$input" | bash "$hook" >/dev/null 2>&1
  actual_exit=$?

  if [ "$actual_exit" -eq "$expected_exit" ]; then
    echo "  PASS: $description (exit $actual_exit)"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $description (expected exit $expected_exit, got $actual_exit)"
    FAIL=$((FAIL + 1))
  fi
}

echo "--- block-dangerous-git.sh ---"
test_hook "dangerous-git" "$HOOKS_DIR/block-dangerous-git.sh" \
  '{"tool_input":{"command":"git push --force origin main"}}' 2 \
  "Block force-push to main"

test_hook "dangerous-git" "$HOOKS_DIR/block-dangerous-git.sh" \
  '{"tool_input":{"command":"git reset --hard HEAD~3"}}' 2 \
  "Block git reset --hard"

test_hook "dangerous-git" "$HOOKS_DIR/block-dangerous-git.sh" \
  '{"tool_input":{"command":"rm -rf /"}}' 2 \
  "Block rm -rf"

test_hook "dangerous-git" "$HOOKS_DIR/block-dangerous-git.sh" \
  '{"tool_input":{"command":"git add src/main.ts"}}' 0 \
  "Allow safe git add"

test_hook "dangerous-git" "$HOOKS_DIR/block-dangerous-git.sh" \
  '{"tool_input":{"command":"npm install express"}}' 0 \
  "Allow npm install"

echo ""
echo "--- protect-config.sh ---"
test_hook "protect-config" "$HOOKS_DIR/protect-config.sh" \
  '{"tool_input":{"file_path":".claude/settings.json"}}' 2 \
  "Block settings.json edit"

test_hook "protect-config" "$HOOKS_DIR/protect-config.sh" \
  '{"tool_input":{"file_path":".claude/hooks/block-dangerous-git.sh"}}' 2 \
  "Block hook edit"

test_hook "protect-config" "$HOOKS_DIR/protect-config.sh" \
  '{"tool_input":{"file_path":"CLAUDE.md"}}' 2 \
  "Block CLAUDE.md edit"

test_hook "protect-config" "$HOOKS_DIR/protect-config.sh" \
  '{"tool_input":{"file_path":"src/app.ts"}}' 0 \
  "Allow normal file edit"

echo ""
echo "--- session-checkpoint.sh ---"
bash "$HOOKS_DIR/session-checkpoint.sh" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "  PASS: session-checkpoint runs without error"
  PASS=$((PASS + 1))
else
  echo "  FAIL: session-checkpoint crashed"
  FAIL=$((FAIL + 1))
fi

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
if [ $FAIL -gt 0 ]; then
  exit 1
fi
exit 0
