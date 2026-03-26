---
description: Overrides for rigorous quality tier — production SaaS, enterprise, regulated environments
---

# Rigorous Tier Additions

When the project is configured for rigorous tier, these additional requirements apply on top of all base rules.

## Mandatory Processes
- Full audit cycle required for every change — no exceptions
- Security scan required before any merge to main
- Code review by reviewer agent is mandatory and blocking
- All 8 quality gates enforced — no skipping permitted

## Additional Checks
- Performance impact assessment required for database schema or query changes
- Accessibility compliance check (WCAG 2.1 AA) required for all UI changes
- Load testing results required for new API endpoints
- Dependency audit: no new dependencies without license and security review

## Documentation Requirements
- API changes require updated OpenAPI/Swagger specs
- Architecture Decision Records (ADRs) for significant design choices
- Runbook updates for operational changes
- CHANGELOG.md entry mandatory for every merge

## Compliance
- All changes must be traceable to a ticket or requirement
- Audit trail: who changed what, when, and why — preserved in commit history
- Data handling changes require privacy impact assessment
