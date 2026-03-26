# Research Report: Anthropic Official Sources Analysis

## Metadata
- **Report ID**: 01
- **Agent Role**: Anthropic Official Sources Analyst
- **Date**: 2026-03-25
- **Sources Consulted**: 7
- **Confidence Level**: HIGH

## Executive Summary
- Anthropic's official Claude Code best practices emphasize a "research and plan first" workflow, CLAUDE.md files as the primary context injection mechanism, and hooks for deterministic enforcement -- all patterns the StarterPack leverages heavily.
- Anthropic's context engineering guidance (September 2025) treats context as a finite "attention budget" and recommends progressive disclosure, minimal viable tool sets, and structured note-taking -- raising questions about whether the StarterPack's large reference files risk context rot.
- Hooks in Claude Code communicate via exit codes and stdout; SessionStart and UserPromptSubmit hooks can inject context, while exit code 2 blocks actions with stderr feedback -- the StarterPack's 13-hook architecture aligns with this but should be evaluated for timeout and parallelization implications.
- Anthropic recommends CLAUDE.md for persistent static context and hooks for dynamic context injection, with a clear preference for keeping prompts "specific enough to guide behavior effectively, yet flexible enough to provide strong heuristics."
- The Agent Skills format (December 2025) introduces progressive disclosure of instructions via markdown files with YAML frontmatter, loading only ~80 tokens at startup and expanding on demand -- a pattern the StarterPack could adopt for its large reference catalogs.

## Findings

### Finding 01-001: CLAUDE.md as Primary Context Mechanism
- **Source**: https://docs.anthropic.com/en/docs/claude-code/hooks-guide
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: Anthropic's hooks guide explicitly states: "For injecting context on every session start, consider using CLAUDE.md instead." CLAUDE.md is the officially recommended mechanism for persistent, static context that should be available at the start of every session.
- **Key Insight**: The StarterPack's use of CLAUDE.md as the entry point and universal guardrails file aligns directly with Anthropic's official recommendation.
- **Raw Evidence**: "For injecting context on every session start, consider using CLAUDE.md instead. Hooks provide deterministic control over Claude Code's behavior, ensuring certain actions always happen rather than relying on the LLM to choose to run them."

### Finding 01-002: Context as Finite Attention Budget
- **Source**: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: Anthropic's context engineering guide frames context as a "precious, finite resource" subject to "context rot" -- as tokens increase, recall accuracy decreases. Every token depletes an agent's attention budget. The StarterPack loads substantial reference material (~251 requirements, ~529 standards entries, 8 quality gate checklists) which may push against this limit.
- **Key Insight**: The StarterPack's large reference files risk degrading Claude's performance through context window pollution if loaded all at once.
- **Raw Evidence**: "LLMs experience 'context rot' -- as tokens increase, recall accuracy decreases. Every token depletes an agent's attention budget, making careful curation essential."

### Finding 01-003: Progressive Disclosure Pattern
- **Source**: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: Anthropic recommends progressive disclosure: maintain lightweight identifiers (file paths, URLs, queries) and dynamically load context at runtime rather than pre-loading all data. The Agent Skills format (December 2025) embodies this by loading only name and description (~80 tokens) at startup and expanding full instructions only when relevant.
- **Key Insight**: The StarterPack should adopt a progressive disclosure pattern for its large reference catalogs rather than relying on Claude to load entire files.
- **Raw Evidence**: "Instead of pre-loading all data, maintain lightweight identifiers (file paths, URLs, queries) and dynamically load context at runtime. This mirrors human cognition -- using external indexing systems rather than memorizing everything."

### Finding 01-004: Research and Plan First Workflow
- **Source**: https://www.anthropic.com/engineering/claude-code-best-practices
- **Category**: WORKFLOW
- **Relevance**: HIGH
- **Summary**: Anthropic's best practices emphasize that without explicit "research and plan first" instructions, Claude tends to jump straight to coding. The StarterPack's guardian checkpoints and quality gates enforce a similar planning-before-execution pattern, which is well-aligned with official guidance.
- **Key Insight**: The StarterPack's guardian checkpoint system directly implements Anthropic's recommended "research and plan first" workflow pattern.
- **Raw Evidence**: "Steps #1-#2 are crucial -- without them, Claude tends to jump straight to coding a solution. Asking Claude to research and plan first significantly improves performance for problems requiring deeper thinking upfront."

### Finding 01-005: Hook Architecture and Exit Code Protocol
- **Source**: https://docs.anthropic.com/en/docs/claude-code/hooks
- **Category**: CONFIGURATION
- **Relevance**: HIGH
- **Summary**: Claude Code hooks use specific exit code semantics: exit 0 = success (stdout shown in transcript only, except UserPromptSubmit where it becomes context), exit 2 = block action (stderr fed back to Claude). Hooks have a 60-second default timeout and run in parallel. The StarterPack's 13 hooks need to respect these constraints.
- **Key Insight**: Hook scripts that exceed 60 seconds or produce excessive stdout may silently fail or pollute context, making timeout management critical for the StarterPack's hook-heavy architecture.
- **Raw Evidence**: "Exit code 0: Success. stdout is shown to the user in transcript mode (CTRL-R), except for UserPromptSubmit, where stdout is added to the context. Timeout: 60-second execution limit by default, configurable per command."

### Finding 01-006: Minimal Viable Tool Set Principle
- **Source**: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **Category**: TOOLING
- **Relevance**: MEDIUM
- **Summary**: Anthropic advises maintaining a "minimal viable set" of tools with minimal functional overlap to improve maintenance and context pruning. Tool overlap creates "ambiguous decision points" that confuse both humans and agents. The StarterPack provides 11 slash commands and 13 hooks -- the overlap and redundancy between these should be evaluated.
- **Key Insight**: Each additional tool/command/hook adds cognitive load for both Claude and the user; the StarterPack should audit for overlap between its 11 commands and 13 hooks.
- **Raw Evidence**: "Build self-contained, unambiguous tools with minimal functional overlap. Tools should promote token efficiency in both their outputs and the agent behaviors they encourage. Maintain a 'minimal viable set' to improve maintenance and context pruning."

### Finding 01-007: Prompt Altitude -- Avoiding Extremes
- **Source**: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **Category**: QUALITY_ASSURANCE
- **Relevance**: HIGH
- **Summary**: Anthropic warns against two extremes in system prompts: hardcoded brittle if-else logic that creates maintenance complexity, and vague guidance that assumes shared context. The StarterPack's 251 actionable requirements may trend toward the first extreme, potentially creating brittleness.
- **Key Insight**: The optimal system prompt is "specific enough to guide behavior effectively, yet flexible enough to provide strong heuristics" -- the StarterPack's detailed requirements catalog may be too prescriptive.
- **Raw Evidence**: "Avoid two extremes: (1) hardcoding brittle if-else logic that creates maintenance complexity, and (2) vague guidance that assumes shared context. Optimal prompts are 'specific enough to guide behavior effectively, yet flexible enough to provide strong heuristics.'"

### Finding 01-008: Iterate with Clear Targets
- **Source**: https://www.anthropic.com/engineering/claude-code-best-practices
- **Category**: WORKFLOW
- **Relevance**: MEDIUM
- **Summary**: Claude performs best when given a clear target to iterate against -- test cases, visual mocks, or expected output. The StarterPack's quality gate checklists could serve as these iteration targets if surfaced at the right moment in the workflow.
- **Key Insight**: Quality gate checklists are most effective when presented as iteration targets before work begins, not just as post-hoc validation.
- **Raw Evidence**: "Claude performs best when it has a clear target to iterate against -- a visual mock, a test case, or another kind of output. By providing expected outputs like tests, Claude can make changes, evaluate results, and incrementally improve until it succeeds."

### Finding 01-009: Sub-Agent Architecture for Complex Tasks
- **Source**: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **Category**: PROJECT_STRUCTURE
- **Relevance**: MEDIUM
- **Summary**: Anthropic recommends delegating focused tasks to specialized sub-agents with clean context windows, each returning condensed summaries (1,000-2,000 tokens). The StarterPack's multi-role simulation (architect, developer, QA, etc.) could benefit from this pattern rather than loading all role contexts simultaneously.
- **Key Insight**: Rather than a single CLAUDE.md that configures Claude to act as all roles simultaneously, a sub-agent pattern could give each "role" a clean, focused context.
- **Raw Evidence**: "Delegate focused tasks to specialized agents with clean context windows. Each returns condensed summaries (1,000-2,000 tokens) rather than exhaustive details, maintaining clear separation of concerns."

### Finding 01-010: Long-Running Agent Coherence via Progress Files
- **Source**: https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
- **Category**: WORKFLOW
- **Relevance**: MEDIUM
- **Summary**: For agents working across multiple context windows, Anthropic recommends a `claude-progress.txt` file alongside git history to quickly rebuild state. This is relevant to the StarterPack's multi-session project management workflows where sprint progress or backlog state needs to persist.
- **Key Insight**: The StarterPack should consider a structured progress/state file pattern for multi-session continuity rather than relying solely on CLAUDE.md and configuration files.
- **Raw Evidence**: "The key insight was finding a way for agents to quickly understand the state of work when starting with a fresh context window, accomplished with a claude-progress.txt file alongside the git history."

### Finding 01-011: Compaction and History Management
- **Source**: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: MEDIUM
- **Summary**: Anthropic recommends summarizing message history as it approaches context limits, preserving architectural decisions and unresolved issues while discarding redundant outputs. The StarterPack does not appear to provide guidance on mid-session context management or compaction strategies.
- **Key Insight**: The StarterPack should include guidance on when and how to manage context during long sessions, not just at session start.
- **Raw Evidence**: "Summarize message history nearing the context limit, preserving architectural decisions and unresolved issues while discarding redundant outputs. Start by maximizing recall, then iterate to improve precision."

### Finding 01-012: Agent Skills as an Emerging Standard
- **Source**: https://www.anthropic.com/news/skills
- **Category**: PROJECT_STRUCTURE
- **Relevance**: MEDIUM
- **Summary**: Anthropic launched Agent Skills (December 2025) as an open standard for packaging agent capabilities in markdown files with YAML frontmatter. Skills load minimally at startup (~80 tokens for name+description) and expand on demand. This format was adopted by OpenAI, Google, GitHub, and Cursor within weeks, suggesting the StarterPack should consider compatibility.
- **Key Insight**: The StarterPack's slash commands and reference files could be restructured as Agent Skills for broader ecosystem compatibility and better progressive disclosure.
- **Raw Evidence**: "A skill is a markdown file with YAML frontmatter. The platform reads only the name and description at startup (~80 tokens median per skill). When the model determines a skill is relevant, the full instruction body loads (275 to 8,000 tokens). Supporting scripts and reference materials load only during execution."

## Synthesis

### Top Recommendations for Claude Code Effectiveness
1. Use CLAUDE.md as the primary entry point for static context, keeping it focused and well-structured with clear sections (XML tags or Markdown headers).
2. Implement a "research and plan first" workflow before any coding, using guardian checkpoints or similar mechanisms to enforce planning.
3. Provide clear iteration targets (test cases, checklists, expected outputs) so Claude can self-evaluate and improve incrementally.
4. Use hooks for deterministic enforcement (blocking dangerous operations, formatting, notifications) rather than context injection when CLAUDE.md suffices.
5. Keep the total context footprint minimal -- every additional token reduces recall accuracy across the entire context window.

### Top Recommendations for Context Efficiency
1. Adopt progressive disclosure: load only summaries/indexes at startup and expand to full reference content on demand via slash commands or tool calls.
2. Structure large reference files (requirements catalog, standards) as indexed collections that can be queried rather than loaded wholesale.
3. Consider the Agent Skills format for packaging capabilities -- it provides native progressive disclosure with ~80 token startup cost per skill.
4. Include guidance on mid-session compaction strategies for long-running sessions that accumulate substantial history.
5. Use a structured progress file (e.g., `claude-progress.txt`) for multi-session continuity rather than relying solely on configuration files.

### Anti-Patterns to Avoid
1. **Context overloading**: Loading all 251 requirements + 529 standards + 8 checklists into context simultaneously -- this risks severe context rot and diminished recall.
2. **Brittle prescriptivism**: Encoding too many specific if-then rules that become maintenance burdens and reduce Claude's ability to apply flexible heuristics.
3. **Tool/command overlap**: Having hooks, commands, and guardian prompts that cover similar ground creates ambiguous decision points for both Claude and users.
4. **Ignoring compaction**: Failing to provide strategies for managing context during long sessions, leading to degraded performance as history accumulates.
5. **Pre-loading everything**: Front-loading all reference material at session start rather than using just-in-time retrieval when specific standards or requirements become relevant.

## Source Registry
| # | Source | URL | Type | Date Accessed |
|---|--------|-----|------|---------------|
| 1 | Claude Code Best Practices | https://www.anthropic.com/engineering/claude-code-best-practices | Blog Post | 2026-03-25 |
| 2 | Claude Code Hooks Guide | https://docs.anthropic.com/en/docs/claude-code/hooks-guide | Documentation | 2026-03-25 |
| 3 | Claude Code Hooks Reference | https://docs.anthropic.com/en/docs/claude-code/hooks | Documentation | 2026-03-25 |
| 4 | Effective Context Engineering for AI Agents | https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents | Blog Post | 2026-03-25 |
| 5 | Effective Harnesses for Long-Running Agents | https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents | Blog Post | 2026-03-25 |
| 6 | Introducing Agent Skills | https://www.anthropic.com/news/skills | Announcement | 2026-03-25 |
| 7 | Claude Code Release Notes | https://docs.anthropic.com/en/release-notes/claude-code | Documentation | 2026-03-25 |
