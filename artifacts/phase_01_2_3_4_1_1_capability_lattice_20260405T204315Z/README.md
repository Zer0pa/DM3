# Phase 01.2.3.4.1.1 Capability Smoke Lattice Packet

Wave 2 packet for plan `01.2.3.4.1.1-02`.

Scope:

- live lane only: `/data/local/tmp/SoC_runtime/workspace`
- launcher only: `/data/local/tmp/genesis_cli`
- wrapper only: `PATH=/data/local/tmp/SoC_Harness/bin:$PATH`
- no raw-workspace lane, no `F2`, no bundled archaeology lane, no lane substitution

Contents:

- `run_smoke_lattice.py`: plan-scoped capture helper for the bounded `F1` smoke lattice
- `rows/<row-id>/...`: exact row commands, telemetry, pulled receipts, and row summaries
- `comparisons/`: cross-row semantic digest table and response matrix

Row set:

- `r00_control_default_a`: cleaned-lane baseline control
- `r01_control_default_b`: repeated cleaned-lane baseline control
- `r10_priors_off_a`: candidate signal row, priors removed
- `r11_priors_off_b`: repeated candidate signal row, priors removed
- `r20_lpe_off`: positional-encoding perturbation
- `r30_nonharmonic`: harmonic-family perturbation

Rerun examples:

```bash
python3 artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/run_smoke_lattice.py --rows r00_control_default_a r10_priors_off_a
python3 artifacts/phase_01_2_3_4_1_1_capability_lattice_20260405T204315Z/run_smoke_lattice.py
```
