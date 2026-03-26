---
name: methodology-iterative
description: Iterative development methodology - sprint planning, standups, reviews, retrospectives
---

# Iterative Methodology

Work in short cycles (sprints). Each sprint: plan, build, review, improve.
Default sprint length: 1 week for small projects, 2 weeks for larger ones.

---

## Sprint Planning

At the start of each sprint:

1. Review the backlog in PROGRESS.md (## Up Next section)
2. Pick 3-7 items that can realistically be completed this sprint
3. For each item, write acceptance criteria:
   - What does "done" look like?
   - How will we verify it works?
4. Move selected items to ## In Progress
5. Commit the updated PROGRESS.md as the sprint plan

**Sizing guide**: If a story feels bigger than 2-3 days of work, break it down further.

## Daily Check-in

At the start of each work session, briefly review:

- **Done**: What was completed since last session?
- **Next**: What's the focus for this session?
- **Blocked**: Anything stuck or waiting on input?

Update PROGRESS.md accordingly. Keep this under 2 minutes — it's orientation, not a meeting.

## Sprint Review

At the end of each sprint:

1. Demo what was built (walk through completed features)
2. Compare delivered work against sprint plan
3. Mark completed items in PROGRESS.md (move to ## Completed with date)
4. Note any items that weren't finished — carry forward or re-prioritize

## Retrospective

After each sprint review, reflect briefly:

1. **What went well?** (Keep doing these things)
2. **What was frustrating?** (Address or accept these)
3. **What to try next sprint?** (One concrete improvement)

Add a brief retro note to PROGRESS.md. Don't overthink it — one sentence per question is fine.

## Backlog Grooming

Between sprints (or when the backlog gets stale):

1. Review all items in ## Up Next
2. Remove anything no longer relevant
3. Add new items discovered during the sprint
4. Reorder by priority (most important first)
5. Add acceptance criteria to the top 5-10 items so they're ready for next sprint

## Tips

- **Finish before starting** — resist starting new things before completing current work
- **Small batches** — smaller stories get done faster and with fewer surprises
- **Progress over perfection** — ship something working each sprint, then improve
- **Adapt the process** — if something feels pointless, change it in the retro
