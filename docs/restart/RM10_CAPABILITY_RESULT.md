# RM10 Capability Result

Classification: `no capability found`

Plain result:

The cleaned RM10 `F1` lane stayed callable and thermally nominal across the
bounded six-row smoke lattice, but every retained row collapsed to the same
semantic receipt signature once direct config-echo fields (`cfg_hash`) and
timestamps were stripped from `verify.json`, `solve_h2.json`, and
`VERIFY_SUMMARY.json`.

What changed:

- raw `verify.json` and `solve_h2.json` hashes changed under
  `CONFIG.no_priors`, `CONFIG.m2_lpe_off`, and `CONFIG.m1_nonharmonic`
  perturbations

What did not change:

- repeated control rows matched exactly
- repeated candidate rows matched exactly
- `VERIFY_SUMMARY.json` stayed byte-identical across all six rows
- `verify.gate_summary`, `VERIFY_SUMMARY.gates`, and `solve_h2.report`
  semantics stayed unchanged across the entire lattice
- default validator telemetry stayed `exit 1`; explicit-hash validation stayed
  `exit 0`

Strongest observable family:

- none beyond one stable semantic receipt family on the cleaned `F1` lane

Weakest disconfirming observation:

- even the orthogonal `lpe_off` and `nonharmonic` perturbations changed only
  raw config-echo hashes and did not create a second semantic receipt family

Wave 3 readiness:

- `NO`
- Do not proceed to property mapping from this battery
