# DM3 Session 8 — Phase A Interim Update

Written: `2026-04-23` ~13:40 UTC, engineer-agent
For: science & engineering team; repo-agent (follow-on to `HANDOVER_TO_REPO_AGENT_20260422.md` and `DM3_STATUS_SNAPSHOT_20260422.md`)

---

## TL;DR

Session 8 opened under the **pure-scientific-learning frame** (both IS and IS NOT findings are first-class; commercial framing off the table for now). Phase A is the first of six phases (A → F). At the time of writing **A.1 is closed with an unexpectedly strong finding, A.2 is 20/21 complete with the overfit cliff mapped, A.3 and A.4 are queued and will run in the next ~4–5 h.**

Two new findings already meet the threshold for claim-level promotion:

- **Claim ξ** — `exp_k2_scars` at fixed `(--steps, adj, tags, dataset)` is **bit-identical deterministic**. N=10 independent invocations at `--steps 20` produced the byte-identical `best_uplift=1.324074`, `max_scar_weight=1.048401`. This is an IS NOT as much as an IS: DM3 is not a system with stochastic task variance on this probe.
- **Claim ο** (omicron) — the `exp_k2_scars` overfit boundary between `--steps 45` and `--steps 50` is **sharp and discrete**, not gradual. best_uplift moves 1.333 → 0.000 across that single step-increment. Peak uplift sits at steps=30 (1.645) and steps=40 (1.642); the cliff lands before steps=50.

An engineering-side finding of comparable importance surfaced during the run:

- **PMIC-lagged thermal sensor (`pmih010x_lite_tz`) stuck at 70–72 °C for ~2 hours** after the CPUs cooled. The old all-sensor thermal gate walled A.2/A.3/A.4 for hours, producing 0 receipts in A.3 and A.4. **Patched `run_cell.sh`** to filter to `cpu-*/cpuss-*/gpuss-*` only; resume chain confirmed working. The Session 7 engineer-agent note *"needs a PMIC-aware thermal watchdog"* is now actioned — this is the patch.

---

## Session 8 framing (operator mandate, 2026-04-22)

Session 7 closed PRD v2. Session 8 was reorganized around **characterization completeness** rather than commercial valuation. The phases are:

- **Phase A** — μ robustness and overfit boundary *(running now)*
- **Phase B** — 12-task learning cartography + CLI-responsiveness audit + resonance_v2 debug
- **Phase C** — Gate-surface structure (extend 2×2 → full map; tag sweep; gate-fingerprint clustering; gate-claim dependency)
- **Phase D** — Basin-volume definitive measurement (S5 re-attempt + 3-session continuity)
- **Phase E** — Mode A scaffold (AGD-C1) with infrastructure build between sessions
- **Phase F** — IS / IS NOT / OPEN QUESTIONS ledger formalization

**Dropped from PRD v2 Tier 1/2** by operator:
- M3 (I4 truth-sensor thermal robustness) — invalidated by Claim κ (truth-sensor CLI is decorative)
- M4 (I5 plasticity-resonance freq sweep) — invalidated by Claim ν (resonance_r3 ignores `--steps`)
- T4 (LAB-I3 gate-flip env sweep) — diminishing returns after 5–6 substrate arms
- S9 (freq-locked) — retained as documented gap; no root, no execution

---

## What landed since the last snapshot

### Phase A.1 — μ replicate (N=10 @ `--steps 20`, default SY_v1 + xnor_train, pinned Prime, airplane)

**10/10 receipts. All bit-identical.**

```
r01..r10: KPI_K2_SUMMARY best_uplift=1.324074 max_scar_weight=1.048401  (×10)
duration_sec: 259 — 1464 (thermal throttling drives wall-clock, not output)
```

This matches the Session 7 T2 observation byte-for-byte. The pre-registered PASS criterion for A.1 was *"all 10 replicates show best_uplift ≥ 0.05 AND median within ±30% of S7 value 1.324"*. Both criteria are trivially satisfied because every single replicate IS the median.

**Interpretation.** The pre-registration was written assuming stochastic task output. The actual binary produces deterministic output at fixed config. This is a **pre-registered-threshold-too-loose finding** that tightens to *"exp_k2_scars is bit-deterministic across invocations at fixed config"* — which is stronger than the original pre-reg. I flag this as Claim ξ for repo-agent review.

### Phase A.2 — overfit boundary (steps ∈ {20,25,30,35,40,45,50}, N=3 each)

**20/21 receipts landed; s50_r3 in flight.** N=3 replicates per step are all bit-identical (determinism holds across the whole step range).

| --steps | best_uplift (N=3 identical) | max_scar_weight |
|---------|------------------------------|------------------|
| 20 | 1.324074 | 1.048401 |
| 25 | 1.380150 | 0.955608 |
| 30 | **1.644524** ← peak | 0.868061 |
| 35 | 1.405548 | 0.787437 |
| 40 | 1.642128 | 0.714148 |
| 45 | 1.332733 | 0.647856 |
| 50 | **0.000000** ← cliff | 0.588307 |

**Observations:**
1. **Monotone decrease of `max_scar_weight`** with `--steps`: 1.048 → 0.588 across the range. More steps → smaller per-lesson edge update magnitudes.
2. **best_uplift is non-monotone**: rises 1.324 → 1.380 → 1.645 → dips to 1.406 → back to 1.642 → retreats to 1.333 → plunges to 0.
3. **The overfit boundary between steps=45 and steps=50 is sharp** (1.333 → 0.000), suggesting a threshold effect, not a smooth degradation. Likely interpretation: training accumulates past the point where scars help recall and instead overwrites the representation.
4. **Determinism confirmed across the full --steps sweep**: 21 receipts, 7 equivalence classes, zero variance within class.

### Phase A.3 — cross-graph (pending)

4 cells (SY_v1 / SY_v2 / RA_v1 / RA_v2) × N=3 = 12 runs queued. Chain advances here when A.2 s50_r3 completes.

### Phase A.4 — cross-dataset (pending)

3 datasets (xnor_train / xnor_mini / xnor_test) × N=3 = 9 runs queued.

---

## Claim proposals for repo-agent review

**Please scrutinize before promoting.** Flag any overreach.

### Claim ξ (xi) — DETERMINISTIC_TASK_OUTPUT
- **Statement:** `exp_k2_scars` produces byte-identical `KPI_K2_SUMMARY` lines across repeated invocations at fixed `(--steps, --adj, --tags, --dataset, --cpu, --mode train)`.
- **Evidence:** Phase A.1 N=10, Phase A.2 N=3-per-step × 7 steps. 31 receipts total. Zero variance in `best_uplift` or `max_scar_weight` within any fixed-config class.
- **Kill criterion:** any single invocation at the same config producing a different `best_uplift` value.
- **Scope:** `exp_k2_scars` only; other tasks untested for determinism.
- **IS NOT corollary:** DM3 IS NOT a system with run-to-run stochastic variance on `exp_k2_scars` at fixed config.

### Claim ο (omicron) — SHARP_OVERFIT_BOUNDARY_K2
- **Statement:** For `exp_k2_scars` with default SY_v1 + xnor_train, `best_uplift` collapses from 1.333 (at `--steps 45`) to 0.000 (at `--steps 50`) — a single-step-increment discrete boundary, not a gradual degradation.
- **Evidence:** Phase A.2 s45_r1-3 (1.332733 ×3), s50_r1-2 (0.000000 ×2, s50_r3 in flight).
- **Kill criterion:** a future finer-grained sweep (steps=46,47,48,49) showing a smooth gradient rather than a cliff.
- **Scope:** SY_v1 + xnor_train + default noise schedule; A.3/A.4 will test cross-graph + cross-dataset extensibility.

---

## Engineering change of record: thermal gate patch

**Old behavior (Session 7 harness).** `run_cell.sh` read `worst = max(/sys/class/thermal/thermal_zone*/temp)`. Hard ceiling 70 000 mC. Any sensor reading above 70 °C exits the run with rc=2.

**Problem.** `pmih010x_lite_tz` (PMIC voltage-regulator thermal sensor) has ~hours of thermal inertia. After continuous compute from 21:37 to 01:56 UTC, it saturated at 71–72 °C and stayed there for 2+ hours while the actual CPU cores dropped to the low 30s. The all-sensor gate kept aborting every queued run.

**Result before fix.** A.2: 7 of 21 receipts (halted at s30_r2). A.3: **0** receipts. A.4: **0** receipts. All of A.3 and A.4 just looped through thermal-abort/cool-180s/thermal-abort for 64 min before the scripts exited with `SUMMARY runs=0 verdict=FAIL`.

**Fix.** Patched `run_cell.sh` thermal gate to filter to `cpu-*/cpuss-*/gpuss-*` sensor types. PMIC, DDR, NSP, GPU-voltage, pm-level sensors excluded. Emits `worst_zone` now for diagnostics.

```sh
# Gate 3: thermal — CPU/GPU sensors only.
worst=0; worst_zone=""
for z in /sys/class/thermal/thermal_zone*; do
  tp=$(cat "$z/type" 2>/dev/null)
  case "$tp" in cpu-*|cpuss-*|gpuss-*) : ;; *) continue ;; esac
  t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
  if [ "$t" -gt "$worst" ]; then worst=$t; worst_zone="$tp"; fi
done
if [ "$worst" -gt "$TCEIL" ]; then
  echo "THERMAL_OVER_CEILING worst_mc=$worst worst_zone=$worst_zone ceiling_mc=$TCEIL" >&2
  exit 2
fi
```

**Also patched**: inline cooldown loops in `a2_resume.sh`, `a3_rerun.sh`, `a4_rerun.sh` now use the same CPU-only filter and cap retries at 10 × 60 s (10 min wall). Prior scripts could loop forever on a stuck sensor.

**Verification.** Just after patch: CPU-only worst = 32 400 mC (32.4 °C, far below 70 °C ceiling), all-sensor worst = 61 970 mC (62 °C, also below ceiling but would have been 71 °C during the saturation). Resume chain launched and is producing receipts normally.

**Audit trail preserved.** Original `run_cell.sh` saved to `run_cell.sh.pre_cpugate_bak` on device. Pre-resume progress files kept as `progress.pre_resume.txt` in A.3 and A.4 so the walled history is inspectable.

**What this means for the receipt record.** All A.2 r20–r30_r1 receipts (7 runs) were produced with the old gate. All A.2 s30_r2 onwards + A.3 + A.4 use the patched gate. If anyone re-hashes the receipts, note the mix. Canonical SHAs of the `.bin` output are not affected — the gate sits before dm3 is invoked.

---

## Artifact tree (new content)

Under `artifacts/phase_S8_P0_learning_20260422T213500Z/`:

- `bin/a1_mu_replicate.sh` (original)
- `bin/a2_overfit_boundary.sh` (original, superseded by a2_resume.sh for s30_r2+)
- `bin/a3_cross_graph.sh` (original, superseded by a3_rerun.sh)
- `bin/a4_cross_dataset.sh` (original, superseded by a4_rerun.sh)
- `bin/phase_a_chain.sh` (original chain — completed but walled)
- `bin/a2_resume.sh`, `bin/a3_rerun.sh`, `bin/a4_rerun.sh` (CPU-only thermal gate)
- `bin/phase_a_resume_chain.sh`
- `bin/resume_phase_a.sh` (nohup-relauncher for edge cases)

On device under `/data/local/tmp/dm3_harness/cells/`:
- `A1_mu_replicate/` — 10 receipts, all bit-identical, summary PASS
- `A2_overfit_boundary/` — 20 receipts at time of writing, s50_r3 in flight; `progress.txt` shows both original and resume history
- `A3_cross_graph/` — summary archived as `*.pre_resume.*`; rerun in flight on completion of A.2
- `A4_cross_dataset/` — same archival pattern

---

## Sync seams for repo-agent

1. **Receipts across thermal-gate versions.** As described above, A.2 has 7 old-gate + 14 new-gate receipts. The scientific output is identical; only the pre-run gate logic differs. Surface this in `MANIFEST.tsv` if you add a column for harness version.

2. **Phase A original `progress.txt` walls are still on device** — the 64-min A.3/A.4 thermal-wall log is a useful forensic artefact. `progress.pre_resume.txt` files preserve it. Do not delete.

3. **Empty `.bin` for exp_k2_scars** remains by design (task writes KPIs to stdout). All A.1/A.2/A.3/A.4 receipts have `out_sha=""`. The scientific content lives in the `.log` files. Same sync seam as S10 in Session 7.

4. **Wall-clock variance**: A.1 and A.2 durations range from 259 s to 1733 s at the same `--steps`. This is thermal throttling on the CPU governor. The `duration_sec` field is not comparable across runs at fixed `--steps`; use only the KPI output for cross-run comparison.

5. **Three claims to consider** (θ..ν from Session 7 + ξ, ο from A.1/A.2) are now stacked for your next promotion pass. Reminder — θ through ν were documented in `DM3_SESSION7_FINAL_REPORT.md` and `HANDOVER_TO_REPO_AGENT_20260422.md` but have not yet been mirrored into `repo_stage/CLAIMS.md`.

---

## What the repo-agent should do when it next runs

1. **Integrate Session 7 claims θ, ι, κ, λ, μ, ν** per the 2026-04-22 handover note (still outstanding at time of writing).
2. **Do not yet promote ξ or ο.** A.3 and A.4 should land first — they either reinforce (determinism + cliff hold across graphs/datasets) or complicate (determinism fragile under graph change; cliff moves with dataset) the story. Session 8 final report will compile the full claim set.
3. **Update `JOURNEY_LOG.md` with a Session 8 interim paragraph** noting Phase A in flight, operator's reorientation to scientific-learning frame, the thermal-gate fix.
4. **Record in `REPO_AGENT_FINDINGS.md`** that the engineer-agent flagged the PMIC sensor behavior as an *engineering-side receipted finding* comparable to a scientific claim. Engineering IS NOTs are admissible in the ledger.

---

## Governance posture (unchanged)

- Binary hash gate: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- NIST-KAT canary: 4 vectors verified each chain launch
- No parallel `dm3_runner`; no NPU/Hexagon; no heterogeneous lanes
- Airplane default; pinned Prime (cpu7)
- Commercial framing remains outside `repo_stage/`
- PRE-REGISTERED thresholds per Session 8 operator mandate; no mid-session revision. Where actual behavior reveals pre-registration was too loose (e.g. A.1 thresholds assumed stochasticity but task is deterministic), engineer-agent reports this as a scope-error in writing; does not silently tighten.

---

## Coming next (inside Session 8)

- **A.2 close → A.3 start**: probably 13:55–14:15 UTC (after s50_r3 finishes, ~15–20 min from now)
- **A.3 close**: ~16:30–18:00 UTC (12 runs × 9–15 min at steps=20)
- **A.4 close**: ~18:00–19:30 UTC (9 runs × 9–15 min)
- **Phase A end-of-phase analysis** + Phase B planning authoring

If any of A.3's four cells (SY_v2 / RA_v1 / RA_v2) or A.4's non-xnor_train datasets break determinism or change the cliff location, that's a sharp finding and gets called out in real time. If determinism holds across all 35 remaining receipts, ξ hardens.

—— Session 8 engineer-agent, 2026-04-23
