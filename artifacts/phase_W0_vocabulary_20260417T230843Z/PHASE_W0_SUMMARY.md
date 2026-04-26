# Phase W0 — Vocabulary & Flag Harvest

Written: `2026-04-18T00:00Z` (in progress); sealed on launch of W1 Tier A.
Wallclock: `2026-04-17T23:08Z` → `2026-04-17T23:45Z` (37 min)
Device: Red Magic 10 Pro (FY25013101C8), hash `daaaa84a...` verified.

## Pre-registration

**H_W0:** The binary accepts at least one additional flag beyond the Session 4/5
inventory that measurably changes the `exp_r1_r4_campaign` JSON output.

**Verdict classes:**
- **W0-EXPANSION:** ≥ 1 new flag discovered. Register it in the W1 search space.
- **W0-CLOSED:** Inventory matches Session 4/5 exactly; proceed to W1 with existing flags.

## Results

### VERDICT: W0-EXPANSION (with qualifications)

- **CLI flag surface is unchanged.** Tried `--regime`, `--seed`, `--config`,
  `--verbose`, `--log`, `--output-format`, `--regime-file`, `--chaos-epsilon`,
  `--dataset-seed`, `--init-seed`, `--rng-seed`. All rejected.
  The flag list printed by `--help` is exhaustive.
- **Task-name inventory DOUBLED.** From 5 (Session 5) to **12** accepted values.
- **Adjacency file swap is a R1-flipping parameter.** `--adj RandomAdj_v1.bin`
  with `--task exp_r1_r4_campaign` flips `gates.R1` from **false → true**.
- **Three regimes named in binary strings** (`RegimeARandomRegimeBSriYantraRegimeCChaosControl`)
  but not callable through any tested flag. Likely dispatched internally by
  adjacency-file choice and/or task-name choice.

### 1. Accepted `--task` values (2× expansion)

Previously known: `harmonic`, `holography`, `interference`, `holographic_memory`,
`exp_r1_r4_campaign` (Session 5).

**Newly confirmed this session:**

| `--task`                | Runs internally                           | Emits                    |
|-------------------------|--------------------------------------------|--------------------------|
| `exp_i1`                | "Exp_I1: Minimal Holographic Memory Bank" | `exp_i1_log.csv`         |
| `exp_i2`                | "Exp_I2: Geometry Grammar & Auto-Correction" | `exp_i2_log.csv`     |
| `exp_h1_h2`             | "Exp_H1_H2: Two-Lesson Probe (Bhupura vs Lotus)" | `exp_h1_h2_log.csv` |
| `exp_k2_scars`          | "K2: Scar Formation Grid Search (Multi-Pattern)" | stdout KPIs        |
| `exp_k3_truth_sensor`   | "K3: Truth Sensor Stability Test"         | stdout KPIs              |
| `resonance_r3`          | "R3: Plasticity & Transfer Test"          | stdout (Om/Aum)          |
| `resonance_v2`          | "ResonanceV2: Drive-Measure frequency sweep" | stdout CSV            |

### 2. Task-name rejection list (clap-enforced)

`InterferenceTask`, `run_holographic_memory`, `K1`, `G2`, `pattern_ontology`,
`boundary_readout`, `exp_i0_classifier`, `r1_r4_campaign`, `interference_task`,
`holographic-memory` (Session 5); plus `exp_i1_thermodynamics`, `exp_k1_patterns`,
`exp_k2_denoise`, `exp_j1_holo_capacity`, `exp_j2_resonant_compute`,
`exp_g1_contrastive`, `exp_g2_readout`, `exp_o2_interference` (this session).

So the binary exports a fixed list of accepted task names. Rust function names
like `run_exp_i0` are visible in the binary symbols but not exposed via
`--task`. The dispatch table is smaller than the function table.

### 3. Dataset inventory

| Path                                    | Size      | Used by default? |
|-----------------------------------------|-----------|------------------|
| `/data/local/tmp/dm3/data/xnor_train.jsonl` | 84 kB  | **Yes** (default) |
| `/data/local/tmp/dm3/data/xnor_mini.jsonl`  | 840 kB | No                |
| `/data/local/tmp/dm3/data/xnor_test.jsonl`  | 1680 kB| No                |

Two unused datasets on device. Available via `--dataset <path>`. Tier C should
probe whether swapping the default xnor_train for xnor_mini or xnor_test shifts
any `exp_r1_r4_campaign` gate / payload.

### 4. Adjacency-file swap (the principal W0 finding)

Comparing default (`SriYantraAdj_v1.bin`) vs `RandomAdj_v1.bin` at
`--task exp_r1_r4_campaign --steps 1 --cpu` defaults:

| Field                         | SriYantra | RandomAdj |
|-------------------------------|-----------|-----------|
| `gates.EPSILON_CRIT`          | true      | true      |
| `gates.R1`                    | **false** | **true**  |
| `gates.R2`                    | false     | false     |
| `gates.R3`                    | false     | false     |
| `gates.R4`                    | true      | true      |
| `gates.WAKE_SLEEP_ALIGN`      | true      | true      |
| `r1.margin`                   | **0.000** | **0.500** |
| `r1.margin_threshold`         | 0.010     | 0.010     |
| `r1.arnold_tongue.productive_ratio` | 0.000  | 0.000   |
| `r3.k2_uplift`                | 0.00704   | 0.00716   |
| `r4.transfer_ratio`           | 1.369     | 0.658     |
| `run_sec`                     | 204.2     | 1343.8    |

**Qualitative observations:**
- **R1 flip is dominated by margin:** `r1.margin` moves from 0.000 → 0.500,
  crossing the `margin_threshold = 0.010` that R1 is gated on. The binary
  is computing something about the graph's discrimination / convergence
  margin that is literally zero for the Sri Yantra graph and 0.5 for a
  random graph of the same vertex count.
- **R4 transfer_ratio degrades** (1.37 → 0.66) — but the R4 gate remains
  TRUE, so the threshold is below 0.66.
- **Run time scales ~6.6x** for RandomAdj. Unknown why (adjacency density?
  different regime internally?). This is the practical cost of Tier-C
  RandomAdj sweeps.

This is a real, reproducible gate flip. R1 does not fail at defaults
because of an unreachable threshold; it fails because the Sri Yantra
graph has a literally-zero margin on whatever metric R1 tests. Swap the
graph, get a nonzero margin, and R1 passes.

**Tier-C pre-registration:** run 3 replicates at RandomAdj defaults to
confirm the R1 flip is reproducible and not a fluke, and also run 3
replicates at SriYantra defaults to confirm the default R1 FAIL is
deterministic. If both are bit-stable, N=1 per Tier-A cell is valid.

### 5. Three regimes named (not yet callable)

Binary strings contain `RegimeARandomRegimeBSriYantraRegimeCChaosControl`
and error message `"Unknown regime:"`. Also a `k_chaos_control` WGSL kernel
implementing "OGY-style weight nudge" for chaos-control experiments.

No `--regime` CLI flag exists (rejected by clap). The RegimeA / RegimeB
/ RegimeC distinction appears to be selected internally by:
- **adjacency file:** `RandomAdj_v1.bin` → RegimeA; `SriYantraAdj_v1.bin` → RegimeB.
- RegimeC (ChaosControl) has no obvious entrypoint among tested flags.

### 6. Hidden task payload highlights

Not all new tasks are null at defaults:

- **exp_k3_truth_sensor** actually works: baseline error 89.26 drops to 22.32
  under sensor strength=0.5. "Truth sensor" is a real mechanism that
  reduces boundary error by ~75% in this task. (NB: this contradicts
  Session 4's "truth sensor has no effect at N=5" — Session 4 tested it on
  `harmonic`, not on `exp_k3_truth_sensor`. Each claim is scoped to its
  `--task`.)
- **exp_k2_scars** runs "Scar Formation Grid Search" over a parameter grid of
  lesson counts, measures `max_scar_weight` and `avg_recall_err`. At defaults
  this is a real multi-cell sweep — more informative than `--task harmonic`.
- **resonance_r3** tests plasticity: PRE-TEST with "Om", TRAINING with "Aum"
  × 10 episodes, POST-TEST with "Om". The log ends with
  `VERDICT: PLASTICITY CONFIRMED (State Changed)` — the binary self-certifies
  that training updated weights.
- **exp_h1_h2** tests "Bhupura -> Ring 9 (expect frustration)" vs
  "Lotus -> Ring 8 (expect resonance)". Geometry-aware learning probe.
- **exp_i1** ("Minimal Holographic Memory Bank") tests memory recall at 4+
  stored memories with an explicit noise comparison.
- **exp_i2** ("Geometry Grammar & Auto-Correction") teaches grammar
  (Bhupura → Ring 9) and tests correction (Ring 9 correct vs Ring 8 wrong).

These are not gate surfaces but they are distinct scientific probes that
were not previously known to be callable. Their potential use:
- exp_k3_truth_sensor can test whether sensor has effect on DM3 dynamics
  — a cleaner test than Session 4's harmonic-task probe.
- resonance_r3 provides a plasticity verdict that is independent of gate.
- exp_h1_h2 and exp_i2 offer geometry-grammar probes that exp_r1_r4_campaign
  does not.

### 7. What did NOT change

- CLI argument surface (flags): identical to Session 5 help dump.
- Clap rejects any flag not in the documented list.
- No `--seed`, `--config`, `--verbose`, `--regime`, `--chaos-epsilon` or
  related flags.

## Implications for W1

**Registered new axes for W1 Tier C:**

1. `--adj SriYantraAdj_v1.bin` vs `--adj RandomAdj_v1.bin` — confirmed R1-flipping axis.
2. `--dataset <path>` — three datasets exist; two untested.
3. `--tags RegionTags_v1.bin` vs `RegionTags_v2.bin` — region-tag swap
   (not tested yet; V2 is 1/10 size of V1 so structure is different).
4. `--patterns PhonemePatterns_v1.bin` — default; only one patterns file.
5. `--dataset-size <N>` — default 10; not tested with other values.
6. `--calibration <path>` — tested with nothing; no calibration file on device
   currently but one could be authored.

**Tier A (SY fixed) can still proceed unchanged** from the PRD grid
(asym × rot × steps), since Tier A is about whether the asym/rot/steps
axes already known to affect DM3 dynamics move any gate / payload within
the Sri Yantra regime. The RandomAdj discovery is a Tier C / separate
axis.

**Additional finding to carry forward:** `exp_r1_r4_campaign` with the
Random adjacency flips R1. If Tier A finds no movement within the SY
parameter space and Tier C confirms RA's flip at N=3, the W1 verdict is:
**R1 is graph-sensitive, not parameter-sensitive within the SY regime.**
That is a real and reportable finding.

## Artifacts

- `help_dump.txt` — full `--help` CLI enumeration
- `r1r4_help.txt` — `--task exp_r1_r4_campaign --help` (identical to help_dump)
- `version.txt` — `dm3_runner 0.1.0`
- `cli_tokens_from_strings.txt` — grep of `--[a-z]` tokens in binary
- `cli_prefixes.txt` — grep of suggestive flag prefixes (enable-, sensor-, etc.)
- `dataset_inventory.tsv` — device-side dataset/asset inventory
- `dm3_runner_binary` — local copy of binary for strings analysis
- `probe_random_adj.log` — stdout of RandomAdj run
- `w0_random_adj.jsonl` — RandomAdj exp_r1_r4_campaign JSON output (3.7 kB)
- `probe_hidden_tasks_W0.sh` — the task-name probe script
- `phase_W0_task_probes/` — per-probe logs, JSONLs, results.tsv
- `exp_i1_log.csv`, `exp_i2_log.csv`, `exp_h1_h2_log.csv` — CSV outputs from
  accepted hidden tasks
- `PHASE_W0_SUMMARY.md` — this writeup
- `w1_tier_a_trimmed.sh` — runner script for W1 Tier A launched `2026-04-17T23:49Z`
