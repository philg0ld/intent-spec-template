---
name: "OPSX: Verify"
description: Verify a change post-implementation (intent-spec verify artifact, Experimental)
category: Workflow
tags: [workflow, artifacts, experimental]
---

Produce the `verify` artifact for an OpenSpec change (intent-spec schema).

**Input**: Optionally specify a change name (e.g., `/opsx:verify add-auth`). If omitted, infer from context, or run `openspec list --json` and ask.

**Steps**

1. **Select the change** and announce "Using change: <name>".
2. **Get verify instructions**
   ```bash
   openspec instructions verify --change "<name>" --json
   ```
   Follow the returned instruction. It begins with a PRECHECK that STOPs if there is no implementation evidence (commits since base + completed tasks). Respect it - do not fabricate a verify on un-implemented work.
3. **Run the checks** the instruction lists: structural validation (`openspec validate`), task completion, delta-spec sync, design/specs + ADR coherence, implementation committed.
4. **Write** `openspec/changes/<name>/verify.md` from the schema's verify template and record the Overall Decision (PASS / PASS WITH WARNINGS / FAIL).
5. **Report** the decision and any blocking items.

**Guardrails**
- Never write verify.md without passing the PRECHECK.
- verify.md may be re-run; overwrite with current state.
- Do not mark PASS while structural validation fails.
