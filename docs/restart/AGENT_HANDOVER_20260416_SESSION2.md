# Agent Handover — Session 2

Written: `2026-04-16T01:30Z`
By: Agent that completed Phase 01.2.3.4.1.1.3.1.2.2 and wrote the fresh-eyes
investigation and multi-hypothesis PRD.

## What I Did This Session

### 1. Completed Phase 01.2.3.4.1.1.3.1.2.2 (Entrance-Condition Localization)

Ran 7 single-row `cpu_a` anchors under controlled pre-run states on
`/data/local/tmp/dm3_runner`. Found:

- **The regime is bistable** (HIGH delta_E ~88-89 vs LOW ~74-76) with zero
  intermediate values
- **The selector is NOT operator-controllable** — not file cleanup, not idle
  duration, not thermal state
- **Strongest candidate: internal RNG seeding** interacting with a bistable
  training landscape, biased by binary page cache warmth
- **The FAST session (~155s)** from the repaired packet was never reproduced;
  all 7 anchors were SLOW (~194-213s)
- Wrote a gated retry rule for the full four-row confirmation replay

Artifacts: `artifacts/phase_01_2_3_4_1_1_3_1_2_2_entrance_condition_20260416T000556Z/`

### 2. Fresh-Eyes Investigation

Read the actual geometry source code (Rust crates in recovery/), the manifesto,
the organism doctrine, the training doc hypotheses, and the dm3_runner CLI.

Key discovery: **the binary has a massive unexplored parameter space**:
- `--use-layernorm false` = Hamiltonian/Bicameral mode (transformer OFF)
- `--asymmetry` = Skin Effect (symmetry breaking)
- `--rotation` = Braiding angle (geometric phase)
- `--freq` = drive frequency (resonance control)
- `--gated` = strict resonance gating
- `--enable-truth-sensor` = built-in homeostasis (threshold, strength, cooldown)
- `--task holography` = different task family (untested on this branch)

The branch has only ever tested ONE configuration:
`--task harmonic --steps 1 --cpu --use-layernorm true --asymmetry 0 --rotation 0`

### 3. Multi-Hypothesis PRD

Wrote `docs/restart/DM3_MULTI_HYPOTHESIS_LONG_HORIZON_PRD.md` with:
- 6 hypotheses (H1-H6), each with explicit tests and kill criteria
- 7 phases (A-G), from offline spectral analysis to integrated characterization
- Phases B-E are independent, F needs A, G needs all
- Total device time ~200 minutes plus offline analysis

## What I Think But Did Not Prove

1. The bistability is probably a genuine property of the geometry, not a bug.
   The anti-correlation of energy and coherence suggests two phases (ordered
   vs disordered) on the graph.

2. The FAST session (~155s) may correspond to hitting a resonance frequency
   of the graph — the dynamics converge faster when driven at a natural
   frequency.

3. The transformer/HRM component may be creating or mediating the bistability.
   Testing Hamiltonian mode (`--use-layernorm false`) is the single highest-
   value experiment because it isolates the geometry from the learned adapter.

4. The `--enable-truth-sensor` is literally a built-in homeostasis mechanism.
   It may solve the reproducibility problem that the branch has been treating
   as a blocker.

5. The 380-node graph's spectral analysis is trivially computable on the Mac
   and would provide the theoretical backbone for all subsequent experiments.

## What I Recommend You Do Differently

1. **Don't treat the two regimes as a bug.** Treat them as the first measured
   property of the system. Characterize the bistability instead of fighting it.

2. **Start with Phase A (spectral analysis).** It's offline, costs no device
   time, and tells you the graph's natural frequencies, bottleneck, and
   symmetry structure. It gives you predictions to test.

3. **Test Hamiltonian mode early (Phase C).** If the bistability persists
   without the transformer, you've learned something fundamental about the
   geometry. If it disappears, you've learned the transformer is essential.

4. **Don't over-plan.** The PRD has 7 phases. Run the first 2-3 and let the
   results guide the rest. The PRD is a menu, not a fixed script.

5. **Keep artifacts small.** Mac has only ~17GB free. The RM10 has ~700GB.
   Keep large outputs on-device and pull only receipts and summaries.

## Device State At Handover

- Serial: FY25013101C8, Model: NX789J
- Battery: 80%, 24.0C, AC charging, thermal status 0
- All lanes present and verified:
  - F1: `/data/local/tmp/genesis_cli` (1.9MB)
  - F2: `/data/local/tmp/dm3_runner` (9.1MB, sha256: `daaaa84a...`)
  - Legacy: `/data/local/tmp/dm3/dm3_runner` (8.8MB)
- Assets verified:
  - `SriYantraAdj_v1.bin` (24891 bytes, sha256: `22f4bc8f...`)
  - `RegionTags_v1.bin` (13332 bytes, sha256: `b5ea6d4c...`)
  - `PhonemePatterns_v1.bin` — ABSENT from device
- Residual `.jsonl` on device: `entrance_G_cpu_a.jsonl` (from last anchor)
- No dm3_runner process running
- Load average: ~1.6

## Disk Constraints

- **Mac: 17GB free** — tight. Do NOT store large outputs locally. Pull only
  receipts, summaries, and analysis scripts. Keep the repo under ~200MB.
- **RM10: 699GB free** — plenty. Can store intermediate results on-device.

## Branch State

- Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`
- Repo: `/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform`
- GPD state: `.gpd/STATE.md`, `.gpd/ROADMAP.md`, `.gpd/PROJECT.md` all updated
- Last completed phase: `01.2.3.4.1.1.3.1.2.2`
- No next phase exists yet in the roadmap for the multi-hypothesis work

## Files Written This Session

- `.gpd/phases/01.2.3.4.1.1.3.1.2.2-*/` — 1 research file, 4 plans, 4 summaries
- `artifacts/phase_01_2_3_4_1_1_3_1_2_2_entrance_condition_20260416T000556Z/` — full battery
- `docs/restart/RM10_ENTRANCE_CONDITION_RETRY_RULE.md` (new)
- `docs/restart/DM3_FRESH_EYES_INVESTIGATION.md` (new)
- `docs/restart/DM3_MULTI_HYPOTHESIS_LONG_HORIZON_PRD.md` (new)
- Updated: `ENGINEERING_GAP_LEDGER.md`, `NEXT_BOUNDED_ENGINEERING_MOVE.md`,
  `RM10_REGIME_ENTRANCE_CONDITION_NEXT_MOVE.md`, `STATE.md`, `ROADMAP.md`

## Governing Rules (Unchanged)

- Do not reward hack
- Do not narrate local improvement as the branch win
- Do not reopen pass language from mixed evidence
- Keep F1, F2, and legacy archaeology separate
- Keep geometry sovereign and transformer claims thin
- Treat environment as part of the computation
- Treat thermal/runtime signals as confound screens only
- NPU: ABSTAIN. Heterogeneous: ABSTAIN. Homeostasis: BLOCKED until tested.
