#!/usr/bin/env bash
#
# check-base-drift.sh — guard the shared base templates across the OpenSpec
# schema lineage.
#
# Relationship:
#   intent-spec   = the base (this repo).
#   fdm           = a deliberate DERIVATIVE: it may ADD sections / comments
#                   (domain hints such as "## Data flow / lineage"), but it must
#                   not LOSE or RENAME a base section.
#   intent-driven = the external upstream that inspired intent-spec; reported for
#                   information only, never enforced.
#
# Invariant enforced: every section heading in intent-spec's base templates
# (proposal, spec, design, tasks) also exists in fdm's. adr.md is intentionally
# divergent (Nygard envelope vs upstream) and is excluded. Instruction-prose drift
# inside schema.yaml is out of scope for this check.
#
# Exit 1 if fdm dropped or renamed a base section. Override sibling repo locations
# with FDM_ROOT / IDRIVEN_ROOT if your checkout layout differs.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ISPEC_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FDM_ROOT="${FDM_ROOT:-$ISPEC_ROOT/../misc/fdm-spec-template}"
IDRIVEN_ROOT="${IDRIVEN_ROOT:-$ISPEC_ROOT/../misc/intent-driven-template}"

ISPEC="$ISPEC_ROOT/openspec/schemas/intent-spec/templates"
FDM="$FDM_ROOT/openspec/schemas/fdm/templates"
IDRIVEN="$IDRIVEN_ROOT/openspec/schemas/intent-driven/templates"

BASE_TEMPLATES=(proposal spec design tasks)

# Normalized section headings: 1-4 '#', inline HTML comments stripped, whitespace
# collapsed and trimmed, de-duplicated and sorted (comm requires sorted input).
headings() {
  grep -E '^#{1,4}[[:space:]]' "$1" 2>/dev/null \
    | sed -E 's/<!--.*-->//; s/[[:space:]]+/ /g; s/[[:space:]]+$//' \
    | sort -u
}

fail=0
for t in "${BASE_TEMPLATES[@]}"; do
  base="$ISPEC/$t.md"; deriv="$FDM/$t.md"
  if [ ! -f "$base" ];  then echo "DRIFT  $t.md: missing intent-spec base ($base)"; fail=1; continue; fi
  if [ ! -f "$deriv" ]; then echo "DRIFT  $t.md: missing fdm derivative ($deriv)"; fail=1; continue; fi

  missing="$(comm -23 <(headings "$base") <(headings "$deriv"))"
  extra="$(comm -13 <(headings "$base") <(headings "$deriv"))"

  if [ -n "$missing" ]; then
    echo "DRIFT  $t.md: intent-spec sections absent from fdm:"
    printf '%s\n' "$missing" | sed 's/^/         - /'
    fail=1
  elif [ -n "$extra" ]; then
    echo "ok     $t.md: fdm adds (intentional):"
    printf '%s\n' "$extra" | sed 's/^/         + /'
  else
    echo "ok     $t.md: headings match"
  fi

  if [ -f "$IDRIVEN/$t.md" ]; then
    udiff="$(comm -3 <(headings "$base") <(headings "$IDRIVEN/$t.md"))"
    [ -n "$udiff" ] && echo "info   $t.md: diverged from intent-driven upstream"
  fi
done

echo ""
if [ "$fail" -ne 0 ]; then
  echo "FAIL: base-template drift. Propagate the intent-spec base change into fdm,"
  echo "      or update this check if the divergence is intentional."
  exit 1
fi
echo "PASS: fdm contains every intent-spec base section."
