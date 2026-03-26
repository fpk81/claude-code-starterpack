# Code Standards — Universal Quality Rules

These rules apply to all code in the project regardless of language or tier.

## Structure & Readability
- Functions: max 50 lines, max 3 nesting levels, return early to reduce indentation
- Use meaningful, self-documenting names — if you need a comment to explain *what*, rename instead
- One function, one responsibility — extract when doing more than one thing

## Maintainability
- No `TODO`, `FIXME`, or `HACK` comments without a linked issue number
- No empty catch blocks or swallowed exceptions — handle, log, or re-throw
- Prefer composition over inheritance; favor interfaces over concrete dependencies
- DRY: extract after 3 occurrences, not before — premature abstraction is worse than duplication

## Change Management
- Breaking changes MUST be documented in CHANGELOG.md with migration instructions
- Deprecated code must include removal timeline and replacement guidance
- Every public API change needs updated type definitions, schemas, and validation

## API Contracts
- All API boundaries use typed interfaces or schemas
- Validate inputs at entry points; trust nothing from outside the system boundary
- Return consistent error shapes across all endpoints

## Code Review Expectations
- Every change should be reviewable in under 15 minutes — split large changes
- Commit messages explain *why*, not *what* — the diff shows the what
