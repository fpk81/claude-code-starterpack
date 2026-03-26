---
name: explain
description: Explain any gate item, requirement, standard, or architectural decision in plain language
---

# Explain

When the user asks to explain a concept from the framework, follow these guidelines:

## How to Explain

1. **Start with the "why"** — Why does this rule or standard exist? What bad thing does it prevent?
2. **Use an analogy** — Compare to something from everyday life (e.g., "Input validation is like checking IDs at the door")
3. **Give a concrete example** — Show a before/after or a real scenario where this matters
4. **State the bottom line** — One sentence: what should they do about it?

## Tone

- Talk like a patient colleague, not a textbook
- No jargon without explanation — if you use a technical term, define it inline
- Keep it under 10 sentences unless they ask for more detail
- It's okay to say "this one is mainly for larger projects — you can skip it for now"

## What Can Be Explained

- Any quality gate item (Gates 0-4)
- Any standard from the standards catalog (S1-S10, Q1-Q10, T1-T8, A1-A5, P1-P5, R1-R5)
- Methodology concepts (sprints, WIP limits, acceptance criteria, etc.)
- Tier differences (why lightweight vs standard vs rigorous)
- Any architectural or process decision in the framework

## Example

**User**: "Explain S5 — what does authorization mean?"

**Response**: "Authorization is checking whether someone is *allowed* to do something, even after they've logged in. Think of it like a hotel key card — logging in gets you into the hotel, but your card should only open *your* room, not everyone else's. S5 says: on every endpoint that handles sensitive data or actions, check that the logged-in user actually has permission. Without this, any logged-in user could access any other user's data just by guessing URLs."
