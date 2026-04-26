# F2 Required Capture Matrix

Last refreshed: `2026-04-05`

Use this matrix for the one allowed `F2` outlier-localization diagnostic.
Anything marked `required` is part of interpretability, not convenience.

| Capture item | Status | Minimum content | Why it matters | If missing |
| --- | --- | --- | --- | --- |
| Session question and row order | `required` | one sentence naming the outlier-localization question plus the declared four-row order | prevents the run from widening into replay theater | diagnostic is uninterpretable |
| Device identity packet | `required` | device serial, model, build fingerprint, `ro.hardware.vulkan`, and any lane-specific GPU property captured before the first row | proves all rows came from the same device surface | diagnostic is uninterpretable |
| Binary identity | `required` | path `/data/local/tmp/dm3_runner`, sha256, file size, and explicit note that the alternate residue binary was not used | prevents family drift or binary ambiguity | diagnostic is uninterpretable |
| Cwd and env manifest | `required` | exact cwd, PATH, shell wrapper, and any non-default env values | keeps the execution surface locked | diagnostic is uninterpretable |
| Exact command ledger | `required` | exact CPU and GPU-backed commands for all four rows, recorded before execution | proves same-family comparability | diagnostic is uninterpretable |
| Stdout and stderr logs | `required` | per-row logs retaining CPU-forced markers or GPU-init markers | localizes whether the intended lane actually ran | diagnostic is uninterpretable |
| Receipt files | `required` | per-row one-line JSONL output plus file hash and byte count | preserves the comparable observable | diagnostic is uninterpretable |
| Receipt summary table | `required` | `delta_E`, `coherence`, duration, decision field, and receipt path for each row | makes the outlier classification auditable | diagnostic is uninterpretable |
| Telemetry pre and post session | `required` | battery level, battery temperature, and thermal status before row 1 and after row 4 | rules out gross session-level thermal drift | diagnostic is weakened; record `uninterpretable` if omitted entirely |
| Telemetry pre and post each row | `required` | battery temperature and thermal status immediately before and after each row | localizes whether the outlier correlates with per-row thermal movement | diagnostic is uninterpretable |
| Timestamp ledger | `required` | start and end timestamps for every row | supports order-sensitivity analysis | diagnostic is weakened; if row order cannot be reconstructed, it is uninterpretable |
| Output directory manifest | `required` | artifact root, per-row filenames, and a final file inventory | preserves custody for later audit | diagnostic is uninterpretable |
| Alternate residue binary inventory | `required` | hash of `/data/local/tmp/dm3/dm3_runner` captured as non-used context only | proves the operator saw the alternate binary and did not silently switch families | diagnostic is weakened; if a switch cannot be ruled out, it is uninterpretable |
| GPU or kernel telemetry beyond thermal | `best_effort` | any readable GPU busy, meminfo, or kernel signal captured without changing the run surface | may help explain the outlier without reopening scope | absence does not invalidate the diagnostic |
| Screenshot or terminal transcript bundle | `best_effort` | operator-facing transcript or screenshots of the bounded session | useful for handoff and auditing | absence does not invalidate the diagnostic |

## Minimum Interpretability Rule

The diagnostic is only interpretable if all `required` items are present and
the receipt schema remains the same across all four rows.

## Explicit Non-Substitutions

These do not substitute for the required matrix:

- oral explanation without logs
- final JSONL files without stdout or stderr markers
- session-level telemetry without per-row telemetry
- a hash for the chosen binary without proof that the alternate residue binary
  was not used
