# Phase 01.2.3.4.1.1 Falsifier Packet

Artifact root:
`artifacts/phase_01_2_3_4_1_1_falsifier_20260405T211759Z`

Plan: `01.2.3.4.1.1-06`

Overall verdict: `collapses`

Scope:

- attack the apparent RM10 capability story after cleanup
- keep the phase grounded in retained Wave 1-5 receipts
- preserve only the shortest decisive evidence needed for closeout

Contents:

- `README.md`: packet overview and closeout framing
- `attack_matrix.json`: one row per required attack line with result and source

Short answer:

- the package survives stale-path, validator, output-custody, and
  residue-family contamination attacks as an engineering record
- the apparent capability collapses once the Wave 2 raw hash churn is reduced
  to one semantic family and the downstream property, handoff, and lane gates
  stay closed
- hidden fallback inside the prebuilt-backed `genesis_cli` remains a mechanism
  uncertainty, but it does not rescue a surfaced capability claim on this
  branch contract
