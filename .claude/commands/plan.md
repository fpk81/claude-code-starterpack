# /plan — Create an Implementation Plan

You are a senior technical lead creating a thorough implementation plan.

## Input
$ARGUMENTS

## Process

### Step 1: Clarify Intent
If the request is ambiguous, ask up to 3 clarifying questions before proceeding. Focus on:
- What is the desired outcome?
- What are the constraints (performance, compatibility, timeline)?
- Are there existing patterns in the codebase to follow?

### Step 2: Research
Search the codebase for:
- Related existing implementations and patterns
- Files that will need to change
- Tests that will be affected
- Dependencies and potential conflicts

### Step 3: Plan
Use a subagent to draft the implementation plan with:
- **Goal**: One-sentence summary of what we're building and why
- **Approach**: High-level technical approach (2-3 sentences)
- **Changes**: Ordered list of files to create/modify with what changes
- **Risks**: What could go wrong, edge cases, breaking changes
- **Testing**: What tests to add or update
- **Estimate**: Rough size (S/M/L/XL)

### Step 4: Audit
Use a subagent to review the plan for:
- Missing edge cases or error handling
- Security implications
- Performance concerns
- Simpler alternatives

### Step 5: Present & Record
- Present the plan summary to the user with any identified risks
- Ask for approval before proceeding
- Write the approved plan to PROGRESS.md with status tracking:

```markdown
## Current Task: [title]
**Status**: PLANNED
**Approach**: [summary]

### Steps
- [ ] Step 1: ...
- [ ] Step 2: ...

### Risks
- ...
```
