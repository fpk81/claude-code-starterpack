---
description: Overrides for lightweight quality tier — small scripts, personal projects, prototypes
---

# Lightweight Tier Adjustments

When the project is configured for lightweight tier, these overrides apply.

## Simplified Workflow
- Skip formal planning for tasks under 20 lines of change
- Inline verification instead of spawning a separate verifier agent
- Simplified commit protocol — no guardian verdicts required
- Code review is advisory, not blocking

## Reduced Gates
- Only Gate 2 (implementation quality) and Gate 3 (basic verification) are enforced
- Gates 1, 4-8 are skipped unless explicitly requested

## Relaxed Requirements
- Testing: recommended but not mandatory for scripts under 100 lines
- Documentation: inline comments sufficient — no formal docs required
- CHANGELOG updates optional for non-breaking changes
- Security rules from `safety.md` still apply in full — no exceptions
