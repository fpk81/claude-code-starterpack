---
name: quality-gates
description: Quality gate checklists for phase transitions - requirements, design, implementation, testing, deployment
---

# Quality Gates

Quality gates are checkpoints before moving to the next phase. Each gate has a short checklist.
Check `.project-config.json` for the tier — **lightweight** skips Gates 0-1 for small tasks.

---

## Gate 0: Requirements Complete

Before starting design or implementation, confirm scope is clear.

- [ ] Problem statement is written in one paragraph
- [ ] Acceptance criteria defined for each feature/story (Given/When/Then or simple bullet list)
- [ ] Out of scope items explicitly listed
- [ ] Key risks or unknowns identified
- [ ] User has confirmed requirements are correct

**Lightweight tier**: Skip for tasks under 1 hour of estimated work. Just confirm the user's intent verbally.

---

## Gate 1: Design Approved

Before writing production code, confirm the approach.

- [ ] Architecture or approach decided (document in PROGRESS.md or a design doc)
- [ ] Data model defined if applicable
- [ ] Key dependencies identified (libraries, APIs, services)
- [ ] No critical risks left unaddressed
- [ ] User has approved the design direction

**Lightweight tier**: Skip for straightforward tasks. A verbal "sounds good" is enough.

---

## Gate 2: Implementation Complete

Before moving to verification, confirm the code is ready.

- [ ] All acceptance criteria from Gate 0 are met
- [ ] Tests written and passing (unit tests at minimum; integration tests for standard+)
- [ ] No fake, stub, or placeholder implementations left in production code
- [ ] Error handling covers expected failure modes
- [ ] Code follows project conventions (naming, structure, formatting)
- [ ] No hardcoded secrets, credentials, or PII in code
- [ ] PROGRESS.md updated with what was built

**Lightweight tier**: Tests can be minimal. Focus on "does it work?" over "is it perfect?"

---

## Gate 3: Verification Passed

Before deploying, confirm quality via independent verification.

- [ ] Run the verifier agent (or manually test all acceptance criteria)
- [ ] All tests pass in a clean environment
- [ ] Run the reviewer agent (or conduct a self-review using the review checklist)
- [ ] No critical or high-severity issues remain open
- [ ] Security-sensitive changes reviewed for OWASP Top 10 basics

**Lightweight tier**: Manual testing is fine. Self-review instead of formal review.
**Rigorous tier**: Must use verifier and reviewer agents. Document evidence of each check.

---

## Gate 4: Deployment Ready

Before shipping to production or delivering to the user.

- [ ] Security scan passed (no known vulnerabilities in dependencies)
- [ ] Environment configuration documented (env vars, secrets, infrastructure)
- [ ] README or user-facing documentation updated
- [ ] PROGRESS.md updated with deployment status
- [ ] User informed and given any needed handoff instructions

**Lightweight tier**: Just confirm it works and the user has what they need.
**Rigorous tier**: Full deployment checklist. Rollback plan documented. Monitoring confirmed.

---

## How to Use Gates

1. Before transitioning phases, run through the relevant gate checklist
2. Mark items as checked or note exceptions
3. If a gate fails, fix the gaps before proceeding
4. For **rigorous** tier: record gate results in PROGRESS.md as an audit trail
5. Gates are guardrails, not bureaucracy — skip items that genuinely don't apply, but document why
