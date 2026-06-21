# Install Intent-Spec Template

Instructions for an AI agent (Claude Code) asked to add this template to an
existing project. First-time install only; upgrades are out of scope.

## Goal

Install the `intent-spec` OpenSpec schema, skills, and Claude Code wiring into a
target project without overwriting project-specific work.

## Review first

Inspect the target for existing `openspec/`, `.claude/`, `.agents/`, `AGENTS.md`,
`CLAUDE.md`. Preserve user instructions and conventions. Never replace a file
without explaining the conflict and getting approval.

## Steps

1. Ensure OpenSpec is available: `openspec --version` (expect 1.3.x).
2. If `.claude/commands/opsx/` is absent, run `openspec init --tools claude --profile custom`.
3. Copy from this template if absent in the target:
   - `openspec/schemas/intent-spec/`
   - `openspec/config.yaml` (or merge: set `schema: intent-spec` and add the `rules:` block)
   - `.agents/skills/` (all 6 workflow skills: `adversarial-authoring`,
     `architectural-decision-records`, `c4-diagrams`, `gherkin-authoring`,
     `grill-me`, `openspec-git-discipline`)
   - `.claude/commands/opsx/` template-specific commands not produced by
     `openspec init`: `adversarial.md`, `retrospective.md`, `verify.md`
     (`explore`/`propose`/`apply`/`archive` come from step 2; the full set is 7)
   - `docs/adrs/0001-record-architecture-decisions.md` (only if `docs/adrs/` is empty)
4. Recreate skill symlinks: for each dir in `.agents/skills/`, create
   `.claude/skills/<name>` -> `../../.agents/skills/<name>`.
5. Merge `AGENTS.md`: add the git-discipline line and skills-location note without
   removing existing instructions. Ensure `CLAUDE.md` imports it (`@AGENTS.md`) or
   carries the project's own instructions.
6. Validate: `openspec schema validate intent-spec`; `git status --short`.
7. Summarize exactly what changed.
