---
name: cowork-setup
description: Initialize and manage multi-instance Cowork coordination
---

# Cowork Setup Skill

## Initializing Cowork Mode

1. Generate a unique instance ID (e.g., `inst-<short-hash>`).
2. Open or create PROGRESS.md in the project root.
3. Add the Cowork coordination sections if they do not already exist (see format below).
4. Register this instance in the **Active Instances** table with status `active`.
5. Read the task list and claim an available task in the **Task Claims** table.

## PROGRESS.md Cowork Format

Add these sections to PROGRESS.md when initializing Cowork mode:

```
## Active Instances
| Instance | Branch | Current Task | Status | Last Update |
|----------|--------|--------------|--------|-------------|

## Task Claims
| Task | Claimed By | Timestamp | Status |
|------|------------|-----------|--------|

## Instance Notes
[Free-form notes between instances]
```

## Handing Off Work

To gracefully hand off work to another instance:
1. Push all current changes to your feature branch.
2. Update your task status to `handing-off` in the Task Claims table.
3. Add a note under **Instance Notes** describing the current state, what is done, and what remains.
4. Set your instance status to `idle` in the Active Instances table.
5. The receiving instance claims the task, updates the branch reference, and sets status to `in-progress`.

## Resolving Merge Conflicts Between Instance Branches

1. Pull the latest shared integration branch.
2. Attempt to merge your feature branch into a local copy of the shared branch.
3. If conflicts arise, resolve them in your feature branch — never force-push to the shared branch.
4. After resolution, run all verification gates to confirm nothing broke.
5. Log the conflict resolution under **Instance Notes** with details of what was resolved.
6. Only then merge to the shared branch.
