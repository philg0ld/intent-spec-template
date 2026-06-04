# Intent-Spec OpenSpec Schema

`intent-spec` is a proposal-to-tasks workflow for changes where contributor
intent, observable behaviour, technical design, and durable architectural
decisions should all be captured before implementation.

It keeps specs mergeable by default OpenSpec archive by generating
`specs/<capability>/spec.md` files. The Markdown headings are the OpenSpec
wrapper; the content inside each requirement and scenario is written in Gherkin
style with `GIVEN`, `WHEN`, and `THEN` steps.

## Activate

Set this in `openspec/config.yaml`:

```yaml
schema: intent-spec
```

## Stage gates

```text
proposal -> specs -> design -> adr -> tasks
```

- `proposal` states why the change matters and lists the capabilities that need behaviour specs.
- `specs` creates one OpenSpec Markdown delta file per capability at `specs/<capability>/spec.md`.
- `design` explains the implementation approach and accounts for currently in-force ADRs.
- `adr` records durable architecture decisions after design and before task planning.
- `tasks` are planned only after proposal, specs, design, and ADR artifacts are complete.

## ADR persistence

ADR files are generated under the repository's top-level `docs/adrs/` folder,
outside the OpenSpec change folder, so change-archiving never deletes them.
Accepted ADRs are immutable. If a future decision changes a prior ADR, create a
new ADR that supersedes the old one and leave the original file unchanged.

## Validate

```bash
openspec schema validate intent-spec
```

Inspired by the `intent-driven` schema from https://github.com/intent-driven-dev/openspec-schemas.
