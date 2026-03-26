---
name: standards-catalog
description: Code standards and requirements reference - security, quality, accessibility, performance standards
---

# Standards Catalog

Condensed reference of essential standards. Each item: requirement + rationale.
Apply based on project tier — **lightweight** focuses on Security + Code Quality basics only.

---

## Security (OWASP Top 10 Essentials)

| # | Requirement | Why |
|---|-------------|-----|
| S1 | Validate and sanitize all user input on the server side | Prevents injection attacks (SQLi, XSS, command injection) |
| S2 | Use parameterized queries for all database operations | Eliminates SQL injection, the most common database attack |
| S3 | Encode output based on context (HTML, JS, URL, CSS) | Prevents cross-site scripting (XSS) |
| S4 | Implement authentication with proven libraries, never roll your own | Custom auth is almost always broken; use battle-tested solutions |
| S5 | Enforce authorization checks on every protected endpoint | Missing access control is the #1 web vulnerability (OWASP A01) |
| S6 | Store secrets in environment variables or a secrets manager, never in code | Hardcoded secrets end up in git history and get leaked |
| S7 | Use HTTPS everywhere and set secure cookie flags | Prevents data interception in transit |
| S8 | Implement rate limiting on authentication and public API endpoints | Prevents brute force and denial-of-service attacks |
| S9 | Keep dependencies updated and scan for known vulnerabilities | Known CVEs are the easiest attack vector |
| S10 | Log security events (auth failures, access denied) without logging sensitive data | Enables incident detection without creating data leak risk |

## Code Quality

| # | Requirement | Why |
|---|-------------|-----|
| Q1 | Use descriptive names — functions say what they do, variables say what they hold | Code is read 10x more than written; names are documentation |
| Q2 | Keep functions under 40 lines; extract when logic branches | Small functions are testable, readable, and reusable |
| Q3 | Handle errors explicitly — no empty catch blocks, no swallowed exceptions | Silent failures cause the hardest bugs to diagnose |
| Q4 | Use consistent code formatting (Prettier, Black, gofmt, etc.) | Eliminates style debates and makes diffs readable |
| Q5 | Write self-documenting code; add comments only for "why", not "what" | Redundant comments rot; intent comments stay valuable |
| Q6 | Avoid magic numbers and strings — use named constants | Makes code searchable and intent clear |
| Q7 | Follow single responsibility — one module/class does one thing | Reduces coupling and makes changes safer |
| Q8 | Keep dependencies minimal — every dependency is a liability | Fewer deps = smaller attack surface + less maintenance |
| Q9 | Use type safety where available (TypeScript, type hints, generics) | Catches errors at build time instead of runtime |
| Q10 | Structure project files by feature or domain, not by file type | Keeps related code together; easier to navigate |

## Testing

| # | Requirement | Why |
|---|-------------|-----|
| T1 | Write unit tests for all business logic and utility functions | Catches regressions before they reach users |
| T2 | Test both happy paths and error cases | Most bugs hide in error paths nobody tested |
| T3 | Use descriptive test names that explain the scenario and expected outcome | Test names are documentation of system behavior |
| T4 | No test should depend on another test's state or execution order | Dependent tests create flaky, unmaintainable suites |
| T5 | Mock external services (APIs, databases) in unit tests | Tests must be fast, reliable, and runnable offline |
| T6 | Write integration tests for critical user workflows (standard+ tiers) | Unit tests miss interaction bugs between components |
| T7 | Aim for 80%+ coverage on business logic (rigorous tier: 90%+) | Coverage gaps concentrate in untested code |
| T8 | Never commit tests that are skipped, ignored, or known-failing | Broken windows effect — ignored tests multiply |

## Accessibility (WCAG Core)

| # | Requirement | Why |
|---|-------------|-----|
| A1 | All images have meaningful alt text (or empty alt for decorative) | Screen readers need text alternatives for images |
| A2 | All interactive elements are keyboard accessible | Not everyone uses a mouse; some users rely on keyboard entirely |
| A3 | Color is never the only way to convey information | Color-blind users (8% of men) miss color-only signals |
| A4 | Form inputs have associated labels | Screen readers can't identify unlabeled inputs |
| A5 | Page has logical heading hierarchy (h1 > h2 > h3) | Assistive tech users navigate by headings |

## Performance

| # | Requirement | Why |
|---|-------------|-----|
| P1 | Database queries use indexes for filtered/sorted columns | Missing indexes turn millisecond queries into seconds |
| P2 | Avoid N+1 queries — use eager loading or batch fetching | N+1 is the most common cause of slow page loads with ORMs |
| P3 | Set appropriate cache headers for static assets | Reduces server load and improves repeat-visit speed |
| P4 | Paginate list endpoints — never return unbounded result sets | Unbounded queries crash servers and freeze UIs |
| P5 | Lazy-load heavy resources (images, scripts) below the fold | Improves initial page load time |

## API Design

| # | Requirement | Why |
|---|-------------|-----|
| R1 | Use consistent URL patterns and HTTP methods (GET reads, POST creates, etc.) | Predictable APIs are easier to use and debug |
| R2 | Validate request payloads and return 400 with clear error messages | Bad input should fail fast with helpful feedback |
| R3 | Use proper HTTP status codes (don't return 200 for errors) | Clients depend on status codes for error handling |
| R4 | Version your API if it has external consumers | Breaking changes without versioning break all clients |
| R5 | Return consistent response shapes (always same structure for success/error) | Inconsistent shapes cause client-side bugs |
