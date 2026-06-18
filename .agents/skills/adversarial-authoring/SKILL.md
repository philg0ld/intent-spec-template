---
name: adversarial-authoring
description: Use when a high-stakes OpenSpec artifact (proposal, design, specs) warrants an independent adversarial review before it is finalized, or when the user asks for "adversarial authoring", "model council", "cross-model review", or a refute pass. One subagent authors a draft, a second independent subagent challenges it, then the primary agent reconciles and records council notes.
---

# Adversarial Authoring

Reduce single-perspective bias on a high-stakes artifact: one subagent authors a
draft, a second independent subagent challenges it, and the primary agent reconciles
before writing the final artifact. The reviewer works from the draft alone (fresh
context) with a refute objective, so it catches gaps the author rationalized away.

## When to use (high-stakes only)

This pass costs two subagent round-trips plus a council-notes sidecar. Use it only
when the artifact is high-stakes:

- cross-pipeline / cross-cutting change
- PII or data-contract change
- a durable architectural decision (ADR-worthy)
- a multi-agent handoff
- anything heading to team review

Skip it (author normally) for trivial or mechanical changes, anything with no
interface or decision, and throwaway spikes.

## Workflow

1. Identify the artifact and its target path. Gather the full context first: the user
   request, the OpenSpec instruction for the artifact, the artifact template, project
   context, artifact-specific rules, and any dependency artifacts already written.
2. Dispatch the `adversarial-author` subagent with that context to produce the draft.
3. Dispatch the `adversarial-reviewer` subagent with the draft plus the same context
   to challenge it.
4. Reconcile as the primary agent: accept changes that improve correctness, clarity,
   requirements coverage, or risk handling; reject suggestions that conflict with the
   user request, the template, the OpenSpec instruction, or project rules; ask the user
   only when a disagreement changes product intent or cannot be resolved from context.
5. Write the final artifact to its path.
6. Write the council-notes sidecar (below).

In Claude Code, dispatch the subagents with the Task tool, `subagent_type:
adversarial-author` and `adversarial-reviewer` (defined in `.claude/agents/`). They are
pinned to different model tiers, are read-only, and return text only — the primary
agent is the sole writer.

## Model diversity (optional upgrade)

The strongest form uses different model *providers* for author and reviewer (e.g. a
non-Claude reviewer) to break correlated blind spots. Vanilla Claude Code subagents run
Claude models only, so this port uses different *tiers* (author / reviewer) for context
and objective independence. To add true cross-provider diversity, route the reviewer
through an MCP tool that proxies to another provider. Optional, not required.

## Council notes

For every artifact authored through this skill, write a sibling council-notes file:

- `proposal.md` -> `proposal.council.md`
- `design.md` -> `design.council.md`
- `spec.md` -> `spec.council.md`

Keep it in the same directory as the artifact. Structure:

```markdown
# Council Notes: <artifact>

## Author Summary
<concise summary of the author draft; no raw transcript or hidden reasoning>

## Reviewer Challenges
- <specific objection, gap, ambiguity, or risk the reviewer raised>

## Resolutions
- Accepted: <change incorporated and why>
- Rejected: <suggestion not incorporated and why>
- Deferred: <issue moved to later work>

## Remaining Risks
- <risk or uncertainty that remains after reconciliation>
```

Council notes are an audit trail, not the canonical artifact. Keep them concise.

## Guardrails

- High-stakes only; for routine work, author normally without this pass.
- Keep the authored artifact clean and canonical; put process detail in the
  `.council.md` file.
- Follow the artifact template and OpenSpec instruction exactly. Do not copy project
  context or rules verbatim into the final artifact unless the template requires it.
- Prefer one author round and one review round; add a second author revision only when
  the reviewer identifies a concrete correctness issue.
- The primary agent owns the final synthesis and is the only writer.
- No raw model dialogue, hidden chain-of-thought, or full transcripts in the artifact
  or council notes.
- If subagents are unavailable, say adversarial authoring could not be completed and ask
  whether to proceed with primary-agent authoring only.
