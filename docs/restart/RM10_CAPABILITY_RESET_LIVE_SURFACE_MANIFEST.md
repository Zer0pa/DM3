# RM10 Capability Reset Live Surface Manifest

## Live Surface

| Field | Value |
| --- | --- |
| phase | `01.2.3.4.1.1-01` |
| primary instrument | RM10 Pro (`FY25013101C8`, `NX789J`) |
| live lane id | `rm10_f1_cleanup_control` |
| execution root | `/data/local/tmp` |
| workspace root | `/data/local/tmp/SoC_runtime/workspace` |
| launcher path | `/data/local/tmp/genesis_cli` |
| wrapper surface | `PATH=/data/local/tmp/SoC_Harness/bin:$PATH` |
| live output root | `/data/local/tmp/SoC_runtime/workspace/audit` |
| current live output leaf | `/data/local/tmp/SoC_runtime/workspace/audit/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z` |
| boot proof artifact | `artifacts/phase_01_2_3_4_1_1_cleanup_smoke_20260405T202714Z` |
| binary SHA-256 | `e64ec08e4f8dedddea05b00b3c84c830ee3c9d5afb7cbb1acd4ade5c6f51bcae` |
| boot verdict | `PASS` |
| default validator telemetry | `exit 1` |
| explicit-hash validator telemetry | `exit 0` |

## Support Root

| Field | Value |
| --- | --- |
| support role | Mac recovery and contrast only |
| support root | `/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f` |
| authority note | support only; not the primary Wave 1 instrument |

## Quarantine Boundary

| Field | Value |
| --- | --- |
| quarantine root | `/data/local/tmp/phase_01_2_3_4_1_1_quarantine_20260405T202459Z` |
| root-surface stale outputs moved | `62` |
| prior `F1` audit entries moved | `12` |
| rescue reference | `artifacts/phase_01_2_3_4_1_1_rescue_pack_20260405T202422Z` |

Quarantined material includes:

- root-level residue probe receipts, JSONL packets, stdout/stderr captures, and
  legacy CSV output logs
- the entire pre-cleanup governed `F1` audit tree

## Preserved Non-Live Surfaces

| Surface | Status | Why It Is Not Live |
| --- | --- | --- |
| `/data/local/tmp/snic_workspace_a83f` | preserved support/quarantine | raw-workspace witness archive, not the cleaned `F1` lane |
| `/data/local/tmp/dm3_runner` | preserved residue surface | top-level residue runner; not used for Wave 1 bring-up |
| `/data/local/tmp/dm3` | preserved archaeology surface | bundled archaeology directory; not used for Wave 1 bring-up |

## Live-Path Rules

1. Boot Wave 1 only from `/data/local/tmp/SoC_runtime/workspace` using
   `/data/local/tmp/genesis_cli`.
2. Treat `/data/local/tmp/SoC_Harness/bin` as the only allowed wrapper surface
   for this lane.
3. Write new `F1` outputs only under `/data/local/tmp/SoC_runtime/workspace/audit`.
4. Do not use anything under
   `/data/local/tmp/phase_01_2_3_4_1_1_quarantine_20260405T202459Z` as live
   input.
5. Do not switch to `/data/local/tmp/snic_workspace_a83f`,
   `/data/local/tmp/dm3_runner`, or `/data/local/tmp/dm3` to prove the cleaned
   `F1` lane.
