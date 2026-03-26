---
description: Coordination rules for multi-instance Cowork sessions
---

# Cowork Coordination Rules

## Task Claiming
Before working on any task, claim it in PROGRESS.md by adding your instance ID and a timestamp under the task entry in the **Task Claims** table. Never start work on an unclaimed task.

## File Ownership
Only one instance may edit a given file at a time. Before editing any file, check the Task Claims and Active Instances tables in PROGRESS.md to confirm no other instance currently owns that file. If the file is claimed, pick a different task.

## PROGRESS.md as Coordination Hub
Read PROGRESS.md before every action. Update it after every task completion, status change, or handoff. PROGRESS.md is the single source of truth for all instance coordination.

## Conflict Resolution
If two instances claim the same task, the earlier timestamp wins. The later instance must:
1. Remove its claim from the Task Claims table.
2. Pick a different unclaimed task.
3. Log the conflict briefly under **Instance Notes**.

## Communication
Leave notes for other instances in PROGRESS.md under the **## Instance Notes** section. Use the format `[instance-id] [timestamp]: message` for traceability.

## Branch Isolation
Each instance works on its own branch named `feat/<task-slug>-<instance-id>`. Never commit directly to the shared integration branch.

## Merge Coordination
Only merge your branch to the shared branch after:
1. All verification gates pass on your branch.
2. You have pulled the latest shared branch and resolved any conflicts.
3. You have updated your task status to `complete` in PROGRESS.md.
