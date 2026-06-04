# 0001. Record architecture decisions

- Status: accepted
- Date: 2026-06-03

## Context

We need to record the architecturally significant decisions on this project, to
onboard future contributors and to give the `intent-spec` design phase a durable
record of decisions still in force.

## Decision

We will use Architecture Decision Records as Markdown files under `docs/adrs/`,
one per decision, named `NNNN-kebab-title.md`. ADRs are immutable once accepted;
a decision is changed by adding a new ADR that supersedes the prior one. This
folder lives outside `openspec/` so change-archiving never removes it.

## Consequences

- The design phase reads `docs/adrs/` to honour in-force decisions.
- History is preserved; superseded ADRs remain as record.
- Contributors add an ADR for each architecturally significant choice.
