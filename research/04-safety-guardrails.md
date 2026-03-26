# Research Report: Safety, Guardrails & Quality Assurance

## Metadata
- **Report ID**: 04
- **Agent Role**: Safety & Quality Assurance Specialist
- **Date**: 2026-03-25
- **Sources Consulted**: 8
- **Confidence Level**: HIGH

## Executive Summary
- Claude Code hooks are "guardrails, not walls" — they provide safety rails but are not a true security boundary. The StarterPack's 13-hook architecture aligns well with industry best practices for defense-in-depth.
- PreToolUse is the only hook event that can block actions (exit code 2). The StarterPack correctly uses PreToolUse for all safety-critical gates (dangerous git, config protection, traceability, scope lock).
- Hooks fail-open by default in Claude Code: if a hook script crashes, the tool call proceeds. The StarterPack mitigates this with the `_preamble.sh` pattern (blocking on missing Python in safe mode), but other crash paths remain unguarded.
- The protect-config.sh hook only warns (does not block) when settings.json hooks are removed, creating a bypass vector where an agent could disable its own enforcement infrastructure.
- Industry consensus (Anthropic, Trail of Bits, community) recommends layering hooks with OS-level sandboxing (Docker/VM), deny rules in settings.json, and credential isolation — the StarterPack focuses heavily on hooks but does not guide users on these complementary layers.

## Findings

### Finding 04-001: PreToolUse Is the Only Blocking Hook Event
- **Source**: https://www.pixelmojo.io/blogs/claude-code-hooks-production-quality-ci-cd-patterns
- **Category**: SAFETY
- **Relevance**: HIGH
- **Summary**: Among all Claude Code hook events (PreToolUse, PostToolUse, SessionStart, TaskCompleted, UserPromptSubmit, Stop, ConfigChange, etc.), only PreToolUse hooks can block an action by returning exit code 2. PostToolUse hooks run after the action has already occurred and cannot undo it.
- **Key Insight**: Safety-critical enforcement must live in PreToolUse hooks; PostToolUse hooks are for observation and advisory only.
- **Raw Evidence**: "PreToolUse is the only hook that can block actions. Use it for security gates, file protection, and mandatory review enforcement."

### Finding 04-002: Hooks Fail-Open by Default
- **Source**: https://www.backslash.security/blog/claude-code-security-best-practices
- **Category**: SAFETY
- **Relevance**: HIGH
- **Summary**: If a PreToolUse hook crashes (unhandled exception, timeout, syntax error), Claude Code treats it as a pass and the tool call proceeds. This means a buggy safety hook provides zero protection. The StarterPack's `_preamble.sh` handles the "no Python" case well (blocks in safe mode), but other crash paths (malformed JSON input, disk full, unexpected tool_input schema) could cause silent fail-open.
- **Key Insight**: Every hook must have comprehensive error handling to avoid fail-open; a crashed hook is worse than no hook because it creates false confidence.
- **Raw Evidence**: "If your security-critical PreToolUse hook has a bug that causes it to crash, the tool call will proceed. Test your hooks thoroughly and handle edge cases explicitly."

### Finding 04-003: Settings.json Hook Removal Is Only Advisory
- **Source**: Analysis of starterpack/.claude/hooks/protect-config.sh (lines 101-110)
- **Category**: SAFETY
- **Relevance**: HIGH
- **Summary**: The protect-config.sh hook detects modifications to `.claude/settings.json` but only prints a warning — it does not block (exit 0). This means Claude Code could be instructed to remove hook entries from settings.json, effectively disabling all 13 hooks, with only an advisory warning. The enforcement_mode in .project-config.json is properly blocked (exit 2), but the hook infrastructure itself is unprotected.
- **Key Insight**: An agent that can edit settings.json can disable its own safety hooks — this is a critical gap in the self-protection chain.
- **Raw Evidence**: `# Advisory only — don't block (exit 0)` in protect-config.sh line 109.

### Finding 04-004: Deny Rules in settings.json Are Absent
- **Source**: https://code.claude.com/docs/en/security
- **Category**: CONFIGURATION
- **Relevance**: HIGH
- **Summary**: Anthropic recommends configuring explicit deny rules in settings.json to prevent Claude Code from reading sensitive files (.env, .ssh, credentials). The StarterPack's settings.json contains only hook definitions — no "permissions" section with deny rules. This is a missed opportunity to add a complementary safety layer that works independently of hooks.
- **Key Insight**: The StarterPack should ship with a recommended permissions deny list alongside its hook configuration.
- **Raw Evidence**: "Permissions: The 'permissions' section is huge for security. You can define what tools Claude is allowed to use without asking, like 'allow', and what it's absolutely forbidden from doing, like 'deny'."

### Finding 04-005: Dangerous Git Hook Has Comprehensive Coverage
- **Source**: Analysis of starterpack/.claude/hooks/block-dangerous-git.sh
- **Category**: SAFETY
- **Relevance**: HIGH (POSITIVE)
- **Summary**: The block-dangerous-git.sh hook covers 13 destructive patterns (force push, hard reset, clean -f, branch -D, checkout ., restore ., stash drop/clear, reflog expire) plus 3 stage-all patterns (git add ., -A, --all). It always blocks regardless of enforcement_mode (safe or expert). The patterns are well-crafted with regex that handles flag ordering and whitespace variations.
- **Key Insight**: This is a model implementation of a safety-critical PreToolUse hook — comprehensive, always-on, clear error messages, and properly documented.
- **Raw Evidence**: "This hook ALWAYS blocks regardless of enforcement_mode (safe/expert). Destructive git operations are irreversible."

### Finding 04-006: Python Dependency Creates Single Point of Failure
- **Source**: Analysis of starterpack/.claude/hooks/_preamble.sh
- **Category**: CONFIGURATION
- **Relevance**: MEDIUM
- **Summary**: All 13 hooks depend on Python 3 for JSON parsing. The preamble handles this gracefully in safe mode (blocks) and expert mode (warns), but this is a single point of failure. If Python is unavailable or the wrong version, all hooks degrade simultaneously. The preamble's grep-based fallback for detecting expert mode is clever but fragile.
- **Key Insight**: A single dependency failure disables all enforcement — consider a lightweight fallback (jq, node, or pure bash) for critical safety hooks.
- **Raw Evidence**: "All 13 StarterPack hooks depend on Python 3 for JSON parsing. Without it, quality enforcement is completely disabled."

### Finding 04-007: No Sandboxing or Container Guidance
- **Source**: https://code.claude.com/docs/en/security
- **Category**: SAFETY
- **Relevance**: MEDIUM
- **Summary**: Anthropic recommends sandboxing (Seatbelt on macOS, bubblewrap on Linux), devcontainers, and VM isolation as complementary security layers. The StarterPack focuses entirely on hook-based enforcement and behavioral instructions in CLAUDE.md. There is no guidance on enabling sandbox mode, using devcontainers, or running in isolation — even though these are orthogonal defenses that would significantly strengthen the security posture.
- **Key Insight**: Hooks are a behavioral layer; sandboxing is an OS-level enforcement layer — the StarterPack should recommend both.
- **Raw Evidence**: "Sandbox Claude Code — run in a VM or containerized dev environment. Never run as root." and Anthropic docs: "Sandbox bash commands with filesystem and network isolation."

### Finding 04-008: Hook Timeout Values Are Appropriate
- **Source**: Analysis of starterpack/.claude/settings.json
- **Category**: CONFIGURATION
- **Relevance**: LOW (POSITIVE)
- **Summary**: Hook timeouts range from 5s (scope-lock-check) to 30s (auto-format), with most at 10s. These are reasonable: safety-critical PreToolUse hooks are fast (5-10s), while the auto-format PostToolUse hook gets a longer window. No hook has an excessively long timeout that would degrade developer experience.
- **Key Insight**: Well-calibrated timeouts balance safety enforcement against developer friction.
- **Raw Evidence**: Timeout values in settings.json: 5s (scope-lock, protect-config-bash), 10s (most hooks), 15s (inject-context), 30s (auto-format).

### Finding 04-009: Community Guardrail Projects Validate the Approach
- **Source**: https://github.com/dwarvesf/claude-guardrails
- **Category**: CONTEXT_MANAGEMENT
- **Relevance**: MEDIUM
- **Summary**: Multiple community projects (dwarvesf/claude-guardrails, rulebricks/claude-code-guardrails, Codacy guardrails) have emerged to provide similar functionality. The dwarvesf project offers a "Lite" variant (3 hooks, 15 deny rules) and a "Full" variant (5 hooks + prompt injection scanner). This validates the StarterPack's approach but also shows the community considers deny rules and prompt injection scanning to be essential — two things the StarterPack currently lacks.
- **Key Insight**: The StarterPack's hook infrastructure is more comprehensive than community alternatives, but it should adopt their deny-rule and injection-scanning patterns.
- **Raw Evidence**: "Lite variant: 3 hooks, 15 deny rules for trusted projects. Full variant: 5 hooks + prompt injection scanner for untrusted codebases."

### Finding 04-010: CVE-2025-55284 and Known Vulnerabilities Context
- **Source**: https://www.backslash.security/blog/claude-code-security-best-practices
- **Category**: SAFETY
- **Relevance**: MEDIUM
- **Summary**: Known vulnerabilities include API key theft via DNS exfiltration (CVE-2025-55284), rules file backdoor via invisible Unicode, and a sandbox bypass (ADVISORY-CC-2026-001). The StarterPack does not include guidance on minimum Claude Code version requirements or security advisories. Its secrets scanning (hobby tier inline check) looks for common patterns but would not catch DNS exfiltration or Unicode poisoning.
- **Key Insight**: The StarterPack should document minimum Claude Code version requirements and include a Unicode/encoding check for configuration files.
- **Raw Evidence**: "CVE-2025-55284 demonstrated API key theft via DNS exfiltration from Claude Code itself. Update to v2.1.34+ immediately."

### Finding 04-011: Auto Mode (March 2026) Changes the Permission Landscape
- **Source**: https://siliconangle.com/2026/03/24/anthropic-unchains-claude-code-auto-mode-allowing-choose-permissions/
- **Category**: CONFIGURATION
- **Relevance**: MEDIUM
- **Summary**: Anthropic introduced "auto mode" in March 2026, where Claude Code makes its own permission decisions based on guardrails. This means hooks become even more critical since there may be fewer human approval checkpoints. The StarterPack was designed before auto mode and assumes a human-in-the-loop approval model. In auto mode, the StarterPack's hooks would be one of the few remaining enforcement layers.
- **Key Insight**: The StarterPack should test and document compatibility with auto mode, where hooks become the primary (not secondary) safety mechanism.
- **Raw Evidence**: "Instead of approving every file write and bash command, auto mode lets Claude make permission decisions on your behalf."

## Synthesis

### Essential Guardrails (Must-Have)
1. **PreToolUse blocking hooks for destructive operations** — git safety, config protection, and secrets scanning must block (exit 2), not just warn. The StarterPack implements this correctly for git and config, but secrets scanning is only inline for hobby tier. Rationale: destructive operations are irreversible.
2. **Fail-closed error handling in all safety hooks** — every hook must catch all exceptions and default to blocking in safe mode. Rationale: fail-open hooks create false confidence.
3. **Enforcement mode lock** — preventing downgrade from safe to expert mode after setup. The StarterPack implements this well. Rationale: prevents quality erosion.
4. **Conventional commit enforcement** — ensures traceability and meaningful history. Rationale: foundation for audit trail.
5. **Guardian checkpoint system** — pre-commit quality gates with evidence (verdict JSON + diff hash). Rationale: prevents unverified code from entering the repository.

### Optional Guardrails (Nice-to-Have)
1. **Scope lock check (UserPromptSubmit)** — useful for preventing scope creep but not safety-critical. Could be simplified for hobby tier. Rationale: process discipline, not safety.
2. **Build failure reminder (PostToolUse)** — helpful for developer productivity but advisory only. Rationale: quality improvement, not enforcement.
3. **Auto-format hook (PostToolUse)** — nice for consistency but 30s timeout is the longest of any hook. Rationale: style, not substance.
4. **Stop gate check** — session-end housekeeping reminder. Rationale: hygiene, not safety.

### Guardrails That Waste Context (Remove)
1. **Verbose guardian prompts for hobby tier** — the StarterPack already skips guardians for hobby, but the CLAUDE.md still contains extensive guardian documentation that gets loaded into context for all tiers. Consider conditional loading or a tier-specific CLAUDE.md variant.
2. **Full standards reference loading** — the StarterPack wisely says "never load full .ref-standards.md" but the routing table and multiple references to it still consume context tokens describing how not to load it.
3. **Repeated enforcement mode explanations** — the concept of safe vs expert mode is explained in CLAUDE.md, setup flow, guardian prompts, and multiple hook comments. A single canonical reference would save context.

### Recommended Hook Configuration
| Hook | Trigger | Purpose | Context Cost |
|------|---------|---------|-------------|
| block-dangerous-git.sh | PreToolUse (Bash) | Block destructive git operations | LOW — fast regex, no LLM |
| protect-config.sh | PreToolUse (Write\|Edit) | Lock enforcement_mode | LOW — fast JSON check |
| protect-config-bash.sh | PreToolUse (Bash) | Lock enforcement_mode via bash | LOW — fast pattern match |
| check-traceability.sh | PreToolUse (Write\|Edit) | Ensure story linkage | LOW — file existence check |
| enforce-conventional-commit.sh | PreToolUse (Bash) | Validate commit message format | LOW — regex validation |
| pre-commit-guardian-gate.sh | PreToolUse (Bash) | Verify guardian verdict before commit | LOW — JSON freshness check |
| scope-lock-check.sh | UserPromptSubmit | Detect scope creep | LOW — pattern match |
| check-test-exists.sh | PostToolUse (Write\|Edit) | Remind about test coverage | LOW — file existence check |
| auto-format.sh | PostToolUse (Write\|Edit) | Run code formatter | MEDIUM — spawns external tool, 30s timeout |
| build-failure-reminder.sh | PostToolUse (Bash) | Track build failures | LOW — exit code check |
| inject-context.sh | SessionStart (compact) | Restore context after compaction | MEDIUM — reads/injects state files |
| check-repeated-errors.sh | SessionStart (startup\|resume) | Detect recurring errors | LOW — log scan |
| verify-gate-evidence.sh | TaskCompleted | Check gate completion evidence | LOW — file check |
| stop-gate-check.sh | Stop | Session-end housekeeping | LOW — state check |

## Source Registry
| # | Source | URL | Type | Date Accessed |
|---|--------|-----|------|---------------|
| 1 | Backslash Security — Claude Code Security Best Practices | https://www.backslash.security/blog/claude-code-security-best-practices | Blog | 2026-03-25 |
| 2 | eesel.ai — Deep dive into security for Claude Code | https://www.eesel.ai/blog/security-claude-code | Blog | 2026-03-25 |
| 3 | Anthropic — Claude Code Security Documentation | https://code.claude.com/docs/en/security | Official Docs | 2026-03-25 |
| 4 | Pixelmojo — Claude Code Hooks Reference: All 12 Events | https://www.pixelmojo.io/blogs/claude-code-hooks-production-quality-ci-cd-patterns | Blog | 2026-03-25 |
| 5 | Serenities AI — Claude Code Hooks Guide 2026 | https://serenitiesai.com/articles/claude-code-hooks-guide-2026 | Blog | 2026-03-25 |
| 6 | Albert Sikkema — Securing YOLO Mode | https://albertsikkema.com/ai/security/development/tools/2026/02/01/securing-claude-code-hooks-best-practices.html | Blog | 2026-03-25 |
| 7 | GitHub — dwarvesf/claude-guardrails | https://github.com/dwarvesf/claude-guardrails | GitHub Repo | 2026-03-25 |
| 8 | SiliconANGLE — Anthropic unchains Claude Code with auto mode | https://siliconangle.com/2026/03/24/anthropic-unchains-claude-code-auto-mode-allowing-choose-permissions/ | News | 2026-03-25 |
