# Claude Code StarterPack

A drop-in configuration for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) that turns it into a structured project driver. Instead of just answering questions, Claude plans work, audits its own output, enforces scope, and runs quality gates — so the human stays in control without needing to micromanage.

Built from months of real-world iteration across software projects. Not a toy config, not a prompt dump. This is a working system with 7 hooks, 4 agents, 5 commands, 7 rule sets, 8 skills, and a test suite.

## What it does

**Structured workflow.** Every task follows Plan, Audit, Implement, Verify, Review. Claude proposes, you approve. Nothing happens without your say-so.

**Scope enforcement.** When you approve a plan, it declares which files will be touched. A hook blocks edits to anything outside that scope. No more "while I was at it" surprises.

**Proportional rigor.** Three tiers: Lightweight (scripts, experiments), Standard (most projects), Rigorous (production, regulated). The system adapts its process weight to what you're building. A weekend hack doesn't get the same ceremony as a payment system.

**Quality gates.** Eight gates from requirements through post-deploy. Each is a short checklist, not a 50-page document. The `/gate` command runs them.

**Specialized agents.** Four sub-agents with separated concerns — a planner that researches the codebase, an auditor that tries to break the plan, a verifier that proves acceptance criteria with evidence, and a reviewer that reads diffs with fresh eyes. They don't share context, which prevents groupthink.

**Git safety.** Hooks block force-pushes to main, `rm -rf`, hard resets, and other commands that tend to ruin your afternoon. Non-destructive commands pass through normally.

**Traceability.** Every significant operation (commits, deploys, package installs) gets logged automatically. PROGRESS.md tracks decisions, plans, and results. You always know what happened and why.

**Session continuity.** Claude picks up where it left off. Session start injects recent state, session end reminds about uncommitted work and open tasks.

**Multi-instance coordination.** If you run multiple Claude instances on the same project, the cowork rules prevent them from stepping on each other's files.

## What's in the box

```
CLAUDE.md                              Entry point — behavioral rules, workflow, reference router
.claude/
  settings.json                        Hook wiring and file access deny rules
  agents/
    planner.md                         Researches codebase, writes implementation plans
    auditor.md                         Finds flaws, gaps, and risks in plans
    verifier.md                        Proves acceptance criteria with file:line evidence
    reviewer.md                        Fresh-eyes code review from diffs only
  commands/
    plan.md                            /plan — create and audit an implementation plan
    gate.md                            /gate — run quality gate checklists
    verify.md                          /verify — verify acceptance criteria
    review.md                          /review — code review current changes
    status.md                          /status — show project status and open tasks
  hooks/
    session-start.sh                   Injects state on session start
    block-dangerous-git.sh             Blocks destructive git and shell commands
    scope-lock.sh                      Blocks edits outside declared scope
    protect-config.sh                  Prevents modification of framework files
    traceability-log.sh                Logs significant operations
    validate-config.sh                 Validates project config on each prompt
    session-checkpoint.sh              Reminds about uncommitted work on session end
  rules/
    safety.md                          Security rules — secrets, input handling, TLS
    code-standards.md                  Code quality — function size, nesting, change mgmt
    testing.md                         Test standards — coverage, mocking, naming
    api-conventions.md                 REST conventions — URLs, errors, pagination
    tier-lightweight.md                Overrides for lightweight projects
    tier-rigorous.md                   Additions for rigorous projects
    cowork.md                          Multi-instance coordination protocol
  skills/
    setup.md                           Interactive project setup questionnaire
    quality-gates.md                   8 quality gate definitions with checklists
    standards-catalog.md               50+ standards reference (security, quality, testing, a11y, perf, API)
    explain.md                         Explain any framework concept in plain language
    ci-cd-templates.md                 GitHub Actions templates (CI, security scan, deploy)
    methodology-iterative.md           Sprint-based workflow
    methodology-kanban.md              Continuous flow workflow
    cowork-setup.md                    Multi-instance setup and coordination
tests/
  test-hooks.sh                        Validates hook behavior (block/allow)
```

## Installation

1. Copy the contents of this repo into your project root:

```bash
# Clone the starterpack
git clone https://github.com/fpk81/claude-code-starterpack.git /tmp/sp

# Copy into your project (won't overwrite existing files)
cp -rn /tmp/sp/.claude your-project/
cp -n /tmp/sp/CLAUDE.md your-project/
cp -rn /tmp/sp/tests your-project/

# Clean up
rm -rf /tmp/sp
```

2. Start Claude Code in your project directory. It reads CLAUDE.md automatically.

3. Run `/plan setup` — Claude will walk you through an interactive setup that creates your `.project-config.json` (project name, tier, methodology).

That's it. The hooks, rules, and agents activate automatically based on your tier choice.

## Usage

The five commands cover the core workflow:

| Command | What it does |
|---------|-------------|
| `/plan` | Creates an implementation plan, runs it through the auditor, records it in PROGRESS.md |
| `/gate` | Runs a quality gate checklist (planning, implementation, verification, security, etc.) |
| `/verify` | Checks acceptance criteria against actual code with evidence |
| `/review` | Code review of current branch changes |
| `/status` | Shows current task, open items, git state, test results |

Typical flow: `/plan` your task, approve it, implement, `/verify` the results, `/review` the diff, `/gate` before merge.

For lightweight projects, most of this is optional. Claude adapts automatically — a 5-line bugfix won't trigger the full ceremony.

## How hooks work

Hooks are bash scripts that run at specific lifecycle points. They enforce rules mechanically — Claude doesn't choose whether to follow them.

| Hook | Trigger | What it does |
|------|---------|-------------|
| session-start | Session begins | Loads recent PROGRESS.md and config into context |
| block-dangerous-git | Before any shell command | Blocks force-push to main, rm -rf, hard reset |
| scope-lock | Before any file edit | Blocks edits outside declared scope |
| protect-config | Before any file edit | Blocks changes to CLAUDE.md, hooks, settings |
| traceability-log | After any shell command | Logs commits, deploys, installs to .trace-log |
| validate-config | On each user prompt | Checks .project-config.json structure |
| session-checkpoint | Session ends | Warns about uncommitted work and open tasks |

All hooks fail open — if a hook errors out, it allows the operation rather than blocking legitimate work.

## Tiers

**Lightweight** — For scripts, experiments, side projects. Skips formal planning for small changes. Testing recommended but not required for scripts under 100 lines. Only gates 2-3 enforced.

**Standard** — The default. Full planning/audit cycle for non-trivial work. Tests expected. Gates 0-4 available. Good balance of rigor and speed.

**Rigorous** — For production systems, regulated industries, anything where failure has real consequences. All 8 gates enforced. Security scans, performance assessments, accessibility checks, ADRs, and full audit trails mandatory.

## Design decisions

**Fail-open hooks.** If a hook script crashes, the operation proceeds. The system should never block legitimate work due to its own bugs.

**Scope lock via PROGRESS.md.** Plans declare which files they'll touch. The hook reads that declaration and blocks everything else. Simple mechanism, surprisingly effective at preventing scope creep.

**Separated agent concerns.** The planner never reviews code. The reviewer never reads the plan. The auditor tries to break things. This role separation prevents the rubber-stamp problem where the same entity creates and approves its own work.

**PROGRESS.md as single source of truth.** No hidden state, no ephemeral context. Everything goes into a file that persists across sessions. New session, same project state.

**No external dependencies.** The hooks use bash, python3, and standard Unix tools. No npm packages, no pip installs, no Docker required.

## Running tests

```bash
bash tests/test-hooks.sh
```

Tests validate that hooks correctly block dangerous operations and allow safe ones.

## Background

This was developed for real business use. The configuration went through multiple rounds of iteration and testing on actual projects before being published. The goal was to make Claude Code produce consistent, professional-grade output regardless of the user's technical background.

## License

Free to use, including commercially. Attribution required.

Created by Florian Kuschnigg, KS Management FlexCo.

If you use this in your own projects or build on it, include a reference to the original author and this repository.
