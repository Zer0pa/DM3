# RM10 F1 Anchor Dossier

## Verdict

- `f1_anchor_verdict=PASS`
- `authority_status=governed_non_sovereign`
- `build_class=prebuilt_stub`

## Command And Surface

```bash
adb shell 'cd /data/local/tmp/SoC_runtime/workspace && PATH=/data/local/tmp/SoC_Harness/bin:$PATH /data/local/tmp/genesis_cli --protocol --runs 1 --output-dir audit/branch_01_2_3_2_f1_cpu_a'
```

- executable: `/data/local/tmp/genesis_cli`
- executable sha256: `e64ec08e4f8dedddea05b00b3c84c830ee3c9d5afb7cbb1acd4ade5c6f51bcae`
- device model: `NX789J`
- device serial: `FY25013101C8`
- device `cwd`: `/data/local/tmp/SoC_runtime/workspace`
- artifact root: `artifacts/phase_01_2_3_2_f1_anchor_20260405/`

## Fresh Hash Tuple

| File | Fresh hash | Prior branch anchor | Result |
| --- | --- | --- | --- |
| `verify.json` | `f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1` | `f992e9c833f15d579224c463fd730d6b238cf0e7cab26dc551eef4b01bc124a1` | exact |
| `solve_h2.json` | `a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364` | `a33c5cc4a91d1c5bab4adff29d3b56b6cb059f3b2268cc92ea5bf2b201d13364` | exact |

## Receipt And Tree Integrity

The mirrored run tree retains:

- `run00/artifacts/verify.json`
- `run00/artifacts/solve_h2.json`
- `run00/receipts/VERIFY_SUMMARY.json`
- `run00/receipts/MERKLE.txt`
- `run00/public/`

The phase therefore preserved the same governed observable family and the same
receipt surface as the prior branch anchor.

## Thermal And Battery Envelope

| Metric | Pre | Post |
| --- | --- | --- |
| battery level | `80%` | `80%` |
| battery temperature | `31.0 C` | `31.0 C` |
| thermal status | `0` | `0` |
| HAL skin temperature | `33.774 C` | `33.774 C` |
| HAL `nsp0` | `35.5 C` | `36.3 C` |
| HAL `nsp6` | `36.3 C` | `36.6 C` |

No throttling or receipt loss appeared during the anchored governed run.

## Conclusion

The governed RM10 Genesis control family still reproduces cleanly under the
current branch discipline. The branch anchor remains `F1`, not the lower-ceiling
bundled-residue family.
