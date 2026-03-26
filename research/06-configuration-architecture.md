# Research Report: CLAUDE.md Design Patterns & Configuration Architecture

## Metadata
- **Report ID**: 06
- **Agent Role**: Configuration Architecture Specialist
- **Date**: 2026-03-25
- **Sources Consulted**: 14
- **Confidence Level**: HIGH

## Executive Summary
- The official `.claude/` directory structure supports a well-defined hierarchy: `settings.json`, `rules/`, `commands/`, `skills/`, `agents/`, and `hooks/` -- the StarterPack should align to this canonical layout.
- CLAUDE.md files should target **under 200 lines** per file; longer files degrade adherence. The StarterPack's main CLAUDE.md likely exceeds this threshold and should use `@import` or `.claude/rules/` to decompose.
- Two memory systems coexist: manually authored CLAUDE.md files and auto memory (stored in `~/.claude/projects/<project>/memory/`). The StarterPack does not appear to account for auto memory interactions.
- Path-specific rules via `.claude/rules/` with `paths:` frontmatter allow conditional loading -- a pattern the StarterPack could leverage for tier-specific or methodology-specific instructions instead of embedding everything in one file.
- Community best practices emphasize context budget management as the #1 concern: bloated instructions cause Claude to ignore rules, and context degradation is the primary failure mode.

## Findings

### Finding 06-001: Official CLAUDE.md Size Limit Guidance
- **Source**: https://code.claude.com/docs/en/memory
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: Anthropic's official documentation recommends CLAUDE.md files target under 200 lines. Files over this threshold consume excessive context and reduce adherence. The documentation explicitly states "Bloated CLAUDE.md files cause Claude to ignore your actual instructions."
- **Key Insight**: The StarterPack's multi-hundred-line CLAUDE.md may be self-defeating by exceeding the recommended context budget.
- **Raw Evidence**: "Size: target under 200 lines per CLAUDE.md file. Longer files consume more context and reduce adherence. If your instructions are growing large, split them using imports or .claude/rules/ files."

### Finding 06-002: Canonical .claude/ Directory Structure
- **Source**: https://computingforgeeks.com/claude-code-dot-claude-directory-guide/
- **Category**: PROJECT_STRUCTURE
- **Relevance**: HIGH
- **Summary**: The official .claude/ directory structure includes: `settings.json`, `settings.local.json`, `.mcp.json`, `rules/`, `commands/`, `skills/`, `agents/`, and `hooks/`. The StarterPack uses some of these (commands, hooks, settings.json) but does not use `rules/`, `skills/`, or `agents/` directories, instead placing reference files as dotfiles in the project root.
- **Key Insight**: The StarterPack's use of `.ref-*.md` files in the root rather than `.claude/rules/` or `.claude/skills/` diverges from the canonical structure.
- **Raw Evidence**: "your-project/.claude/ contains: settings.json, settings.local.json, .mcp.json, rules/, commands/, skills/, agents/, hooks/"

### Finding 06-003: Path-Specific Rules for Conditional Loading
- **Source**: https://code.claude.com/docs/en/memory
- **Category**: CONFIGURATION
- **Relevance**: HIGH
- **Summary**: The `.claude/rules/` directory supports YAML frontmatter with `paths:` fields for conditional loading. Rules without paths are loaded at launch; rules with paths only load when Claude works with matching files. This mechanism could replace the StarterPack's monolithic approach with tier-specific or methodology-specific rules that load only when relevant.
- **Key Insight**: Path-specific rules could reduce context consumption by 50-70% for any given session by only loading relevant standards.
- **Raw Evidence**: "Rules can be scoped to specific files using YAML frontmatter with the paths field. These conditional rules only apply when Claude is working with files matching the specified patterns."

### Finding 06-004: Import Syntax for Modular CLAUDE.md
- **Source**: https://code.claude.com/docs/en/memory
- **Category**: PROJECT_STRUCTURE
- **Relevance**: HIGH
- **Summary**: CLAUDE.md files support `@path/to/import` syntax for pulling in additional files, with recursive imports up to 5 levels deep. Both relative and absolute paths work. This enables a hub-and-spoke architecture where CLAUDE.md is a concise index that references detailed instructions stored elsewhere.
- **Key Insight**: The StarterPack could use a slim CLAUDE.md (<200 lines) that `@imports` tier-specific and methodology-specific reference files on demand.
- **Raw Evidence**: "CLAUDE.md files can import additional files using @path/to/import syntax. Imported files are expanded and loaded into context at launch alongside the CLAUDE.md that references them."

### Finding 06-005: Skills vs Rules vs CLAUDE.md Separation of Concerns
- **Source**: https://code.claude.com/docs/en/memory
- **Category**: CONFIGURATION
- **Relevance**: HIGH
- **Summary**: Claude Code distinguishes three instruction mechanisms: CLAUDE.md (always loaded, for universal guidance), rules (always or conditionally loaded, for standards enforcement), and skills (loaded on demand or by invocation, for task-specific workflows). The StarterPack conflates these by embedding workflow instructions, standards, and task-specific guidance all in CLAUDE.md and reference files.
- **Key Insight**: Moving guardian prompts and methodology protocols to skills would reduce baseline context consumption while preserving on-demand access.
- **Raw Evidence**: "Rules load into context every session or when matching files are opened. For task-specific instructions that don't need to be in context all the time, use skills instead, which only load when you invoke them or when Claude determines they're relevant."

### Finding 06-006: Context Budget Management as Primary Concern
- **Source**: https://rosmur.github.io/claudecode-best-practices/
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: HIGH
- **Summary**: Community consensus identifies context degradation as the #1 failure mode. At 70% context, precision drops; at 85%, hallucinations increase; at 90%+, responses become erratic. Large instruction files consume context budget before any work begins, reducing the effective working window.
- **Key Insight**: A StarterPack that consumes thousands of tokens on instruction loading leaves less room for actual project work, potentially causing the very quality problems it aims to prevent.
- **Raw Evidence**: "At 70% context, Claude starts losing precision. At 85%, hallucinations increase. At 90%+, responses become erratic."

### Finding 06-007: Auto Memory Interaction Not Addressed
- **Source**: https://code.claude.com/docs/en/memory
- **Category**: CONFIGURATION
- **Relevance**: MEDIUM
- **Summary**: Claude Code has auto memory that persists learnings across sessions in `~/.claude/projects/<project>/memory/MEMORY.md`. The first 200 lines are loaded every session. The StarterPack does not account for how its instructions interact with or potentially conflict with auto memory content.
- **Key Insight**: Auto memory could accumulate project-specific learnings that conflict with or duplicate StarterPack instructions, creating instruction confusion over time.
- **Raw Evidence**: "Auto memory lets Claude accumulate knowledge across sessions without you writing anything. Claude saves notes for itself as it works."

### Finding 06-008: Settings Hierarchy and Managed Policies
- **Source**: https://code.claude.com/docs/en/settings
- **Category**: CONFIGURATION
- **Relevance**: MEDIUM
- **Summary**: Settings follow a strict hierarchy: managed (IT-deployed) > user (~/.claude/settings.json) > project (.claude/settings.json) > local (.claude/settings.local.json). The StarterPack's settings.json is at the project level, meaning user or managed settings can override its hook configurations.
- **Key Insight**: Enterprise deployments may have managed settings that conflict with or disable StarterPack hooks, a scenario the StarterPack documentation does not address.
- **Raw Evidence**: "Settings apply in order of precedence from highest to lowest: Managed settings > User settings > Project settings > Local settings."

### Finding 06-009: .local Files for Personal Overrides
- **Source**: https://computingforgeeks.com/claude-code-dot-claude-directory-guide/
- **Category**: PROJECT_STRUCTURE
- **Relevance**: MEDIUM
- **Summary**: Claude Code supports `CLAUDE.local.md` and `settings.local.json` for personal overrides that are gitignored. The StarterPack does not leverage this pattern for per-user tier selection or methodology preferences, instead requiring configuration in shared files.
- **Key Insight**: Tier selection (Hobby/Professional/Enterprise) and methodology preference could be stored in .local files, allowing team members to use different configurations without conflicts.
- **Raw Evidence**: "CLAUDE.local.md for personal overrides (gitignored), settings.local.json for personal permission overrides (gitignored)"

### Finding 06-010: Subagents for Specialized Personas
- **Source**: https://code.claude.com/docs/en/memory
- **Category**: TOOLING
- **Relevance**: MEDIUM
- **Summary**: Claude Code supports custom subagents stored as markdown files in `.claude/agents/`. These are specialized AI personas with their own instructions and can maintain their own auto memory. The StarterPack's guardian checkpoints could be implemented as subagents rather than manual prompt-based workflows.
- **Key Insight**: Guardian checkpoints as subagents would provide formal separation of concerns and persistent memory for each guardian role.
- **Raw Evidence**: "Claude Code supports custom AI subagents configured at both user and project levels. These subagents are stored as Markdown files with YAML frontmatter."

## Synthesis

### Optimal CLAUDE.md Structure
Based on official documentation and community best practices, the optimal structure is:

```
CLAUDE.md                          # <200 lines: project identity, core rules, @imports
├── @.claude/rules/code-style.md   # Always-loaded coding standards
├── @.claude/rules/security.md     # Always-loaded security rules
├── @.claude/rules/testing.md      # Always-loaded test requirements
.claude/
├── CLAUDE.md                      # Alternative location (choose one)
├── settings.json                  # Hook configs, permissions (committed)
├── settings.local.json            # Personal overrides (gitignored)
├── rules/
│   ├── code-style.md              # Universal code standards
│   ├── security.md                # Security requirements
│   ├── frontend.md                # paths: ["src/frontend/**"]
│   └── api.md                     # paths: ["src/api/**"]
├── commands/
│   ├── review.md                  # /review slash command
│   └── deploy.md                  # /deploy slash command
├── skills/
│   ├── guardian-design/SKILL.md   # Design review guardian
│   ├── guardian-security/SKILL.md # Security review guardian
│   └── methodology-scrum/SKILL.md # Scrum workflow
├── agents/
│   ├── qa-reviewer.md             # QA subagent
│   └── security-auditor.md        # Security subagent
└── hooks/
    ├── pre-commit.sh              # Pre-commit validation
    └── post-task.sh               # Post-task checks
```

Approximate sizes:
- CLAUDE.md: 100-150 lines (core identity + imports)
- Each rule file: 30-80 lines
- Each skill: 50-150 lines
- Each command: 20-50 lines
- Total committed configuration: ~2000-3000 lines across all files

### What Goes Where
| Content | Location | Rationale |
|---------|----------|-----------|
| Project identity, build commands, core coding standards | `CLAUDE.md` (<200 lines) | Loaded every session; must be concise |
| Coding standards by domain (frontend, API, DB) | `.claude/rules/` with `paths:` frontmatter | Conditional loading reduces context waste |
| Universal security/quality rules | `.claude/rules/` without paths | Always loaded but modular and maintainable |
| Guardian checkpoint workflows | `.claude/skills/` or `.claude/agents/` | On-demand loading; don't consume baseline context |
| Methodology protocols (Scrum/Kanban) | `.claude/skills/` | Task-specific; load only when doing sprint planning etc. |
| Quality gate checklists | `.claude/skills/` or `.claude/commands/` | Invoked at specific workflow points, not always needed |
| Standards catalog (251 requirements) | `.claude/skills/` with `!command` for dynamic filtering | Far too large for always-loaded context |
| Tier configuration (Hobby/Pro/Enterprise) | `.claude/settings.local.json` or `CLAUDE.local.md` | Per-user preference, not committed |
| Hook definitions | `.claude/settings.json` + `.claude/hooks/` | Already correctly placed in StarterPack |

### Configuration Anti-Patterns
1. **Monolithic CLAUDE.md exceeding 200 lines**: Official docs warn this causes Claude to ignore instructions. The StarterPack's CLAUDE.md likely far exceeds this, embedding setup flows, guardian references, methodology guidance, and standards enforcement in one file. Evidence: "Bloated CLAUDE.md files cause Claude to ignore your actual instructions."

2. **Always-loading rarely-needed content**: Standards catalogs, methodology protocols, and guardian prompts are needed at specific workflow points, not every session. Loading them universally wastes context budget. Evidence: community consensus that context degradation at 70%+ causes precision loss.

3. **Not using .local files for per-user configuration**: Forcing tier selection and methodology into committed files means team members cannot have different configurations without merge conflicts. Evidence: `.local` files exist specifically for this use case.

4. **Placing reference files as root-level dotfiles instead of .claude/ structure**: Files like `.ref-standards.md` and `.ref-methodology.md` in the project root don't follow the canonical `.claude/` directory pattern and won't benefit from Claude Code's built-in loading, path-scoping, or rules mechanisms.

5. **Conflating rules, skills, and instructions**: Embedding everything in CLAUDE.md rather than separating always-loaded rules from on-demand skills means the full instruction set competes for context space in every session regardless of task.

### Recommended Minimal Configuration
For a StarterPack targeting the stated mission (layperson producing elite output):

**Tier: Hobby (<100 lines total loaded per session)**
```
CLAUDE.md (80 lines): project basics, coding standards, test commands
.claude/settings.json: 3-4 essential hooks (lint, test, commit-msg)
.claude/commands/review.md: simple review workflow
```

**Tier: Professional (~200 lines loaded per session)**
```
CLAUDE.md (120 lines): project basics + @imports for active methodology
.claude/rules/security.md: security standards (always loaded)
.claude/rules/testing.md: test requirements (always loaded)
.claude/skills/guardian-review/: on-demand quality gate
.claude/settings.json: 8-10 hooks
.claude/commands/: 5-6 slash commands
```

**Tier: Enterprise (~200 lines loaded + on-demand skills)**
```
CLAUDE.md (150 lines): project basics + @imports
.claude/rules/: 5-8 always-loaded rule files (path-scoped where possible)
.claude/skills/: 4 guardian skills + methodology skills
.claude/agents/: security-auditor, qa-reviewer subagents
.claude/settings.json: 13 hooks + strict permissions
.claude/commands/: 11 slash commands
```

The key insight: even Enterprise tier should keep always-loaded content under 200 lines in CLAUDE.md, using rules for modular standards and skills/agents for on-demand workflows.

## Source Registry
| # | Source | URL | Type | Date Accessed |
|---|--------|-----|------|---------------|
| 1 | Anthropic Claude Code Memory Docs | https://code.claude.com/docs/en/memory | Official Documentation | 2026-03-25 |
| 2 | Claude Code Settings Docs | https://code.claude.com/docs/en/settings | Official Documentation | 2026-03-25 |
| 3 | Claude Code Best Practices Docs | https://code.claude.com/docs/en/best-practices | Official Documentation | 2026-03-25 |
| 4 | shanraisshan/claude-code-best-practice | https://github.com/shanraisshan/claude-code-best-practice | GitHub Repository | 2026-03-25 |
| 5 | hesreallyhim/awesome-claude-code | https://github.com/hesreallyhim/awesome-claude-code | GitHub Repository | 2026-03-25 |
| 6 | FlorianBruniaux/claude-code-ultimate-guide | https://github.com/FlorianBruniaux/claude-code-ultimate-guide | GitHub Repository | 2026-03-25 |
| 7 | wesammustafa/Claude-Code-Everything-You-Need-to-Know | https://github.com/wesammustafa/Claude-Code-Everything-You-Need-to-Know | GitHub Repository | 2026-03-25 |
| 8 | rosmur Claude Code Best Practices | https://rosmur.github.io/claudecode-best-practices/ | Community Guide | 2026-03-25 |
| 9 | The Complete .claude Directory Guide | https://computingforgeeks.com/claude-code-dot-claude-directory-guide/ | Tutorial | 2026-03-25 |
| 10 | ChrisWiles/claude-code-showcase | https://github.com/ChrisWiles/claude-code-showcase | GitHub Repository | 2026-03-25 |
| 11 | DeepWiki .claude Folder Structure | https://deepwiki.com/FlorianBruniaux/claude-code-ultimate-guide/4.4-the-.claude-folder-structure | Wiki | 2026-03-25 |
| 12 | Claude Code Advanced Tips (paulmduvall) | https://www.paulmduvall.com/claude-code-advanced-tips-using-commands-configuration-and-hooks/ | Blog | 2026-03-25 |
| 13 | eesel.ai Claude Code Best Practices | https://www.eesel.ai/blog/claude-code-best-practices | Blog | 2026-03-25 |
| 14 | builder.io How I Use Claude Code | https://www.builder.io/blog/claude-code | Blog | 2026-03-25 |
