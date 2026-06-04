# AGENTS.md

This project uses OpenSpec with the local `intent-spec` schema
(`proposal -> specs -> design -> adr -> tasks`).

- For any OpenSpec propose/apply/archive workflow, use the local
  `openspec-git-discipline` skill: proposal artifacts must reach `main` before
  apply, and implementation must merge to `main` before archive. Never commit,
  branch, or merge without explicit approval.
- Skills live in `.agents/skills/` and are symlinked into `.claude/skills/`.
- ADRs live in `docs/adrs/` and are immutable once accepted.
