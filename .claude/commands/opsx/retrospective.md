---
name: "OPSX: Retrospective"
description: Write the retrospective for a verified change (intent-spec retrospective artifact, Experimental)
category: Workflow
tags: [workflow, artifacts, experimental]
---

Produce the `retrospective` artifact for an OpenSpec change (intent-spec schema).

**Input**: Optionally specify a change name (e.g., `/opsx:retrospective add-auth`). If omitted, infer from context, or run `openspec list --json` and ask.

**Steps**

1. **Select the change** and announce "Using change: <name>".
2. **Get retrospective instructions**
   ```bash
   openspec instructions retrospective --change "<name>" --json
   ```
   Follow it. The PRECHECK requires `verify.md` to exist and not be FAIL - if it fails, stop and run `/opsx:verify <name>` first.
3. **Gather evidence**: `git log --oneline <base>..HEAD`, tasks.md, verify.md.
4. **Write** `openspec/changes/<name>/retrospective.md` from the schema's retrospective template (sections 0-6).
5. **Report** the section 6 promote-candidates so they can be lifted into memory.

**Guardrails**
- Never write retrospective.md if verify.md is missing or FAIL.
- Do not rewrite a prior retrospective; add a dated forward-pointer instead.
- Cite evidence (commit / file / test) for each claim.
