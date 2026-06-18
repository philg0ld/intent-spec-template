---
name: "OPSX: Adversarial"
description: Independent adversarial author/review pass on a high-stakes OpenSpec artifact
category: Workflow
tags: [workflow, adversarial, experimental]
---

Run an adversarial authoring pass on a single high-stakes artifact: one subagent drafts
it, an independent subagent challenges the draft, then you (the primary agent) reconcile
and write the final artifact plus council notes.

**Input**: `/opsx:adversarial <artifact> <change>` — `<artifact>` is one of
`proposal | design | specs`; `<change>` is the change name. If either is missing, infer
from context; if ambiguous, run `openspec list --json` and use the **AskUserQuestion
tool** to select.

**When this is warranted** (high-stakes only — otherwise author normally, no pass):
cross-pipeline / cross-cutting change, PII or data-contract change, a durable
architectural decision, a multi-agent handoff, or anything heading to team review.

**Steps**

1. Confirm the artifact and change. Announce "Adversarial pass: <artifact> for <change>".
2. Gather context: `openspec instructions <artifact> --change "<change>" --json`, the
   artifact template, project context / rules, and any dependency artifacts already written.
3. Run the pass via the **adversarial-authoring skill**:
   - Dispatch the `adversarial-author` subagent (Task tool) with the full context -> get the Draft.
   - Dispatch the `adversarial-reviewer` subagent with the draft plus the same context -> get the challenges.
   - Reconcile yourself: accept changes that improve correctness / clarity / coverage / risk;
     reject those that conflict with the request, template, instruction, or rules; ask the
     user only if a disagreement changes product intent.
4. Write the final artifact to its path.
5. Write `<artifact>.council.md` beside it: Author Summary / Reviewer Challenges /
   Resolutions / Remaining Risks.

**Guardrails**
- High-stakes only; for routine changes, author normally without this pass.
- Subagents are read-only and return text; the primary agent owns the final synthesis and
  is the only writer.
- Keep the artifact clean and canonical; process detail lives in the `.council.md` file.
- One author round + one review round; add a second author round only for a concrete
  correctness issue.
- If subagents are unavailable, say so and offer to proceed with primary-agent authoring only.
- Leave commits to the user.
