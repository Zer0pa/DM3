# Conventions

This restart begins with conservative working conventions and will only lock stronger ones when they become source-backed.

## Working Restart Conventions

- Geometry terms:
  - `boundary` means the externally exposed node set used for boundary-condition or readout experiments.
  - `bulk` means the interior node set not directly retained in boundary-only reconstruction tests.
  - `dual-meru` refers to the recoverable geometry lineage, not yet to any unrecovered hybrid implementation.
- Dynamics terms:
  - `settling` means discrete iterative evolution toward a fixed point or stable cycle.
  - `energy witness` means any monotonic or candidate-monotonic scalar used to detect stable descent; it is not assumed valid until source-backed.
  - `deterministic replay` means identical or explicitly equivalent receipts across repeated runs.
- Execution lanes:
  - `Mac host` is the first build and replay lane.
  - `RM10 Pro` is the device replay lane under Termux / ADB.

## Lock Discipline

- Do not lock manifesto-derived constants or thresholds until they are replayed from source-backed protocols.
- Do not borrow unrecovered hybrid naming as if it were a stable convention.
