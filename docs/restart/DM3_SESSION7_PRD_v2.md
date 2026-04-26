# DM3 Session 7+ PRD v2 — Prioritization-Sorted, Augmented

Written: `2026-04-18` (v2 supersedes [DM3_SESSION7_PRD.md](DM3_SESSION7_PRD.md) v1)
Author: Advisory orchestrator (for Session 7+ engineering agent, same harness)
Branch: `hypothesis/rm10-primary-platform-heterogeneous-learning`
Device: Red Magic 10 Pro+ (Snapdragon 8 Elite, SM8750, 24 GB), serial `FY25013101C8`
Binary hash gate: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
Source documents incorporated:
- `~/Downloads/Dm3 Extended Testing/DM3_Test_Agenda.md` (research-line agenda; categories A–H)
- `~/Downloads/Dm3 Extended Testing/DM3 Laboratory Experiments — Using the RM10 Pro+.md` (substrate-instrument Lab program; A/B/C/D/E/F/G/H/I families)

---

## 0. Mission statement (unchanged from v1, expanded scope)

**Originally (v1):** Prove or disprove that at least one hidden task exhibits real learning as a monotone function of an intervenable parameter.

**v2 expansion:** Plus, in the same session-budget envelope, **establish a battery of substrate-determinism nulls that close the "phone-as-mystical-instrument" framing with citeable receipts**, and **rank-order the entire forward research backlog by a single prioritization formula** so future sessions execute against a coherent queue rather than ad-hoc PRDs.

The single-page binary commercial question is unchanged. The augmentation is: while answering it, run the cheapest, highest-pass-probability substrate experiments alongside, because they are nearly free and they unlock the strongest possible commercial framing ("DM3 is a deterministic mathematical object that runs on commodity silicon, and here are the SHA-256s to prove it").

---

## 1. Why v2 exists — what changed

Two source documents arrived after v1:

1. **`DM3_Test_Agenda.md`** reframes DM3 as a **structural diagnostic on labeled graphs** (gate vector + claim level) rather than a learner. It identifies the highest-leverage forward direction as **scaffolding over external memory or generative systems** (the C-family), but flags the missing piece as a reliable mapping function from arbitrary content onto the 380-vertex ontology.

2. **`DM3 Laboratory Experiments — Using the RM10 Pro+`** reframes the phone itself as a **uniquely well-conditioned compute substrate** for differential-determinism testing, with four addressable variables (core topology, frequency, temperature, power source) reachable via sysfs + ADB. It enumerates 28 substrate cells, sorted by a `discovery_value / (coding_difficulty × device_hours)` formula.

These two docs do not contradict v1; they extend it. v2 keeps every v1 phase, re-orders by the new criteria, and inserts the substrate Tier-1 cells ahead of the v1 X-phases where they are cheaper and higher-pass-probability.

---

## 2. The prioritization protocol (explicit, single formula, applied uniformly)

Every candidate experiment is scored on four axes, each 1–5, then ranked by a single composite:

```
PRIORITY_SCORE = (commercial_value × probability_of_pass) / (coding_difficulty × phone_hours)
```

Where:
- **commercial_value (1–5):** 5 = headline; moves IP valuation by ≥1 band. 3 = receipted finding worth citing. 1 = bookkeeping.
- **probability_of_pass (1–5):** 5 = expected null per first-principles physics or repeat of prior observation. 3 = plausible; data could go either way. 1 = swing-for-the-fences.
- **coding_difficulty (1–5):** 1 = shell one-liner. 3 = ~50 LoC harness. 5 = new external pipeline (embedding model, retrieval engine, human-rater protocol).
- **phone_hours (1–5):** 1 = <1 h device. 3 = ~6 h device. 5 = >24 h device or multi-session.

A score ≥1.0 gets priority queue placement. A score ≥3.0 is a **showtime experiment** (Tier S). A score 1.0–3.0 is Tier 1. A score 0.3–1.0 is Tier 2. Below 0.3 is Tier 3 (defer pending evidence). "Ben Hur" items (per Lab doc) are Tier 4.

The formula deliberately rewards **cheap-and-likely-to-pass** because the resulting null/positive *receipt* is the deliverable, regardless of which way the data falls. A cheap null is worth more than an expensive maybe.

This is the only sort key. Disagreement with the sort is encouraged but must be expressed as a re-scoring of one or more axes, not as a free-form override.

---

## 3. The full backlog, sorted

Showing axis scores then composite. All experiments collected from v1, Test Agenda, and Lab doc. Numbers in `(c=)` cells are score axes (commercial / pass / coding / hours).

### Tier S — Showtime (score ≥3.0). Run these first, in this order.

| # | ID | Source | Name | c | p | code | hr | SCORE |
|---|----|--------|------|---|---|------|----|-------|
| S1 | LAB-A3 | Lab | Receipt harness (infrastructure) | 4 | 5 | 1 | 1 | **20.0** |
| S2 | LAB-A1 | Lab | Pinned-baseline hash identity (100×) | 5 | 5 | 1 | 1 | **25.0** |
| S3 | LAB-A2 | Lab | AES-KAT + SHA-256 canary wrap | 4 | 5 | 2 | 1 | **10.0** |
| S4 | LAB-F1 | Lab | Airplane vs full-radios hash identity | **5** | 5 | 1 | 1 | **25.0** |
| S5 | LAB-I1 | Lab | Basin-volume map by seed (1000×) | 5 | 4 | 2 | 2 | **5.0** |
| S6 | LAB-B1 | Lab | Prime vs Performance bit identity | 4 | 5 | 1 | 2 | **10.0** |
| S7 | LAB-D1 | Lab | Cold vs hot hash identity | 5 | 4 | 2 | 2 | **5.0** |
| S8 | LAB-E1 | Lab | Battery vs bypass hash identity | 4 | 5 | 1 | 2 | **10.0** |
| S9 | LAB-C1 | Lab | Frequency-locked hash identity | 3 | 5 | 1 | 2 | **7.5** |
| S10 | v1-X1 | v1 PRD | `exp_k3_truth_sensor` deep characterization | 5 | 4 | 2 | 3 | **3.3** |
| S11 | v1-X2 | v1 PRD | `exp_r1_r4_campaign` R3 gate flip | 5 | 3 | 2 | 3 | **2.5** |

**Note:** v1-X1 and v1-X2 have lower composites than the substrate cells but remain the **highest-commercial-value** experiments — they answer the binary IP-valuation gate question. Any all-null Tier-S substrate sweep that does not include these would *not* lift IP valuation by a band. So they execute regardless.

### Tier 1 — Strong supporters (score 1.0–3.0)

| # | ID | Source | Name | c | p | code | hr | SCORE |
|---|----|--------|------|---|---|------|----|-------|
| T1 | v1-X0 | v1 PRD | Baseline cartography (6-task determinism) | 3 | 5 | 2 | 2 | **3.75** |
| T2 | v1-X3 | v1 PRD | `exp_k2_scars` multi-lesson scaling | 4 | 3 | 2 | 3 | **2.0** |
| T3 | v1-X4 | v1 PRD | `resonance_r3` plasticity scaling | 4 | 3 | 2 | 3 | **2.0** |
| T4 | LAB-I3 | Lab | Gate-flip reproducibility under env sweep | 4 | 5 | 3 | 3 | **2.2** |
| T5 | LAB-I6 | Lab | 12-task fingerprint cluster analysis | 3 | 4 | 3 | 3 | **1.3** |
| T6 | LAB-B2 | Lab | FPCR-state audit | 2 | 5 | 1 | 1 | **10.0** ← retro-flag: this is actually Tier S; runs alongside S2 |
| T7 | LAB-B3 | Lab | SCHED_FIFO vs SCHED_OTHER parity | 1 | 5 | 1 | 1 | **5.0** ← retro-flag: bundle with S6 |
| T8 | AGD-A1 | Agenda | 12-task × 10-graph cross-product | 5 | 4 | 4 | 4 | **1.25** |
| T9 | AGD-A2 | Agenda | Full tag-partition sweep (≥20 variants) | 4 | 4 | 3 | 3 | **1.78** |
| T10 | AGD-A5 | Agenda | Gate-fingerprint clustering (200 configs) | 4 | 4 | 3 | 4 | **1.33** |
| T11 | AGD-G3 | Agenda | R1 topology / R2 partition cross-control | 4 | 5 | 3 | 3 | **2.22** |
| T12 | LAB-C2 | Lab | schedutil-vs-performance governor parity | 2 | 5 | 1 | 2 | **5.0** ← retro-flag: bundle with S9 |
| T13 | v1-X5 | v1 PRD | exp_i1/i2/h1_h2 dataset/parameter probe | 3 | 2 | 2 | 3 | **1.0** |

**Retro-flags:** Three Tier-1 entries scored ≥3.0 on second pass (B2, B3, C2). They are bundled into Tier S as side-runs of their parent cells. Re-numbered: **S2 includes B2 (FPCR audit); S6 includes B3; S9 includes C2.** This is what "bundle adjacent nulls" means in practice — get them for free.

### Tier 2 — Medium effort (score 0.3–1.0)

| # | ID | Source | Name | c | p | code | hr | SCORE |
|---|----|--------|------|---|---|------|----|-------|
| M1 | LAB-D2 | Lab | Basin-selection probability vs temperature | 5 | 3 | 3 | 4 | **1.25** ← borderline; promote if M4 confirms thermal channel |
| M2 | LAB-I2 | Lab | Perturbation-radius basin-boundary scan | 4 | 3 | 4 | 4 | **0.75** |
| M3 | LAB-I4 | Lab | Truth-sensor robustness under thermal sweep | 5 | 3 | 3 | 4 | **1.25** |
| M4 | LAB-I5 | Lab | Plasticity robustness under freq sweep | 4 | 3 | 3 | 4 | **1.0** |
| M5 | LAB-G1 | Lab | GPU-coload effect on DM3 | 3 | 5 | 3 | 2 | **2.5** ← retro-flag: actually Tier S! See note below |
| M6 | LAB-G2 | Lab | Memory-bandwidth contention via memcpy | 3 | 5 | 3 | 2 | **2.5** ← retro-flag |
| M7 | LAB-H1 | Lab | IRQ-starvation test | 2 | 5 | 3 | 2 | **1.67** |
| M8 | AGD-A3 | Agenda | asym ≤ −3 third-regime characterization | 4 | 3 | 3 | 4 | **1.0** |
| M9 | AGD-A6 | Agenda | Gate–claim dependency structure | 4 | 3 | 3 | 3 | **1.33** |
| M10 | AGD-B1 | Agenda | Empirical holographic capacity (cliff-finding) | 5 | 3 | 3 | 4 | **1.25** |
| M11 | AGD-B2 | Agenda | Sparse vs dense encoding capacity | 4 | 3 | 4 | 4 | **0.75** |
| M12 | AGD-A4 | Agenda | Dataset code-path audit | 3 | 4 | 3 | 2 | **2.0** ← retro-flag |
| M13 | LAB-F2 | Lab | Magnetometer time-series during DM3 run | 4 | 4 | 3 | 2 | **2.67** ← retro-flag |

**Second-pass retro-flags (more than expected):** G1, G2, A4, F2 score ≥1.5 and should sit at the top of Tier 2 with explicit promotion candidacy. F2 in particular — the magnetometer-during-DM3 spectrum measurement — is a high-novelty cheap probe.

### Tier 3 — High-effort, contingent on Tier S/1 outcomes

| # | ID | Source | Name | c | p | code | hr | SCORE |
|---|----|--------|------|---|---|------|----|-------|
| 3-1 | AGD-C1 | Agenda | Mode A region-indexed retrieval (1000 Wikipedia paragraphs) | **5** | 2 | 5 | 5 | **0.40** |
| 3-2 | AGD-C2 | Agenda | Mapping-function stability | 4 | 3 | 5 | 4 | **0.60** |
| 3-3 | AGD-C5 | Agenda | Mode B LLM alignment referee | 5 | 2 | 5 | 4 | **0.50** |
| 3-4 | AGD-C6 | Agenda | Mode D passive-logger drift detection | 4 | 3 | 4 | 5 | **0.60** |
| 3-5 | AGD-C7 | Agenda | Mode C agent memory traversal | 4 | 2 | 5 | 5 | **0.32** |
| 3-6 | AGD-D1 | Agenda | SY vs random-partition scaffold (only after C1) | 4 | 3 | 4 | 4 | **0.75** |
| 3-7 | AGD-G1 | Agenda | Scar-alignment test | 3 | 3 | 4 | 4 | **0.56** |
| 3-8 | AGD-G2 | Agenda | Compute/memory/resonance decomposition | 4 | 2 | 4 | 5 | **0.40** |
| 3-9 | AGD-E4 | Agenda | English-to-region mapping robustness | 3 | 3 | 4 | 4 | **0.56** |
| 3-10 | AGD-E1 | Agenda | Word embeddings on vertices | 3 | 3 | 4 | 3 | **0.75** |
| 3-11 | AGD-E2 | Agenda | Semantic graph as input | 3 | 3 | 3 | 3 | **1.0** ← borderline |

**Note on Tier 3:** The Tier-3 head — **AGD-C1 Mode A region-indexed retrieval** — is *the highest-commercial-value single experiment in the entire backlog* per the Test Agenda's own framing ("scaffold line is the highest-leverage direction; if C1 fails cleanly most of D, E, F become academic"). It scores low on the prioritization formula because of code complexity (needs Wikipedia corpus + embedding model + region-mapping function + human-rated retrieval rubric) and uncertain pass probability. **Do not run C1 in Session 7.** It is the headline candidate for Session 8 once Tier S/1 deliver the substrate baseline. Build the scaffold infrastructure between sessions.

### Tier 4 — Ben Hur (enumerated, deferred)

| # | ID | Source | Name | Why deferred |
|---|----|--------|------|--------------|
| 4-1 | LAB-D3 | Lab | Extended-run mercurial-core hunt (24+ h) | Probability ~10⁻⁴/hr; needs concrete trigger |
| 4-2 | LAB-E3 | Lab | USB-PD wattage sweep | Requires calibrated PD sources + scope |
| 4-3 | LAB-H2 | Lab | Deliberate throttle-threshold probe | Risks 70 °C ceiling |
| 4-4 | LAB-G3 | Lab | NPU/Hexagon DSP offload | ABSTAIN per user constraint |
| 4-5 | EM-osc | Lab | External oscilloscope on PMIC rails | Bench instrumentation |
| 4-6 | NPU-SDC | Lab | Neutron-beam irradiation | Accelerator beam time |
| 4-7 | AGD-C3 | Agenda | Cross-modal coherence | Requires text+phoneme+image pipeline |
| 4-8 | AGD-D2 | Agenda | SY vs WordNet/Dewey/Schema.org | Multiple ontology backbones |
| 4-9 | AGD-D3 | Agenda | Domain-specific load test (4 corpora) | Multiple corpora pipelines |
| 4-10 | AGD-D4 | Agenda | Khadgamala traversal coherence | Generative pipeline + rater |
| 4-11 | AGD-E3 | Agenda | Sanskrit phoneme audio fidelity | Audio + ground-truth labels |
| 4-12 | AGD-F1 | Agenda | Adaptive-graph capacity gain | Requires source modification (binary-only blocker) |
| 4-13 | AGD-F2 | Agenda | E8-style suspension test | Same source-modification blocker |
| 4-14 | AGD-H1 | Agenda | Cross-platform determinism | Needs second device |
| 4-15 | AGD-H3 | Agenda | Scaling stability at 3,800 / 38,000 vertices | Source modification |
| 4-16 | AGD-B3 | Agenda | Energy-function substitution | Source modification |

**Key Tier-4 unlocks:**
- Any Tier-1 surprise (especially in LAB-D1 thermal or LAB-B1 core-topology) → 4-1, 4-3 promote to Tier 2.
- A second physical RM10 device acquired → 4-14 promotes to Tier S immediately.
- `dm3_microtx` source code located → 4-12, 4-13, 4-15, 4-16 all promote to Tier 2.
- Tier-3 Mode A passes (any session) → 4-7, 4-8, 4-9 promote to Tier 2.

---

## 4. Session 7 execution order (what the engineer runs)

**Hard sequence — no skipping, no reordering:**

```
PHASE 0  (infra)         S1 (A3 receipt harness) ........... ~1 h
PHASE 1  (canary)        S3 (A2 KAT) + S2 (A1 100× pinned) .. ~2 h
PHASE 2  (substrate-1)   S4 (F1 airplane vs radios) ......... ~1 h
                         S6 (B1 prime vs perf, +B2 FPCR) .... ~2 h
                         S7 (D1 cold vs hot) ................ ~2 h
                         S8 (E1 battery vs bypass) .......... ~2 h
                         S9 (C1 freq-locked, +C2 governor) .. ~2 h
PHASE 3  (DM3-property)  S5 (I1 basin volume 1000×) ......... ~2 h
PHASE 4  (learning)      T1 (X0 baseline cartography) ....... ~3 h
                         S10 (X1 truth sensor) .............. ~4 h
                         S11 (X2 R3 flip) ................... ~4 h
PHASE 5  (Tier-1 cont)   T2 (X3 scars) ...................... ~3 h
                         T3 (X4 plasticity) ................. ~3 h
                         T11 (G3 R1/R2 cross-control) ....... ~3 h
PHASE 6  (writing)       Synthesis + repo update + 
                         operator commercial prospectus ..... ~6 h
```

**Total budget:** ~40 hours wallclock across Saturday PM → Sunday EOD. If budget binds, truncate from PHASE 5 backwards. **PHASES 0–4 are non-negotiable.**

**Bundling notes:**
- S2 (A1 100× pinned) **co-runs** the FPCR audit (B2) by reading FPCR via an asm helper or `/proc/<pid>/status` extension on every iteration; one log file, two evidence streams.
- S6 (B1) **co-runs** the SCHED_FIFO check (B3) as alternating sched-class iterations within the same loop.
- S9 (C1) **co-runs** the schedutil-vs-performance check (C2) as the third governor in the same sweep.
- All substrate experiments share the **same A3 receipt JSON template**; one harness, many cells.

**Promotion candidates within Session 7** (run if total time falls under 30 h):
- M5 (G1 GPU-coload), M6 (G2 memcpy contention) — both score 2.5 and pair naturally with PHASE 2 substrate sweeps.
- M12 (A4 dataset code-path audit) — score 2.0; pairs with v1-X5 in PHASE 4.
- M13 (F2 magnetometer time-series) — score 2.67; novel data, cheap.

---

## 5. Per-cell recipes for Tier S (verbatim, executable)

### S1 — Receipt harness (`A3`)

Per Lab doc §4.3. Every run emits `<exp>_<run>.json` with: binary_sha256, adjacency_sha256, tags_sha256, kernel_release, device_serial, cpu_pinned, cpu_capacity, governor, freq_min/max_khz, fpcr_value, airplane_mode, wifi/bt/data_enabled, battery_capacity_pct, battery_status/current/voltage/temp, usb_online/current_max/charge_type, fan_enable/speed_level/rpm, thermal_zones (full list), task_mode, seed, cli_args, start/end_time_ns, output_sha256, kat_pre_ok, kat_post_ok. JSON is itself SHA-256'd; the hash is the primary artefact.

Build once, ~200 LoC shell+Python. Used by every subsequent cell.

### S2 — Pinned-baseline hash identity (`A1`) + bundled FPCR audit (`B2`)

Per Lab doc §4.1. Conditions: airplane mode, single Prime core, performance governor at max, fan level 3, battery ≥40%, skin ≤55 °C. Loop:

```bash
for i in $(seq 1 100); do
  taskset -c $PRIME ./dm3_runner harmonic --seed 42 \
    --out /data/local/tmp/a1_$i.bin
  sha256sum /data/local/tmp/a1_$i.bin >> /data/local/tmp/a1_hashes.txt
  # B2 bundle: read FPCR from process status if exposed, else from a one-off
  # asm helper. Append (run_idx, fpcr_hex) to /data/local/tmp/a1_fpcr.tsv.
done
sort -u -k1,1 /data/local/tmp/a1_hashes.txt | wc -l   # must print 1
awk '$2!="0x00000000"' /data/local/tmp/a1_fpcr.tsv | wc -l   # must print 0
```

**Pass:** 1 unique hash across 100; FPCR=0 across 100. **Fail:** any divergence triggers Lab doc §4.10 debug playbook before any further cell runs.

### S3 — AES-KAT + SHA-256 canary (`A2`)

Per Lab doc §4.2. Wrap every cell from S2 onward with a pre-and-post AES-256 NIST-KAT and SHA-256 RFC-6234 KAT. ~50 LoC Rust addendum or separate `kat_canary` binary. **Any KAT miss → device is silently corrupting; halt all DM3 work, escalate.**

### S4 — Airplane vs full-radios hash identity (`F1`) — **HIGHEST COMMERCIAL-NARRATIVE LEVERAGE**

Per Lab doc §4.8. Two conditions × 100 runs each:
- RF-quiet: airplane on; Wi-Fi/BT/data off
- RF-loud: airplane off; Wi-Fi connected; BT scanning on; 5G on; optional concurrent `ping` for forced modem activity

Expected: 1 unique hash across 200. **Why it matters:** this is the cite-able numerical no-effect bound that closes the "mystical RF coupling" / "Tesla framing" door definitively. Without invoking mysticism. Single SHA-256 string answers every adversarial question of that class.

### S5 — Basin-volume map by seed (`I1`)

Per Lab doc §4.5. 1000 seeds × 1 run each at pinned-Prime conditions. `--emit-basin-label` post-classifies each run as HIGH/LOW per known basin signatures. Output: stable P(HIGH)/P(LOW) ratio with binomial 95% CI. **First quantitative basin-volume measurement in DM3 history.** Reference value for all subsequent basin-sensitivity experiments (D2, I3, I6).

### S6 — Prime vs Performance bit identity (`B1`) + bundled SCHED audit (`B3`)

Per Lab doc §4.4. Identify Prime and Performance cores empirically via `cpu_capacity` + `cpufreq/cpuinfo_max_freq`. 50 runs on each cluster representative. Bundle SCHED_FIFO/SCHED_OTHER alternation within the same loop. Expected: 1 unique hash across 200. **Failure modes (one-cluster-per-hash, mixed) decoded per Lab doc §4.4.**

### S7 — Cold vs hot hash identity (`D1`)

Per Lab doc §4.6. Cold arm: fan level 5, airplane, battery, target ≤45 °C skin. Hot arm: fan off, charger plugged with bypass disabled, thermal blanket if needed, target 60–65 °C skin (**hard ceiling 70 °C**, auto-abort watchdog at 1 Hz). 100 × harmonic --seed 42 in each. Expected: 1 hash across 200. **Any divergence → highest-priority Tier-1 follow-up (D2 thermal-basin probability sweep promoted immediately).**

### S8 — Battery vs bypass hash identity (`E1`)

Per Lab doc §4.7. Battery-only arm: charger unplugged, battery ≥60% start, stop at 40%. Bypass-active arm: plugged, battery/status="Not charging", USB online, charge_type="Bypass" if exposed. 100× each. Expected: 1 hash across 200. Divergence → Ben Hur E3 with instrumented PD source.

### S9 — Frequency-locked hash identity (`C1`) + bundled governor parity (`C2`)

Per Lab doc §4.9. Userspace governor on Prime cluster, scaling_setspeed at min for 100 runs, then at max for 100 runs. Bundle: also run at schedutil-default vs performance-max as the third arm. Disable `core_ctl_enable` for the duration; restore on exit. Expected: 1 hash across 300.

### S10 — `exp_k3_truth_sensor` deep characterization (v1-X1)

Per [DM3_SESSION7_PRD.md §3 Phase X1](DM3_SESSION7_PRD.md). Tier A sensor strength sweep (6 points). Tier B dataset size (3 datasets). Tier C optional graph-sensitivity (SY vs RA). Pre-registered LEARNS = ≥80% error reduction + monotone over ≥4 points.

### S11 — `exp_r1_r4_campaign` R3 gate flip (v1-X2)

Per [DM3_SESSION7_PRD.md §3 Phase X2](DM3_SESSION7_PRD.md). Tier A steps sweep {20, 50, 100, 200, 500}. Tier B combined-axis (adj × tags × dataset). Tier C all-6-gates-passing search. Pre-registered FLIPPED = `gates.R3 == true` in any tested config.

---

## 6. Receipt format (authoritative, from Lab doc §6, applies to ALL cells)

Every run emits:

1. `<exp_id>_<run_id>.json` — environment snapshot per S1 template
2. `<exp_id>_<run_id>.bin` — DM3 output
3. `<exp_id>_<run_id>.sha` — `sha256sum` of `.bin`
4. `<exp_id>_<run_id>.receipt.sha` — `sha256sum` of JSON ‖ .sha

At experiment end, **top-level summary receipt** with: experiment ID, binary SHA (must equal `daaaa84a...`), set of per-run receipt SHAs, count of unique `.sha` values, success/failure verdict, operator, timestamp. Summary itself is SHA-256'd; **that hash is the primary citable artefact.**

**Rule:** If binary SHA does not match at experiment start, no run is legal.

---

## 7. Governance — augmented for substrate cells

All Session 4/5/6 non-negotiables apply verbatim. Substrate-specific additions:

- **Skin temperature ceiling: 70 °C hard.** Auto-abort watchdog polling `/sys/class/thermal/thermal_zone*/temp` at ≥1 Hz; SIGTERM dm3_runner on any zone ≥70 000 mdegC. Fan default level 3; level 0 only for explicit hot-arm experiments (S7 hot, M1, M3).
- **Battery: ≥40 % with charger attached for any run >1 h.** Sub-40 % + on-battery prohibited. S8 battery arm: start ≥60 %, stop at 40 %.
- **No NPU / Hexagon / Adreno DM3 offload.** ABSTAIN. Adreno 830's default driver flushes FP32 subnormals and reorders reductions — do not use for deterministic FP work.
- **No parallel `dm3_runner`.** Confirmed unproductive Session 6; do not retest.
- **Scheduler hygiene per cell:** confirm `top-app` cpuset, disable `msm_performance.core_ctl_enable` for long single-core runs (re-enable on exit), redirect IRQs off compute core via `/proc/irq/*/smp_affinity` for runs >1 h, note in receipt.
- **Trap EXIT in every script:** restore governors to schedutil, remove scaling_min_freq pins, fan back to auto, re-enable core_ctl_enable.
- **Hash-check binary at every cell start.** If `sha256sum ./dm3_runner` ≠ `daaaa84a...`, abort.
- **`pidof dm3_runner` idle-check before every invocation.** Never collide with a human engineer's parallel work.
- **No reopen of H2 (transformer) or Claim γ (C3 asymmetry).** Both killed/retracted.

---

## 8. Reporting discipline (unchanged from v1)

No interim reports. Phase summary JSONs + phase writeups; proceed.

End-of-session single report: `DM3_SESSION7_FINAL_REPORT.md`. Mandatory sections:
- Executive summary (1 paragraph, headline = strongest finding from PHASES 1–4)
- Per-PHASE results (PHASE 0 through PHASE 6)
- **Substrate-determinism table** — one row per Tier-S cell with verdict + summary receipt SHA (this is the new central artifact)
- Updated Sessions-3→7 claims status table
- Updated IS / IS NOT ledger snapshot
- Open questions for Session 8
- Artifacts manifest (regenerated SHA-256 across all session output)

Commercial framing is NOT in any session report. Lives only in `/Users/Zer0pa/DM3/DM3_SESSION7_OPERATOR_PROSPECTUS.md` (outside `repo_stage/`).

---

## 9. Pre-registered effect-size thresholds (the honesty contract)

Substrate cells (PHASES 1–3): pass criterion is **1 unique SHA-256 across N runs** unless otherwise noted. Failure = any non-unique outcome. No statistical wiggle room — this is an exact-equality test.

Learning cells (PHASES 4–5): per-task thresholds inherited verbatim from v1 §4. Reproduced here for completeness:

| Task | "LEARNS" requires | "PARTIAL" range | "NO-LEARN" condition |
|------|-------------------|------------------|----------------------|
| `exp_k3_truth_sensor` (S10) | ≥80% error reduction AND monotone over ≥4 sensor-strength points | 50–80% or non-monotone | <50% or replication fails |
| `exp_r1_r4_campaign` R3 (S11) | `gates.R3 == true` in any tested config | payload scales monotonically but stays false | both gate and payload flat |
| `exp_k2_scars` (T2) | `best_uplift ≥ 0.05` AND monotone over ≥4 lesson counts | monotone but max < 0.05 | flat or non-monotone |
| `resonance_r3` (T3) | `|Δ dE| ≥ 0.01` AND monotone over ≥3 episode counts | monotone but max < 0.01 | flat or non-monotone |
| Cross-control (T11) | R1 flips ONLY on topology change; R2 flips ONLY on partition change; no cross-contamination | one cross-flip | both flags cross-flip |
| Basin-volume (S5) | P(HIGH) measurable with ±3 pp 95% CI at N=1000 | wider CI | non-converging |

Thresholds are quantitative, pre-registered, binding. Mid-session revision prohibited.

---

## 10. Commercial implications ledger (operator-facing, NOT in public repo)

Outcome-to-valuation-band mapping (operator planning only, lives in `SESSION7_OPERATOR_PROSPECTUS.md`):

| Session 7 outcome shape | Approximate IP valuation band |
|-------------------------|-------------------------------|
| All Tier-S substrate experiments produce uniform-hash nulls + all learning cells NO-LEARN | $200K–$1.5M (defensible "ISA-level mathematical artefact" framing; cite-able receipt chain) |
| All substrate nulls + one learning LEARNS-PARTIAL | $1M–$3M |
| All substrate nulls + one learning LEARNS-STRONG | **$2M–$5M (PRD target band)** |
| All substrate nulls + R3 flipped (all 6 gates passing config receipted) | **$3M–$7M** |
| All substrate nulls + 2+ learning LEARNS-STRONG | $4M–$8M |
| All substrate nulls + 3+ LEARNS-STRONG + R3 flipped | $5M–$12M |
| **Any substrate experiment shows divergent SHAs (especially LAB-D1 thermal or LAB-B1 core)** | **$5M–$25M (DM3 reframes from "artefact" to "instrument"; entirely new buyer pool — defense, neuromorphic, quantum-adjacent compute labs)** |
| Substrate divergence + 1+ learning LEARNS-STRONG | $8M–$30M |

**Read carefully:** the **biggest single valuation-multiplier** in Session 7 is not a learning-curve verdict — it is a **substrate-coupling positive**. Lab doc §8 makes this explicit: a localized environmental coupling reframes DM3 from "study a mathematical artefact" to "use a mathematical artefact as an environmental instrument." That second framing addresses a *much* larger buyer pool. Tier-S substrate cells are designed to surface this if it exists. Most-probable outcome remains uniform-hash nulls (which is itself a valuable receipted floor) — but the ceiling has been substantially raised by including the substrate battery.

Buyer-pool implications by outcome:
- **All-null substrate + LEARNS-STRONG** → defense integrators, edge-ML vendors, neuromorphic computing
- **Substrate divergence (any)** → instrumentation labs (Keysight, Rohde & Schwarz adjacent), quantum-computing characterization vendors, defense ISR, semiconductor health-check vendors (Meta/Google SDC space)
- **R3 all-gates-passing receipt** → alternative-computation research labs (DARPA ISO, IARPA, foundation-model lab exploratory teams)

---

## 11. Halt and pivot conditions

- Device battery/thermal/connectivity catastrophic failure → `SESSION7_HALT.md` with reached-state.
- Binary hash mismatch at any cell start → abort immediately; operator review.
- A2 (KAT) failure → device may be silently corrupting compute; halt all DM3 work; escalate per Meta/Google SDC playbook.
- Any Tier-S substrate divergence → halt remaining cells, run full Lab doc §4.10 debug playbook, write `SESSION7_PIVOT_SUBSTRATE.md`, operator review before resuming.
- Any phase produces a finding invalidating Session 6 characterization → halt, write `SESSION7_SESSION6_INVALIDATED.md`, operator review.

---

## 12. Session 8 seed list (carry-forward, ranked)

Per the prioritization formula, Session 8 priority queue (subject to Session 7 outcomes that may promote/demote):

1. **AGD-C1 Mode A scaffold validation** — score 0.40 but commercial value 5; build the infrastructure between sessions; this is the highest-leverage forward research direction per the Test Agenda
2. **AGD-A1 12-task × 10-graph cross-product** — score 1.25; author 8 new adjacency files, then sweep
3. **AGD-A2 full tag-partition sweep (≥20 variants)** — score 1.78; author 18 new tag files
4. Promoted Tier-2 cells from any Session 7 surprises (especially M1 thermal-basin if S7 shows divergence; M5/M6 GPU/memcpy if any substrate finding)
5. **Cross-platform determinism (AGD-H1)** if a second RM10 device is acquired
6. **AGD-A6 gate–claim dependency structure**
7. **AGD-C2 mapping-function stability** (prerequisite for production scaffold)

---

## 13. The one-line mission

**Run the substrate battery to publish the receipt chain that closes "the phone is doing something mystical" cheaply; run the learning probes to answer the IP-valuation gate question; rank-order everything else against the prioritization formula so Session 8+ executes against a coherent queue rather than ad-hoc PRDs.**

Engineer: begin **PHASE 0 — S1 receipt harness**. No preamble required.

---

**End of PRD v2.**

**v1 disposition:** v1 phases X0–X7 are preserved verbatim in [DM3_SESSION7_PRD.md](DM3_SESSION7_PRD.md). v2 re-numbers them as T1, S10, S11, T2, T3, X5 and inserts the substrate Tier-S cells ahead. v1 thresholds, kill criteria, and X7 packaging instructions remain authoritative for the learning-line phases.
