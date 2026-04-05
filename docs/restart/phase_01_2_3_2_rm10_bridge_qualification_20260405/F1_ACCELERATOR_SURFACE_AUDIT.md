# F1 Accelerator Surface Audit

## Verdict

- `bridge_verdict=bridge_closed`

## Live Help Surface

The retained live `genesis_cli --help` surface exposes only:

- deterministic pipeline execution
- test-battery replay
- validation against canonical hashes
- progeny generation
- audit reporting
- lineage batch execution

The surfaced options are limited to flags such as:

- `--protocol`
- `--runs`
- `--output-dir`
- `--config`
- `--capsule`
- `--test-battery`
- `--validate`
- `--verify-hash`
- `--solve-hash`
- `--progeny`
- `--audit-report`
- `--lineage-batch`

## What Is Absent

The governed executable surface does **not** expose any evidenced selector for:

- GPU mode
- accelerator choice
- NPU or DSP dispatch
- mixed-stage ownership
- CPU-to-accelerator handoff
- alternate governed wrapper preserving the same `F1` observable family

## Classification Rule Applied

This audit is restricted to the live governed `genesis_cli` surface captured in
`artifacts/phase_01_2_3_2_f1_anchor_20260405/logs/help.txt`.

The branch does **not** count:

- hardware presence
- QNN or DSP libraries
- bundled-residue GPU callability
- imagined wrappers

as evidence for a governed `F1` bridge.

## Conclusion

The current governed RM10 `F1` surface has no callable accelerator-bearing
entrypoint. Any future bridge claim would require a newly evidenced same-family
surface, explicit wrapper provenance, or explicit redevelopment. On the current
live governed surface, the bridge is closed.
