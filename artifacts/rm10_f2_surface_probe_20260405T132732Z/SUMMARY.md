# RM10 F2 Surface Probe

| Scenario | Classification | Exit | CWD | Binary |
| --- | --- | --- | --- | --- |
| `root_cpu_default` | `stalled_after_resonance_start` | `124` | `/data/local/tmp` | `/data/local/tmp/dm3_runner` |
| `root_cpu_explicit_assets` | `stalled_after_resonance_start` | `124` | `/data/local/tmp` | `/data/local/tmp/dm3_runner` |
| `cleanroom_minimal_cpu` | `missing_ambient_dependency` | `1` | `/data/local/tmp/f2_cleanroom_minimal_probe` | `/data/local/tmp/f2_cleanroom_minimal_probe/dm3_runner` |
| `cleanroom_regiontags_v1_cpu` | `stalled_after_resonance_start` | `124` | `/data/local/tmp/f2_cleanroom_rtags_probe` | `/data/local/tmp/f2_cleanroom_rtags_probe/dm3_runner` |
| `legacy_dm3_gpu_train` | `callable` | `0` | `/data/local/tmp/dm3` | `/data/local/tmp/dm3/dm3_runner` |

Interpretation:
- `cleanroom_minimal_cpu` isolates undeclared ambient dependencies on the top-level root runner.
- `cleanroom_regiontags_v1_cpu` shows that `RegionTags_v1.bin` clears the missing-file gate, but the top-level root surface still stalls after resonance start.
- `root_cpu_default` and `root_cpu_explicit_assets` show that the live top-level root surface is not yet ready for an official F2 outlier packet even when inferred defaults are made explicit.
- `legacy_dm3_gpu_train` keeps the older bundled residue runner visible as a separate callable control surface rather than a substitute for the top-level root family.

Next admissible move: Repair or exact-localize the top-level /data/local/tmp/dm3_runner root surface before any official F2 outlier capture or heterogeneous brief.
