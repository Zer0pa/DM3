# Complete Agent Handover — For Session 5 Coding Engineer

Written: `2026-04-17` at end of Session 4
Author: Session 4 autonomous execution agent
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`

---

## 1. What This Project Is

DM3 is a physics/computational research project investigating a **380-vertex graph-based dynamical system** called the "3D Double Meru." There is a precompiled Rust binary (`dm3_runner`) that runs on a Red Magic 10 Pro phone via ADB. The binary takes a graph (an adjacency matrix of 380 vertices with C3 symmetry) and runs resonance training — a dynamical process that relaxes a 72,960-dimensional state vector (380 vertices × 192 features) toward fixed-point attractors.

The system is **bistable**: it has two attractors (HIGH basin at E≈89 and LOW basin at E≈75) plus a different operating point (holography at E≈15). Which basin the system lands in per episode is stochastic — dominated by internal RNG initialization, not by external parameters.

**You are not building software.** You are running controlled experiments on a physical device, recording receipts, analyzing data, and writing scientific reports. The binary is a black box. You drive it via CLI flags and analyze JSONL receipts.

---

## 2. How We Work

### Operator Preferences

- **Autonomous long-horizon execution.** The operator gives you a PRD or mission. You execute it end-to-end. No interim reporting. No asking for approval on minor decisions. Make executive calls.
- **Report only at the end.** Produce final reports, handover docs, and review packs when done.
- **Action bias.** If you're not running an experiment, analyzing data, or writing a deliverable, you're probably doing something wrong. No "circling," no "process theater," no narrating what you're about to do without doing it.
- **Null results have equal value.** Killing a hypothesis is as good as confirming one. Write it up with the same care.

### Evidence Discipline

- **Minimum N=5 episodes** for any "confirmed" claim. No exceptions.
- **Pre-register** predictions and kill criteria BEFORE each experimental phase.
- **Every claim needs a retained packet** — the JSONL receipt file that backs it up.
- **Basin classification thresholds** (locked):
  - HIGH: E > 82 AND Coh < 0.82
  - LOW: E < 82 AND Coh > 0.82
  - OTHER: anything outside both boxes
  - RETRY (holography): E ∈ [12, 20] AND Coh ∈ [0.68, 0.78]

### What NOT To Do (Non-Negotiable)

- Do NOT reward hack (narrate mixed evidence as a win)
- Do NOT reopen H2 (transformer creates bistability — KILLED in Session 3, STRENGTHENED in Session 4)
- Do NOT try to control RNG seed (source-blocked)
- Do NOT chase the FAST session (~155s anomaly)
- Do NOT touch NPU or heterogeneous lanes (ABSTAIN)
- Do NOT promote inference mode as a live surface (it's a stub)
- Do NOT cite T01-T236 as operational predictions
- Do NOT add commercial framing — discovery only
- Do NOT use sacred-geometry names as evidence ("BINDU" = "equatorial belt," "Meru" = "the graph")
- Do NOT run `--soak N` for N > 1 (it's 20×N episodes, hours)

### Naming Discipline

- "holography-mode" not "holography" (until math identity proven)
- "task=harmonic" not "the harmonic task"
- "the 380-vertex graph" not "the Double Meru" (in analysis, source names are OK in code/paths)

---

## 3. Device Access

### Hardware

- **Device:** Red Magic 10 Pro (NX789J)
- **Serial:** `FY25013101C8`
- **Connection:** USB cable to Mac, via ADB
- **Free space:** ~699 GB on device
- **Mac free space:** ~23 GB — keep artifacts small

### Binary

- **Path:** `/data/local/tmp/dm3_runner`
- **Size:** 9,554,600 bytes
- **Hash:** `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- **ALWAYS verify hash before each phase.** If it changes, ABORT.

### Pre-Run Check (run before every phase)

```bash
adb -s FY25013101C8 shell 'pidof dm3_runner || echo "idle"'
adb -s FY25013101C8 shell 'cat /sys/class/power_supply/battery/capacity'
adb -s FY25013101C8 shell 'cat /sys/class/thermal/thermal_zone0/temp'
adb -s FY25013101C8 shell 'sha256sum /data/local/tmp/dm3_runner'
```

### Running An Experiment

```bash
adb -s FY25013101C8 shell "cd /data/local/tmp && rm -f <OUTFILE> && \
  ./dm3_runner -o <OUTFILE> --mode train --task harmonic --steps 5 --cpu <EXTRA_FLAGS>"
```

### Pulling Receipts

```bash
adb -s FY25013101C8 pull /data/local/tmp/<OUTFILE> /path/on/mac/
```

### CLI Gotchas

- **Negative args need `=` syntax:** `--asymmetry=-0.5` NOT `--asymmetry -0.5`
- **Kill runaway:** `adb -s FY25013101C8 shell 'kill -9 $(pidof dm3_runner)'`
- **ADB + while-read loops:** ADB consumes stdin. Use `</dev/null` on every `adb shell` call inside loops.
- **Detached on-device execution:** Deploy a shell script to device, run with `nohup`. Survives ADB disconnect:
  ```bash
  adb shell 'nohup /data/local/tmp/run_script.sh > /dev/null 2>&1 &'
  ```

### Typical Durations

- 1 episode: ~195s (cold) or ~60s (cache-warm after recent runs)
- 5 episodes: ~16 min (cold) or ~5 min (warm)
- Episode speed varies based on page-cache warmth, not on parameters

### Receipt Schema

Every episode produces one JSONL line with exactly 6 fields:
```json
{"asymmetry": 0.0, "coherence": 0.769, "decision": "Commit", "delta_E": 88.73, "duration_ms": 196581, "episode": 1}
```
No per-step telemetry exists. This is the ONLY output the binary produces.

---

## 4. What Sessions 3+4 Established (Solid Findings)

### The Object

A **bistable relaxation computer** on a C3-symmetric graph. State space: 380 × 192 = 72,960 floats. Evolves under `x_{t+1} = x_t + dt·(f(x_t) - x_t)` with three internal learning rules: R0 Random, R1 Oja, R2 Contrastive.

### Confirmed Facts (N≥5)

1. **Geometry is sovereign.** HAM (transformer off) and LN (transformer on) both give 20% HIGH. The transformer has ZERO measurable basin-selection effect.
2. **Asymmetry is the ONLY confirmed order parameter.** Smoothly shifts basin E values (LOW: 69→77, HIGH: 87→91 across asym=-1 to +0.3). Acts on both harmonic and holography in the same direction.
3. **Basin selection is RNG-dominated.** No parameter deterministically controls which basin is entered per episode (within tested ranges). Selection becomes deterministic only at |asym| ≥ 0.5 where bistability collapses.
4. **Holography = same dynamical family as harmonic.** Different energy scale (E≈15 vs E≈75), same asymmetry response. One dynamical family, not two.
5. **Basin values are tight and reproducible.** HIGH: E=88-89, Coh=0.77. LOW: E=75-76, Coh=0.89. Consistent across 336 episodes.
6. **Rotation has weak boundary coupling with asymmetry.** rot=60° at asym=+0.5 can push episodes across the HIGH boundary. Away from boundary: no effect.

### Killed Findings (Session 3 noise at N=2)

- freq=1.0 → 100% HIGH (actually 20% at N=5)
- rot=120° preserves bistability (actually 0/5 HIGH)
- Truth sensor suppresses HIGH (actually 40% HIGH — no effect)
- Transformer 3x HIGH bias (HAM = LN = 20%)

### Retired Parameters

- `--freq`: noise-dominated, no resonance structure
- `--angle`: non-functional, no systematic effect
- `--enable-truth-sensor`: no confirmed effect at N=5
- `--rotation`: only matters at boundary (asym≈+0.5), and only rot=60°

---

## 5. Internal Architecture (from Binary Strings Scan)

- **Feature dimension:** 192
- **Learning rules:** R0 Random → R1 Oja (Hebbian PCA) → R2 Contrastive
- **State update:** relaxation dynamic toward fixed points
- **Graph structure:** organized into sectors and rings via `OntologyInjector`
- **Energy model:** `EbmCalibration` + `XnorSampler` (EBM with XNOR binary sampling)
- **GPU compute:** wgpu with fused transformer kernel (Q,K,V in shared memory)
- **Holography:** "Boundary->Bulk" mapping confirmed in binary strings

### Hidden Tasks (untested — Session 5 priority)

Found in binary strings but never invoked:
- `InterferenceTask`
- `holographic_memory` / `run_holographic_memory`
- `K1: Pattern Ontology Capacity Experiment`
- `G2 Boundary Readout Experiment (Mode: )`
- `exp_r1_r4_campaign` with `eval_stats` / `eval_stats_mean`
- `exp_i0_classifier` with `ResonanceMetrics`

---

## 6. Reusable Tools (Session 4 Built)

### `artifacts/phase_runner.sh`

Generic phase executor. Takes a phase dir and config file. Config format: `LABEL|STEPS|FLAGS` per line. Handles ADB stdin isolation (`</dev/null`), receipt pull, battery/thermal sampling.

### `artifacts/classify_basins.py`

Basin classifier. Reads JSONL receipts from a phase directory, classifies each episode as HIGH/LOW/OTHER/RETRY, outputs `basin_summary.json`.

```bash
python3 artifacts/classify_basins.py <phase_dir> --out <phase_dir>/basin_summary.json
```

### Detached on-device execution pattern

Write a shell script to device, `chmod +x`, run with `nohup ... &`. Results stay on phone even if ADB disconnects. Pull later.

---

## 7. File Layout

```
/Users/Zer0pa/DM3/
├── AGENTS.md                          ← governance rules (READ FIRST)
├── DM3_SESSION4_REVIEW_PACK/          ← portable review package
├── restart-hypothesis-rm10-primary-platform/
│   ├── .gpd/STATE.md                  ← current research state
│   ├── artifacts/
│   │   ├── phase_H_statistical_replication_20260416T143544Z/  (70 eps)
│   │   ├── phase_I_frequency_20260416T161725Z/                (75 eps)
│   │   ├── phase_J_holography_20260416T203947Z/               (45 eps)
│   │   ├── phase_K_asymmetry_fine_20260417T013126Z/           (65 eps)
│   │   ├── phase_L_coupling_20260417T051706Z/                 (45 eps)
│   │   ├── phase_M_angle_20260417T114508Z/                    (21 eps)
│   │   ├── phase_N_telemetry_20260417T095000Z/
│   │   ├── phase_A_spectral_analysis/                         (Session 3)
│   │   ├── phase_*_summary.json
│   │   ├── classify_basins.py
│   │   └── phase_runner.sh
│   └── docs/restart/
│       ├── DM3_SESSION4_FINAL_REPORT.md
│       ├── DM3_SESSION4_PRD.md
│       ├── AGENT_HANDOVER_20260417_SESSION4.md
│       ├── NEXT_BOUNDED_ENGINEERING_MOVE.md
│       ├── BINARY_TELEMETRY_REQUEST.md
│       ├── SESSION4_EXECUTION_HOST_DECISION.md
│       └── DM3_MULTI_HYPOTHESIS_FINAL_REPORT.md  (Session 3)
```

---

## 8. Session 5 Priorities (from NEXT_BOUNDED_ENGINEERING_MOVE.md)

1. **Probe hidden task types.** Try `--task interference`, `--task holographic_memory`, etc. with `--cpu --mode train --steps 1`. See if they're callable. Budget: 1 hour.
2. **Per-step telemetry.** Blocked at binary level — needs source modification. See `BINARY_TELEMETRY_REQUEST.md`.
3. **Basin boundary exploration.** The central mystery. Can targeted initial conditions (asymmetry near +0.5, rotation=60°) reliably control basin selection? Can multi-episode runs (steps=10+) reveal intra-session convergence patterns?
4. **E-scale relationship.** Is there a continuous path from holography (E≈15) to harmonic (E≈75)?

---

## 9. How Session 4 Actually Ran (Operational Lessons)

- **Episode speeds vary 3x** based on page-cache warmth: ~60s warm, ~195s cold. First run after idle is cold; subsequent runs are warm. Plan accordingly.
- **Battery management:** The phone drains to 36% and disconnects after ~3 hrs of intensive use without charging. Always verify charging state (`dumpsys battery | grep status` — status=2 means charging).
- **ADB stdin consumption:** The #1 bug in Session 4. `adb shell` inside while-read loops eats stdin. Fix: `adb shell </dev/null '...'` on every call.
- **Detached scripts survive disconnect:** For multi-hour runs, deploy the script to device and run detached. Don't rely on Mac-side process survival.
- **Background tasks can die silently.** Check `progress.txt` or `log.txt` periodically. If stuck, check `pidof dm3_runner` on device.
