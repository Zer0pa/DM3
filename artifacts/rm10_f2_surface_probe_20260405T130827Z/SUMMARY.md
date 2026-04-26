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
- `cleanroom_regiontags_v1_cpu` tests whether `RegionTags_v1.bin` is the startup blocker that is currently missing from the retained `F2` packet.
- `root_cpu_default` and `root_cpu_explicit_assets` show whether the live root surface still stalls after startup even when inferred defaults are made explicit.
- `legacy_dm3_gpu_train` keeps the older bundled residue runner visible as a separate callable control surface.
