# RM10 Entrance Condition Retry Rule

Last refreshed: `2026-04-16`

## Evidence Base

Phase `01.2.3.4.1.1.3.1.2.2` ran 7 fresh single-row `cpu_a` anchors under
controlled pre-run states on `/data/local/tmp/dm3_runner` with the same stronger
envelope. The battery tested deep-clean cold, shallow-clean, no-clean immediate
reruns, and deep-clean short idle, capturing full pre-state bundles.

Artifact:
`artifacts/phase_01_2_3_4_1_1_3_1_2_2_entrance_condition_20260416T000556Z`

## What The Battery Found

1. The regime (HIGH delta_E ~88-89 vs LOW delta_E ~75-76) is sharply bimodal
   with no intermediate values.
2. The regime is NOT controlled by residual output files, idle duration, thermal
   state, or operator-visible cleanup protocol.
3. The strongest candidate is internal RNG seeding interacting with a bistable
   harmonic training landscape, biased by binary/library page cache warmth.
4. Deep-clean cold after extended idle reliably produced LOW (2/2).
5. Runs after recent invocations biased HIGH (4/5, with one exception at
   very short inter-run gap).
6. ALL 7 anchors were SLOW (~194-213s). The FAST session (~155s) from the
   original repaired packet was NOT reproduced.

## Retry Rule For Full Four-Row Confirmation Replay

A full same-family four-row confirmation replay may reopen ONLY when ALL of
the following conditions are met:

### Gate 1: Warm-up protocol

Before the official replay, run at least one throwaway `cpu_a` anchor. Discard
the throwaway result. The purpose is to warm binary page cache and bias toward
the HIGH regime.

### Gate 2: Pre-replay classification anchor

After the throwaway warm-up, run one classification `cpu_a` anchor with full
pre-state capture. Classify the result:

- If HIGH (delta_E > 82, coherence < 0.82): PROCEED to full replay
- If LOW (delta_E < 82, coherence > 0.82): ABORT. The session is in the LOW basin.
  Retry from Gate 1 with a fresh warm-up, or wait and try again later.

### Gate 3: Locked envelope

The full replay must use the exact same envelope as the prior packets:
- binary: `/data/local/tmp/dm3_runner` (sha256: `daaaa84a...`)
- cwd: `/data/local/tmp`
- rows: `cpu_a,gpu_a,gpu_b,cpu_b`
- row timeout: 420 seconds
- `--mode train --task harmonic --steps 1`
- CPU rows use `--cpu`, GPU rows omit `--cpu`

### Gate 4: Full pre-state capture

Before each row, capture: battery, thermal, loadavg, process snapshot,
binary hash, and sidecar listing. The same capture protocol used in Phase
`01.2.3.4.1.1.3.1.2.2`.

### Gate 5: Reproducibility standard

The replay must produce a packet where ALL four rows are in the HIGH regime
(delta_E > 82 on all rows). If ANY row falls LOW, classify the replay as
`non_reproducible` and return to entrance-condition investigation.

## What Must Stay Blocked Until This Rule Is Cleared

- Homeostasis batteries
- Broader chamber-science language
- NPU execution claims
- Explicit heterogeneous role partition
- Source-built language for fresh RM10 lanes

## What This Rule Does NOT Resolve

- The FAST session axis (~155s) remains unexplained and unreproduced
- Whether the RNG seed can be controlled without source modification
- Whether the bistability is a property of the binary's training algorithm or
  of the specific harmonic task configuration
- Whether different `--task` options or `--steps` values would show the same
  bistability
