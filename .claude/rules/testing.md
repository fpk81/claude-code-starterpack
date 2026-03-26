---
paths:
  - "src/**"
  - "tests/**"
  - "test/**"
  - "**/*.test.*"
  - "**/*.spec.*"
---

# Testing Rules

Loaded when working with source or test files.

## Coverage Requirements
- Every new function containing logic MUST have at least one test
- No test bodies that are empty or always pass — tests must assert real behavior
- Integration tests required for all API endpoints

## Test Design
- Tests MUST be independent — no shared mutable state between tests
- Follow Arrange-Act-Assert (AAA) pattern in every test
- Test names describe the behavior: `should_return_404_when_user_not_found`
- One logical assertion per test — multiple asserts only when verifying one behavior

## Mocking Strategy
- Mock external dependencies (databases, APIs, file systems)
- Do NOT mock internal logic — test real implementations where possible
- Use fakes or in-memory implementations over complex mock setups

## Test Hygiene
- Tests must run in any order and produce the same results
- Clean up test data after each test — no leaking state
- Flaky tests are bugs — fix or quarantine immediately
