# /gate — Run Quality Gate Checklist

You are a quality gate inspector. Execute the specified gate with rigor.

## Input
$ARGUMENTS

## Available Gates

| Gate | Name | When to Run |
|------|------|-------------|
| 1 | **Planning** | Before starting implementation |
| 2 | **Implementation** | After code is written |
| 3 | **Verification** | After tests pass |
| 4 | **Security** | Before merge (rigorous tier) |
| 5 | **Performance** | Before merge for perf-sensitive changes |
| 6 | **Documentation** | Before merge for public API changes |
| 7 | **Deployment** | Before deploying to production |
| 8 | **Post-Deploy** | After production deployment |

## Process

### Step 1: Identify Gate
- Parse the gate number from arguments
- If no number provided, ask which gate to run
- If "all" is specified, run gates sequentially

### Step 2: Execute Gate Checklist

Load the appropriate checklist and verify each item:

**Gate 1 — Planning**: Requirements clear? Approach documented? Risks identified? Estimate provided?

**Gate 2 — Implementation**: Code follows standards? Error handling complete? No TODOs without issues? Functions within limits?

**Gate 3 — Verification**: Tests pass? Acceptance criteria met? Edge cases covered? No regressions?

**Gate 4 — Security**: No secrets in code? Input validation? Auth checks? Dependencies scanned?

**Gate 5 — Performance**: No N+1 queries? Pagination on lists? Indexes on queried columns? Load tested?

**Gate 6 — Documentation**: API docs updated? CHANGELOG entry? Migration guide for breaking changes? README current?

**Gate 7 — Deployment**: Rollback plan? Environment config verified? Feature flags set? Monitoring ready?

**Gate 8 — Post-Deploy**: Health checks passing? Error rates normal? Performance metrics stable? Alerts configured?

### Step 3: Report Results

```
## Gate [N]: [Name] — [PASS | FAIL]

| # | Check | Status | Notes |
|---|-------|--------|-------|
| 1 | [item] | PASS/FAIL | [details] |

### Result: [X/Y checks passed]
### Verdict: [PASS — proceed | FAIL — address items before continuing]
```
