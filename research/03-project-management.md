# Research Report: Large Project Management with AI Coding Agents

## Metadata
- **Report ID**: 03
- **Agent Role**: AI Project Management Specialist
- **Date**: 2026-03-25
- **Sources Consulted**: 8
- **Confidence Level**: HIGH

## Executive Summary
- Claude Code's task tracking evolved from the simple TodoWrite checklist tool to a full Tasks API (v2.1.16, January 2026) with dependency tracking, file-system persistence, and cross-session collaboration -- StarterPack should account for both systems.
- Anthropic's official best practices emphasize verification as the single highest-leverage practice: provide tests, screenshots, or expected outputs so Claude can self-check, which aligns strongly with the StarterPack's Guardian/gate model.
- Context window management is the dominant constraint in large project management -- Anthropic recommends aggressive `/clear` usage, subagent delegation, and scoped investigations rather than monolithic long-running sessions.
- Industry consensus (2025-2026) treats all AI-generated code as a draft requiring human review, staged implementation, and incremental commits -- the StarterPack's multi-gate approach is well-aligned with this pattern.
- The explore-then-plan-then-code-then-commit four-phase workflow from Anthropic's docs maps closely to the StarterPack's Guardian checkpoint model but reveals opportunities for tighter integration with Claude Code's native Plan Mode and subagent features.

## Findings

### Finding 03-001: TodoWrite Replaced by Tasks API
- **Source**: https://medium.com/@joe.njenga/claude-code-tasks-are-here-new-update-turns-claude-code-todos-to-tasks-a0be00e70847
- **Category**: TOOLING
- **Relevance**: HIGH
- **Summary**: As of January 2026, Claude Code v2.1.16 replaced TodoWrite with a Tasks API offering five specialized tools (TaskCreate, TaskList, TaskGet, TaskUpdate) with filesystem persistence and cross-session collaboration. Tasks now support dependency tracking via addBlockedBy parameters. The old TodoWrite remains available via opt-out flag.
- **Key Insight**: StarterPack's traceability system (.claude-traceability-state) should integrate with or reference the native Tasks API for story/task tracking rather than relying solely on custom file-based state.
- **Raw Evidence**: "This shifts from simple checklists to proper project management with dependencies, blockers, and multi-session collaboration."

### Finding 03-002: Context Window is the Primary Project Management Constraint
- **Source**: https://code.claude.com/docs/en/best-practices
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: Anthropic's official best practices document states that "Most best practices are based on one constraint: Claude's context window fills up fast, and performance degrades as it fills." This applies directly to project management workflows that involve reading backlog files, quality management logs, project plans, and configuration files at session start.
- **Key Insight**: The StarterPack's session start protocol loads multiple files which may consume significant context budget before any productive work begins.
- **Raw Evidence**: "LLM performance degrades as context fills. When the context window is getting full, Claude may start 'forgetting' earlier instructions or making more mistakes."

### Finding 03-003: Verification is the Single Highest-Leverage Practice
- **Source**: https://code.claude.com/docs/en/best-practices
- **Category**: QUALITY_ASSURANCE
- **Relevance**: HIGH
- **Summary**: Anthropic explicitly identifies providing verification criteria as "the single highest-leverage thing you can do." The recommendation is to include tests, screenshots, or expected outputs so Claude can check itself. Without clear success criteria, Claude "might produce something that looks right but actually doesn't work."
- **Key Insight**: The StarterPack's Verification Guardian and Quality Guardian align perfectly with this guidance, but should emphasize automated verification (test execution, build validation) over checklist-based verification.
- **Raw Evidence**: "Claude performs dramatically better when it can verify its own work, like run tests, compare screenshots, and validate outputs."

### Finding 03-004: Explore-Plan-Implement-Commit Workflow
- **Source**: https://code.claude.com/docs/en/best-practices
- **Category**: WORKFLOW
- **Relevance**: HIGH
- **Summary**: Anthropic recommends a four-phase workflow: (1) Explore in Plan Mode, (2) Plan with detailed implementation steps, (3) Implement in Normal Mode with verification, (4) Commit with descriptive message. This maps to the StarterPack's Context Guardian -> Per-Step Protocol -> Verification Guardian -> Quality Guardian flow, but the StarterPack does not leverage Claude Code's native Plan Mode.
- **Key Insight**: The StarterPack should reference Plan Mode (Ctrl+G) as a recommended tool during the Context Guardian phase rather than relying solely on the guardian subagent pattern.
- **Raw Evidence**: "Letting Claude jump straight to coding can produce code that solves the wrong problem. Use Plan Mode to separate exploration from execution."

### Finding 03-005: Treat AI Output as Draft -- Multi-Stage Verification
- **Source**: https://medium.com/@elisheba.t.anderson/building-with-ai-coding-agents-best-practices-for-agent-workflows-be1d7095901b
- **Category**: QUALITY_ASSURANCE
- **Relevance**: HIGH
- **Summary**: Industry consensus in 2025-2026 is to treat every AI output as a draft requiring human oversight. Best practice is to break AI tasks into controlled stages: outline approach, request pseudocode, review logic, generate code in smaller testable pieces, then integrate. This multi-step pattern reduces "silent drift" caused by untracked edits.
- **Key Insight**: The StarterPack's per-step protocol with "WHY before HOW" and approval checkpoints directly implements this industry best practice, validating its design.
- **Raw Evidence**: "By 2025, AI code generation is powerful enough to build 60-70% of a system's baseline logic, but experts know: raw AI output is never the final version."

### Finding 03-006: Subagents for Context-Efficient Investigation
- **Source**: https://code.claude.com/docs/en/best-practices
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: Anthropic recommends using subagents for research and investigation tasks because they run in separate context windows and report back summaries. This keeps the main conversation clean for implementation. The StarterPack's Guardian system already uses subagent patterns but may not leverage Claude Code's native subagent infrastructure.
- **Key Insight**: Guardian prompts could be implemented as native Claude Code subagents (`.claude/agents/`) rather than inline conversation prompts, preserving main context for productive work.
- **Raw Evidence**: "Since context is your fundamental constraint, subagents are one of the most powerful tools available."

### Finding 03-007: Aggressive Context Clearing Between Tasks
- **Source**: https://code.claude.com/docs/en/best-practices
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: MEDIUM
- **Summary**: Anthropic identifies "the kitchen sink session" as a common failure pattern where unrelated tasks pollute context. They recommend `/clear` between unrelated tasks and warn that after two failed corrections, you should start fresh. Claude Code effectiveness drops after approximately 10-20 minutes of autonomous work as context fills up.
- **Key Insight**: The StarterPack should recommend `/clear` between story completions and explicitly warn users about context degradation in long sessions.
- **Raw Evidence**: "If you've corrected Claude more than twice on the same issue in one session, the context is cluttered with failed approaches. Run /clear and start fresh."

### Finding 03-008: TaskList Metadata Limitation
- **Source**: https://deepwiki.com/FlorianBruniaux/claude-code-ultimate-guide/7-task-management
- **Category**: TOOLING
- **Relevance**: MEDIUM
- **Summary**: A known limitation of the Tasks API is that TaskList omits description and all metadata fields, requiring individual TaskGet calls to access full task information. The recommendation is to use Tasks API for status tracking and markdown files for knowledge storage -- a hybrid approach.
- **Key Insight**: The StarterPack's use of markdown files (.backlog.md, .project-plan.md) for knowledge storage alongside task tracking is actually the recommended hybrid pattern.
- **Raw Evidence**: "Use Tasks API for status tracking, and markdown files for knowledge storage."

### Finding 03-009: Parallel Sessions for Quality -- Writer/Reviewer Pattern
- **Source**: https://code.claude.com/docs/en/best-practices
- **Category**: WORKFLOW
- **Relevance**: MEDIUM
- **Summary**: Anthropic recommends using separate Claude sessions for writing and reviewing code, noting that "a fresh context improves code review since Claude won't be biased toward code it just wrote." This maps to a formal separation of concerns in the development workflow.
- **Key Insight**: The StarterPack's Guardian system (especially Verification Guardian) could benefit from being run in a separate session/context to avoid confirmation bias.
- **Raw Evidence**: "Use a Writer/Reviewer pattern: Session A implements, Session B reviews with fresh context."

### Finding 03-010: CLAUDE.md Bloat Causes Instruction Ignoring
- **Source**: https://code.claude.com/docs/en/best-practices
- **Category**: CONFIGURATION
- **Relevance**: HIGH
- **Summary**: Anthropic explicitly warns that overly long CLAUDE.md files cause Claude to ignore instructions: "If Claude keeps doing something you don't want despite having a rule against it, the file is probably too long and the rule is getting lost." They recommend ruthless pruning and converting behavioral rules to hooks where possible.
- **Key Insight**: The StarterPack's CLAUDE.md is designed to be comprehensive but must carefully balance completeness against the risk of instruction dilution from token overload.
- **Raw Evidence**: "For each line, ask: 'Would removing this cause Claude to make mistakes?' If not, cut it. Bloated CLAUDE.md files cause Claude to ignore your actual instructions!"

## Synthesis

### Recommended Project Workflow with Claude Code
1. **Session initialization**: Load minimal context -- read only the files needed for the current task, not the entire project state. Use `/clear` to start clean. (Rationale: Context window is the primary constraint; loading unnecessary files degrades performance.)
2. **Task scoping with Plan Mode**: Enter Plan Mode to explore the codebase and create a focused implementation plan before writing code. (Rationale: Anthropic's official recommendation; prevents solving the wrong problem.)
3. **Context Guardian as subagent**: Spawn the Context Guardian as a native Claude Code subagent to analyze requirements without consuming main context. (Rationale: Subagents preserve main context for implementation.)
4. **Incremental implementation with verification**: Implement in small, testable increments. After each increment, run tests or validation scripts. (Rationale: Industry consensus treats AI output as draft; verification is the highest-leverage practice.)
5. **Verification Guardian in fresh context**: Run verification in a separate session or subagent to avoid confirmation bias. (Rationale: Writer/Reviewer separation improves review quality.)
6. **Commit with Quality Guardian**: Run quality checks, produce guardian verdict, commit with conventional message. (Rationale: Deterministic quality gates catch issues human review may miss.)
7. **Context cleanup**: Run `/clear` after completing a story before starting the next one. (Rationale: Prevents "kitchen sink session" anti-pattern.)

### Verification Checklist (Before Marking Task Done)
- [ ] All acceptance criteria from the story/task are explicitly verified (not assumed)
- [ ] Automated tests pass (unit, integration as applicable)
- [ ] Build succeeds without warnings relevant to changed code
- [ ] `git diff` reviewed for unintended changes or leftover debugging code
- [ ] Verification Guardian or independent review confirms completeness
- [ ] Quality Guardian produces PASS verdict with matching diff hash
- [ ] Traceability state updated with story/task completion
- [ ] No TODO/FIXME introduced without linked issue
- [ ] Context cleared or compacted before starting next task

### Anti-Patterns in AI Project Management
1. **Monolithic session overload**: Running an entire sprint's worth of work in a single Claude session without clearing context. Performance degrades as context fills, causing Claude to "forget" earlier requirements and make increasingly poor decisions. Fix: One story per session, `/clear` between stories.
2. **Checklist-only verification**: Relying on checklist-based guardian prompts without automated test execution. Claude can mark checklist items as "done" without actually verifying them programmatically. Fix: Always pair guardian checklists with executable verification (test suites, build commands, linter runs).
3. **Front-loaded context consumption**: Loading all project state files (backlog, quality management, traceability, config) at session start before knowing which are needed. Fix: Load only the minimal set needed for the current task; use on-demand file loading for reference material.
4. **Guardian confirmation bias**: Running verification guardians in the same context that produced the code. The guardian has access to the implementation reasoning and may be biased toward confirming correctness. Fix: Use separate sessions or native subagents for independent verification.
5. **Over-specified CLAUDE.md**: Including so many rules in CLAUDE.md that critical instructions get lost in the noise. Anthropic explicitly warns this causes instruction ignoring. Fix: Move enforceable rules to hooks (deterministic), keep CLAUDE.md for judgment-requiring guidance only, and prune ruthlessly.

## Source Registry
| # | Source | URL | Type | Date Accessed |
|---|--------|-----|------|---------------|
| 1 | Anthropic Claude Code Best Practices | https://code.claude.com/docs/en/best-practices | Official Documentation | 2026-03-25 |
| 2 | Claude Code Tasks Update (Joe Njenga) | https://medium.com/@joe.njenga/claude-code-tasks-are-here-new-update-turns-claude-code-todos-to-tasks-a0be00e70847 | Blog Post | 2026-03-25 |
| 3 | Building With AI Coding Agents (Elisheba Anderson) | https://medium.com/@elisheba.t.anderson/building-with-ai-coding-agents-best-practices-for-agent-workflows-be1d7095901b | Blog Post | 2026-03-25 |
| 4 | AI Coding Best Practices 2025 (DEV Community) | https://dev.to/ranndy360/ai-coding-best-practices-in-2025-4eel | Blog Post | 2026-03-25 |
| 5 | Claude Code Ultimate Guide - Task Management (DeepWiki) | https://deepwiki.com/FlorianBruniaux/claude-code-ultimate-guide/7-task-management | Wiki | 2026-03-25 |
| 6 | Best Practices for AI Coding Agents (Augment Code) | https://www.augmentcode.com/blog/best-practices-for-using-ai-coding-agents | Blog Post | 2026-03-25 |
| 7 | Claude Code as Project Manager (Ben Newton) | https://benenewton.com/blog/claude-code-roadmap-management | Blog Post | 2026-03-25 |
| 8 | Agent Evaluation Deep Dive (Google Cloud) | https://cloud.google.com/blog/topics/developers-practitioners/agent-factory-recap-a-deep-dive-into-agent-evaluation-practical-tooling-and-multi-agent-systems | Blog Post | 2026-03-25 |
