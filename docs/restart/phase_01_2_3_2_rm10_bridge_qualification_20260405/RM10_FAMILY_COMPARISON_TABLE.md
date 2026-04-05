# RM10 Family Comparison Table

| Family or lane | Live command surface | Current verdict | Ceiling | Main evidence | Main blocker |
| --- | --- | --- | --- | --- | --- |
| `F1` governed Genesis CPU control | `genesis_cli --protocol` from `/data/local/tmp/SoC_runtime/workspace` | `PASS` | `governed_non_sovereign` | exact `verify.json` and `solve_h2.json` reproduction with intact receipts | validator governance and prebuilt-stub status remain unresolved |
| `F1` accelerator bridge | `genesis_cli --help` | `bridge_closed` | none on current surface | no accelerator-bearing selector on live governed help surface | no same-family accelerator-preserving executable surface |
| `F2` bundled-residue harmonic CPU line | `dm3_runner --mode train --task harmonic --steps 1 --cpu` | `PASS` | `feasibility_only` | same-schema one-line receipts with explicit CPU-forced markers | residue family only |
| `F2` bundled-residue harmonic GPU-backed line | `dm3_runner --mode train --task harmonic --steps 1` | `PASS` at callable ceiling; repeatability `unstable_feasibility` | `feasibility_only` | explicit GPU-init markers plus receipt custody | one GPU-backed repeat drifted materially |
| NPU or DSP assist | bounded inventory and command probe only | `ABSTAIN` | `inventory_only` | QNN libs, RPC libs, and daemons are visible | no callable user-space assist surface |
| explicit heterogeneous handoff | none | `ABSTAIN` | not yet open | no same-family pre-handoff or post-handoff artifact | opaque accelerator use cannot localize stage ownership |
