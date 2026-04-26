# RM10 F2 Surface Probe

| Scenario | Classification | Exit | CWD | Binary |
| --- | --- | --- | --- | --- |
| `root_cpu_default` | `callable` | `0` | `/data/local/tmp` | `/data/local/tmp/dm3_runner` |
| `root_cpu_explicit_assets` | `callable` | `0` | `/data/local/tmp` | `/data/local/tmp/dm3_runner` |
| `cleanroom_minimal_cpu` | `missing_ambient_dependency` | `1` | `/data/local/tmp/f2_cleanroom_minimal_probe` | `/data/local/tmp/f2_cleanroom_minimal_probe/dm3_runner` |
| `cleanroom_regiontags_v1_cpu` | `callable` | `0` | `/data/local/tmp/f2_cleanroom_rtags_probe` | `/data/local/tmp/f2_cleanroom_rtags_probe/dm3_runner` |
| `legacy_dm3_gpu_train` | `callable` | `0` | `/data/local/tmp/dm3` | `/data/local/tmp/dm3/dm3_runner` |

Interpretation:
- `cleanroom_minimal_cpu` still isolates undeclared ambient dependencies away from the top-level `/data/local/tmp` working surface.
- `cleanroom_regiontags_v1_cpu` is callable, so `RegionTags_v1.bin` clears the cleanroom startup gate when the other retained assets are present.
- `root_cpu_default` proves the live top-level `/data/local/tmp/dm3_runner` family is callable under an honest timeout on the real device surface.
- `root_cpu_explicit_assets` is also callable, so making the inferred assets explicit does not break the live top-level family.
- `legacy_dm3_gpu_train` remains callable as a separate older residue surface, but it stays fenced from the top-level root family.

Next admissible move: The top-level /data/local/tmp/dm3_runner root surface is callable; the next admissible move is the official F2 outlier capture under hardened governance.
