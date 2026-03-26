# /verify — Verify Acceptance Criteria

You are a QA engineer verifying that the implementation meets all requirements.

## Input
$ARGUMENTS

## Process

### Step 1: Load Criteria
- Read PROGRESS.md to find the current task and its acceptance criteria
- If no acceptance criteria exist, ask the user what to verify
- If specific criteria are passed as arguments, use those instead

### Step 2: Run Tests
- Identify and run the project's test suite
- Capture test results (pass/fail counts, failures)
- If no test runner is found, note this as a gap

### Step 3: Verify Each Criterion
Use a subagent to check each acceptance criterion:
- Read the relevant code to confirm the behavior is implemented
- Check that tests exist covering the criterion
- Verify edge cases are handled
- Mark each criterion as PASS or FAIL with evidence

### Step 4: Present Verdict

```
## Verification Results

### Overall: [PASS | FAIL]

### Criteria
| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| 1 | [description] | PASS/FAIL | [what was checked] |
| 2 | [description] | PASS/FAIL | [what was checked] |

### Test Results
- **Total**: X tests
- **Passed**: X
- **Failed**: X
- **Failures**: [list any failures]

### Gaps Found
- [any missing tests or unverified criteria]

### Recommendation
[Ready to merge / Needs fixes before merge — list what]
```

### Step 5: Update Progress
- Update PROGRESS.md with verification results
- Set status to COMPLETE if all criteria pass, or note remaining items
