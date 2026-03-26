---
name: setup
description: Interactive project setup questionnaire - configures project type, stack, quality tier, and methodology
---

# Project Setup

Walk the user through setup conversationally. No jargon. Keep it friendly.

## Step 1: The Basics

Ask these questions one group at a time (don't dump them all at once):

1. **What's your project called?** (a short name, e.g., "my-app")
2. **Describe it in one sentence.** What does it do or what problem does it solve?
3. **What tech stack?** Language, framework, database — or say "not sure" and I'll suggest one based on your description.

## Step 2: Quality Tier

Explain the three options in plain language, then ask which fits:

| Tier | Best for | What it means |
|------|----------|---------------|
| **Lightweight** | Scripts, experiments, personal tools | Minimal process. I'll still write good code but won't slow you down with gates and reviews. |
| **Standard** | Most projects, team apps, client work | Balanced. Quality gates at key milestones. Tests required before shipping. |
| **Rigorous** | Production SaaS, enterprise, regulated | Full enforcement. Security scans, design reviews, audit trails, comprehensive testing. |

Default: **Standard** if they're unsure.

## Step 3: Methodology

Ask how they like to work:

| Style | How it works |
|-------|-------------|
| **Iterative** (default) | Work in sprints. Plan, build, review, improve. Good for most projects. |
| **Kanban** | Continuous flow. Pick up tasks, finish them, repeat. Good for maintenance or ongoing work. |
| **Structured** | Phases with formal sign-offs. Good for contracts or fixed-scope projects. |

Default: **Iterative** if they're unsure.

## Step 4: Create Configuration

After collecting answers, create `.project-config.json`:

```json
{
  "version": "4.0",
  "project": {
    "name": "<name>",
    "description": "<description>",
    "stack": "<stack>"
  },
  "tier": "lightweight | standard | rigorous",
  "methodology": "iterative | kanban | structured",
  "created": "<ISO date>"
}
```

## Step 5: Initialize Project

1. Create `PROGRESS.md` with:
   - Project name and description
   - Setup date
   - Current status: "Project initialized"
   - Empty sections: ## Completed, ## In Progress, ## Up Next
2. Initialize git repo if not already one (`git init`)
3. Create `main` branch if it doesn't exist
4. Create a `dev` branch for development work
5. Make initial commit with config and progress files

## Tone

- Talk like a friendly colleague, not a bureaucratic form
- If they seem unsure, pick sensible defaults and confirm
- Celebrate when setup is done: "You're all set! Here's what I configured..."
- Summarize the configuration at the end so they can confirm
