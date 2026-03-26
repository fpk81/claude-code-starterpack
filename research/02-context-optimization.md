# Research Report: Context Window Optimization & Efficiency

## Metadata
- **Report ID**: 02
- **Agent Role**: Context Efficiency Specialist
- **Date**: 2026-03-25
- **Sources Consulted**: 12
- **Confidence Level**: HIGH

## Executive Summary
- The StarterPack's total file payload is **~282KB (~70,000+ tokens)** across 8 reference files — far exceeding the recommended CLAUDE.md budget of ~2,000 tokens. However, the StarterPack already uses a tiered loading strategy via `.data-index.md` that aligns with progressive disclosure best practices.
- Industry best practice (2026) is to keep CLAUDE.md under **150-200 lines / 2,000 tokens** and use progressive disclosure (load-on-demand) for everything else. The StarterPack's CLAUDE.md is ~13KB (~2,900 tokens per its own estimate), which is slightly above the recommended ceiling.
- Claude Code reserves **33,000-45,000 tokens** for system overhead (system prompt, tool schemas, MCP definitions) before any user content loads. Every token in CLAUDE.md competes with reasoning space.
- The **Agent Skills model** (progressive disclosure in 3 tiers: metadata → skill body → linked files) is the current gold standard for context efficiency. The StarterPack's architecture partially mirrors this but doesn't use the native Skills framework.
- **MCP tool schemas are a hidden context drain** — each server can consume 5,000-10,000 tokens just by existing. The StarterPack's `.mcp.json` template should warn users about this overhead.

## Findings

### Finding 02-001: CLAUDE.md Size Exceeds Recommended Budget
- **Source**: [HumanLayer Blog](https://www.humanlayer.dev/blog/writing-a-good-claude-md), [Buildcamp Guide](https://www.buildcamp.io/guides/the-ultimate-guide-to-claudemd), [claudefa.st](https://claudefa.st/blog/guide/mechanics/context-management)
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: Industry consensus in 2026 is that CLAUDE.md should be under 150-200 lines and ~2,000 tokens. The StarterPack's CLAUDE.md is ~13KB (~2,900 tokens by its own count, likely higher with Tier Behavior Overrides). Every token loads on every request and survives every compaction — making bloat permanent.
- **Key Insight**: The StarterPack's CLAUDE.md is lean compared to its total payload but still ~45% over the recommended token budget.
- **Raw Evidence**: "Keep CLAUDE.md under 200 lines and 2,000 tokens. It loads into context on every request, so a bloated CLAUDE.md consumes its own share of the window."

### Finding 02-002: Progressive Disclosure Architecture Is Partially Implemented
- **Source**: [Anthropic Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices), [Anthropic Engineering Blog](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: The StarterPack uses `.data-index.md` as a "table of contents" with token estimates and load-when guidance — this is excellent and mirrors the 3-tier progressive disclosure model (metadata → body → linked files). However, it relies on behavioral instructions ("load ONLY the specific referenced file") rather than the native Skills framework which enforces progressive disclosure structurally.
- **Key Insight**: The `.data-index.md` pattern is the right idea but lacks enforcement — nothing stops Claude from loading all reference files eagerly.
- **Raw Evidence**: "Progressive disclosure is the core design principle... showing just enough information to help agents decide what to do next, then reveal more details as they need them."

### Finding 02-003: ~150 Effective Instruction Slots — Budget Carefully
- **Source**: [Buildcamp Guide](https://www.buildcamp.io/guides/the-ultimate-guide-to-claudemd), [DataCamp Best Practices](https://www.datacamp.com/tutorial/claude-code-best-practices)
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: Claude Code's system prompt uses ~50 of approximately 150 effective instruction slots, leaving ~100 for user rules. The StarterPack's CLAUDE.md contains numerous rules across Session Start (7 steps), Guardian Rules (5 rules), Commit Protocol (7 steps), Per-Step Protocol (7 steps), Hard Rules (9 items), Scope Lock (3 steps), Approval Checkpoints, Quality Gates, and Tier Behavior Overrides. This likely approaches or exceeds the 100-instruction budget.
- **Key Insight**: Instruction density matters more than file size — too many rules cause Claude to deprioritize or forget some.
- **Raw Evidence**: "Claude Code's system prompt uses about 50 of the roughly 150 effective instruction slots, leaving 100 for your rules."

### Finding 02-004: Subdirectory CLAUDE.md Files for Domain-Specific Rules
- **Source**: [HumanLayer Blog](https://www.humanlayer.dev/blog/writing-a-good-claude-md), [Buildcamp Guide](https://www.buildcamp.io/guides/the-ultimate-guide-to-claudemd)
- **Category**: PROJECT_STRUCTURE
- **Relevance**: MEDIUM
- **Summary**: Best practice is to use subdirectory CLAUDE.md files for domain-specific instructions (e.g., `src/api/CLAUDE.md` for API conventions). The StarterPack's Tier Behavior Overrides (Hobby/Professional/Enterprise) could be split into separate files loaded conditionally based on `.project-config.json`, rather than all living in the root CLAUDE.md.
- **Key Insight**: Tier-specific behavior overrides inflate the root CLAUDE.md for every user, even though only one tier applies per project.
- **Raw Evidence**: "Keep your root CLAUDE.md short and general. Use subdirectory CLAUDE.md files for domain-specific rules."

### Finding 02-005: Context Buffer Reduction — More Headroom Available (2026)
- **Source**: [claudefa.st Context Buffer](https://claudefa.st/blog/guide/mechanics/context-buffer-management), [Morph Guide](https://www.morphllm.com/claude-code-context-window)
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: MEDIUM
- **Summary**: As of early 2026, Claude Code's reserved context buffer dropped from ~45K to ~33K tokens (16.5% of 200K), and auto-compaction triggers at ~83.5% usage instead of ~77-78%. Additionally, the 1M context window is now GA for Opus 4.6 on Max/Team/Enterprise plans. This gives StarterPack users significantly more headroom than when the StarterPack was designed.
- **Key Insight**: The StarterPack's aggressive context conservation may be less critical with 1M windows, but remains important for users on smaller plans.
- **Raw Evidence**: "The buffer has been reduced to ~33,000 tokens. Claude Code users on Max, Team, and Enterprise plans get the 1M context window automatically."

### Finding 02-006: Lazy Loading Achieves 54% Token Reduction
- **Source**: [GitHub Gist - Context Optimization](https://gist.github.com/johnlindquist/849b813e76039a908d962b2f0923dc9a)
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: A documented optimization replaced verbose upfront documentation with a minimal trigger table, achieving a 54% reduction in initial context (7,584 → 3,434 tokens) while improving tool discovery. The StarterPack could apply this pattern: instead of the full Session Start protocol in CLAUDE.md, use a compact trigger table pointing to detailed instructions in reference files.
- **Key Insight**: Replace verbose inline protocols with compact trigger tables + on-demand file loading.
- **Raw Evidence**: "Claude doesn't need verbose documentation upfront — it needs triggers to know when to load detailed context."

### Finding 02-007: MCP Tool Schema Overhead Warning Missing
- **Source**: [claudefa.st Context Management](https://claudefa.st/blog/guide/mechanics/context-management), [Morph Guide](https://www.morphllm.com/claude-code-context-window)
- **Category**: TOOLING
- **Relevance**: MEDIUM
- **Summary**: Each MCP server loads its full tool schema into context on every request, even when unused. A server with 20 tools can consume 5,000-10,000 tokens. The StarterPack's `.mcp.json` template references PM tools, monitoring, and integrations but does not warn users about the context cost of enabling multiple MCP servers.
- **Key Insight**: The StarterPack should document the context cost of MCP servers so users make informed tradeoffs.
- **Raw Evidence**: "MCP tools are the most common hidden context drain. Each MCP server loads its full tool schema into context on every request."

### Finding 02-008: Document & Clear Pattern Not Documented
- **Source**: [DataCamp Best Practices](https://www.datacamp.com/tutorial/claude-code-best-practices), [SFEIR Institute](https://institute.sfeir.com/en/claude-code/claude-code-context-management/optimization/)
- **Category**: WORKFLOW
- **Relevance**: MEDIUM
- **Summary**: Best practice is to not let context exceed 60% of the window. The "Document & Clear" pattern — dump progress to a markdown file, run `/clear`, start fresh — is a core workflow optimization. The StarterPack has `inject-context.sh` for compaction recovery but doesn't explicitly teach users the Document & Clear pattern for proactive context management.
- **Key Insight**: Proactive clearing at 60% is better than waiting for auto-compaction at 83.5%.
- **Raw Evidence**: "Don't let context exceed 60% of the 200K token window. Use the Document & Clear pattern: dump progress to a markdown file, run /clear, and start fresh."

### Finding 02-009: Skills Framework as Native Alternative
- **Source**: [Anthropic Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices), [Towards Data Science](https://towardsdatascience.com/how-to-build-a-production-ready-claude-code-skill/)
- **Category**: PROJECT_STRUCTURE
- **Relevance**: HIGH
- **Summary**: The Agent Skills framework (SKILL.md files in `.claude/skills/` directories) is now the official Anthropic-recommended approach for progressive disclosure. Skills use structured metadata for discovery and load full content only when relevant. The StarterPack's reference file pattern (`.ref-*.md`) predates this framework and could potentially be restructured as Skills for better native integration.
- **Key Insight**: Migrating reference files to the Skills framework would give the StarterPack native progressive disclosure enforcement rather than relying on behavioral instructions.
- **Raw Evidence**: "The Skill Economy 2026 is defined by the transition from ephemeral chat instructions to persistent, folder-based expertise."

### Finding 02-010: Token Estimates in .data-index.md Are a Strong Pattern
- **Source**: [Anthropic Skills Best Practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices), [HumanLayer Blog](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH (POSITIVE)
- **Summary**: The StarterPack's `.data-index.md` includes approximate token counts for every file (~Tokens column), load-when guidance, and a clear protocol for selective loading with line ranges. This is an excellent implementation of context-aware documentation that helps Claude make informed loading decisions. Few projects do this.
- **Key Insight**: Token-annotated file inventories are a best practice the StarterPack implements well.
- **Raw Evidence**: StarterPack's `.data-index.md` Protocol: "Read THIS file first... Find the relevant section... Load ONLY the specific referenced file (use line ranges for large files)... Work with that slice, summarize findings, then discard before loading the next."

## Synthesis

### Top Recommendations for Context Efficiency
1. **Slim CLAUDE.md to ~2,000 tokens**: Move Tier Behavior Overrides, detailed Commit Protocol steps, and Per-Step Protocol to separate files loaded conditionally. Keep only the routing logic and hard rules in CLAUDE.md.
2. **Adopt the Skills framework**: Convert `.ref-*.md` files into `.claude/skills/` with proper SKILL.md metadata. This gives native progressive disclosure instead of relying on behavioral instructions that Claude may not follow.
3. **Add trigger tables**: Replace verbose multi-step protocols in CLAUDE.md with compact trigger tables (event → action → file reference). This follows the proven 54% token reduction pattern.
4. **Document MCP context costs**: Add a warning in `.data-index.md` or setup flow about the token overhead of enabling multiple MCP servers.
5. **Add proactive clearing guidance**: Teach users the Document & Clear pattern and the 60% context threshold rule.
6. **Use `scripts/load-context.py` pattern more broadly**: The selective loader for `.ref-standards.md` is great — extend this pattern to other large reference files (checklists at ~9K tokens, methodology at ~8K tokens).

### What to Put in CLAUDE.md vs Elsewhere
| Content Type | Where It Should Live | Rationale |
|---|---|---|
| Session start routing (which files to load) | CLAUDE.md | Must be available on every session start |
| Guardian spawn triggers (when to spawn) | CLAUDE.md | Non-negotiable rules that must survive compaction |
| Hard security rules (secrets, SQL injection) | CLAUDE.md | Critical safety rules must always be in context |
| Enforcement mode definition | CLAUDE.md | Core behavioral switch, must always be present |
| Tier behavior overrides (Hobby/Pro/Enterprise) | `.ref-tier-overrides.md` or conditional CLAUDE.md in subdirectory | Only one tier applies per project — loading all three wastes tokens |
| Commit protocol (7-step) | `.claude/commands/commit.md` (already exists) | Only needed at commit time, not every request |
| Per-step protocol details | Separate `.ref-workflow.md` | Detailed ceremony steps can be loaded on-demand |
| Quality gate definitions | `.ref-checklists.md` (already correct) | Large reference, correctly kept out of CLAUDE.md |
| Standards catalog | `.ref-standards.md` via `load-context.py` (already correct) | Massive file, correctly uses selective loader |
| Guardian prompt templates | `.guardian-prompts.md` (already correct) | Only loaded when spawning guardians |
| Architecture templates | `.data-index.md` (already correct) | On-demand reference |
| MCP/tooling configuration | `.mcp.json` + setup docs | Configuration, not runtime instructions |

### Anti-Patterns That Waste Context
1. **Loading all tier overrides for every user**: The StarterPack includes Hobby, Startup, Professional, and Enterprise behavior overrides in the root CLAUDE.md. Only one tier applies per project — the other tiers waste ~500-1,000 tokens on every request.
2. **Verbose multi-step protocols inline**: The 7-step Commit Protocol and 7-step Per-Step Protocol are detailed enough to be reference files loaded on-demand, not permanent context residents.
3. **No MCP overhead awareness**: Enabling multiple MCP servers without understanding the 5-10K token cost per server can silently consume 20-40K tokens of workspace.
4. **Relying on behavioral instructions for loading discipline**: Telling Claude "Load ONLY the specific referenced file" is advisory — Claude may still eagerly load files. Structural enforcement (Skills framework, hooks) is more reliable.
5. **Duplicate information across files**: If the same rules appear in CLAUDE.md, guardian prompts, and hook scripts, the duplication wastes tokens when multiple files are loaded simultaneously. Each file should assume its unique role without restating what others cover.
6. **Not using line-range loading for large files**: The `.data-index.md` correctly advises using line ranges, but the reference files themselves don't include section markers or line-range guidance to make this practical.
7. **Session state files without TTL**: Files like `.guardian-verdict.json` and `.claude-traceability-state` are loaded into context when referenced but have no size bounds or staleness expiry documented.

## Source Registry
| # | Source | URL | Type | Date Accessed |
|---|--------|-----|------|---------------|
| 1 | Claude API Docs - Context Windows | https://platform.claude.com/docs/en/build-with-claude/context-windows | Official Docs | 2026-03-25 |
| 2 | claudefa.st - Context Management Guide | https://claudefa.st/blog/guide/mechanics/context-management | Guide | 2026-03-25 |
| 3 | claudefa.st - Context Buffer Management | https://claudefa.st/blog/guide/mechanics/context-buffer-management | Guide | 2026-03-25 |
| 4 | claudefa.st - 1M Context GA | https://claudefa.st/blog/guide/mechanics/1m-context-ga | Guide | 2026-03-25 |
| 5 | GitHub Gist - 54% Context Reduction | https://gist.github.com/johnlindquist/849b813e76039a908d962b2f0923dc9a | Case Study | 2026-03-25 |
| 6 | HumanLayer - Writing a Good CLAUDE.md | https://www.humanlayer.dev/blog/writing-a-good-claude-md | Blog | 2026-03-25 |
| 7 | Buildcamp - Ultimate Guide to CLAUDE.md | https://www.buildcamp.io/guides/the-ultimate-guide-to-claudemd | Guide | 2026-03-25 |
| 8 | Anthropic - Agent Skills Best Practices | https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices | Official Docs | 2026-03-25 |
| 9 | Anthropic - Equipping Agents with Skills | https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills | Engineering Blog | 2026-03-25 |
| 10 | DataCamp - Claude Code Best Practices | https://www.datacamp.com/tutorial/claude-code-best-practices | Tutorial | 2026-03-25 |
| 11 | SFEIR Institute - Context Optimization | https://institute.sfeir.com/en/claude-code/claude-code-context-management/optimization/ | Guide | 2026-03-25 |
| 12 | Morph - Claude Code Context Window Guide | https://www.morphllm.com/claude-code-context-window | Guide | 2026-03-25 |
