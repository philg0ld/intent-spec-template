---
name: grill-me
description: Interview the user one question at a time to stress-test a proposal or design until intent is fully resolved. Use during proposal creation, when the user wants to be grilled, or asks to pressure-test a plan.
---

# Grill Me

Interrogate the proposal until intent is unambiguous. Walk the decision tree one
branch at a time; resolve each dependency before opening the next.

## Rules

- Ask exactly one question at a time. Wait for the answer before the next.
- For every question, offer your own recommended answer and a one-line why.
- If a question can be answered by reading the codebase, read it instead of asking.
- Stay inside the scope of the current change. Do not redesign unrelated areas.
- Stop when the remaining unknowns no longer change the proposal, then summarise
  what was settled and what is explicitly out of scope.
