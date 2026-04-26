# DM3 Agent Handover — Session 8 Live Pickup

Written: `2026-04-23` ~13:45 UTC
For: the next engineer-agent taking over DM3 mid-Session 8
Supersedes: all prior handovers (`AGENT_HANDOVER_20260416_SESSION*`, `RM10_AGENT_HANDOVER_20260416.md`) for onboarding; those remain as history.

This doc is **self-contained**. Read it from top to bottom and you can pick up where the current engineer left off without any other file.

---

## 1. What is DM3?

DM3 is a **precompiled Rust binary** (`/data/local/tmp/dm3_runner`, 9.5 MB, SHA-256 `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`) running on a **Red Magic 10 Pro** phone (serial `FY25013101C8`) over **ADB**. It implements a **380-vertex graph-based dynamical system** with 12 tasks (harmonic/resonance/holography/scars/cross-validation/truth-sensor/gates/etc.), bistable IID Bernoulli regime, and a C3-symmetric default topology (Sri Yantra).

We do **not** modify the binary. We do **not** recompile. Our work is entirely:
1. **Characterization** via CLI flag combinations (adjacency, tags, task, mode, steps, patterns, dataset, noise).
2. **Receipt harness**: wraps every invocation with env snapshots, canonical SHAs, KPI extraction, and thermal gates.
3. **Science**: what DM3 IS and what DM3 IS NOT, both as receipted findings.

The project is a **hypothesis restart**: an earlier investigation of the same binary had ambiguous results; we restarted in January 2026 to produce a clean receipted record of what the binary actually does.

---

## 2. Grand roadmap

### Done (Sessions 1–7)

| # | Session | Date | Key artifact | What closed |
|---|---------|------|--------------|-------------|
| 1 | Platform bringup | 2026-04-14 | RM10_AGENT_HANDOVER_20260416.md | RM10 + ADB + binary staged |
| 2 | First probes | 2026-04-16 | AGENT_HANDOVER_20260416_SESSION2.md | Initial CLI surface mapped |
| 3 | Parameter chars | 2026-04-16 | DM3_SESSION3_FINAL_REPORT via Session 4 | H2 (transformer-creates-bistability) **killed**; each flag characterized |
| 4 | Hidden tasks | 2026-04-17 | DM3_SESSION4_FINAL_REPORT.md | Task surface enumerated; basin cartography started |
| 5 | Basin / γ retract | 2026-04-18 | DM3_SESSION5_FINAL_REPORT.md | γ (C3-asymmetric coupling) **retracted**; α (C3 symmetry), β (bistable IID) **solid** |
| 6 | Gate-flip W0..W4 | 2026-04-19 | DM3_SESSION6_FINAL_REPORT.md | δ, δ.1, δ.2, ε, η, ζ **promoted**; δ.3 later weakened |
| 7 | 2×2 cross-control + μ discovery | 2026-04-22 | DM3_SESSION7_FINAL_REPORT.md | θ, ι, κ, λ, **μ (first positive learning)**, ν promoted; δ.3 weakened |

**At Session 7 close** the claim ledger was: 2 SOLID (α, β), 6 CONFIRMED Session 6 (δ, δ.1, δ.2, ε, η, ζ), 6 CONFIRMED Session 7 (θ, ι, κ, λ, μ, ν), 1 WEAKENED (δ.3), 1 RETRACTED (γ). The substrate null was receipted at both gate layer (bit-level) and dynamics layer (statistical Wilson CI). The single gap was S9 (freq-locked, requires root — documented, not executable).

### In flight (Session 8)

Operator reoriented the agenda away from commercial valuation and toward **scientific-learning completeness**: both IS and IS NOT findings are first-class.

Phases A → F, executed in order:

| Phase | Scope | Status at this handover |
|-------|-------|-------------------------|
| **A** | μ robustness + overfit boundary | A.1 ✓, A.2 20/21 (s50_r3 in flight), A.3 queued, A.4 queued |
| B | 12-task learning cartography + CLI audit + resonance_v2 debug | pending (after Phase A close) |
| C | Gate-surface structure — extend 2×2 into full map + tag sweep + gate-fingerprint clustering | pending |
| D | Basin-volume definitive measurement + 3-session continuity | pending |
| E | Mode A scaffold (AGD-C1, requires offline corpus+embedding infra build) | pending |
| F | IS / IS NOT / OPEN QUESTIONS ledger formalization | pending |

**Dropped from earlier PRD v2** by 2026-04-22 operator mandate:
- M3 (I4 thermal sweep) — Claim κ showed truth-sensor CLI decorative
- M4 (I5 resonance freq sweep) — Claim ν showed resonance_r3 ignores `--steps`
- T4 (LAB-I3 env sweep) — diminishing returns
- S9 (freq-locked) — retained as gap, no root

### Locked / future (Sessions 9+)

Explicitly **locked** means: operator has not authorized; or environment (root) blocks; or infrastructure outside DM3 binary required first.

- **S9 freq-locked**: requires writable `scaling_governor`. Locked until operator authorizes rooting the device or provides an alternative CPU-pin mechanism. [engineer gap, not kill]
- **Tier-2 cells (M1, M2)** from PRD v2: never ran; deferred until Session 8 Phase C provides clearer priors on what additional cells would distinguish. [scope waiting on upstream]
- **F1 / F2 / F3 source-modification cells**: require rebuilding the binary with instrumentation. **Operator has blocked** binary modification; these remain closed until that blanket mandate changes.
- **AGD-C2 mapping-function stability** (inside Phase E): requires embedding model + corpus staging; engineer-agent will build between Sessions.
- **AGD-C3/C4**: not scoped. Reserved for post-Phase-F if the IS_LEDGER reveals a specific open question they would resolve.
- **NPU / Hexagon / Adreno offload**: **ABSTAIN** by standing governance. The binary does not use accelerators and we do not pursue heterogeneous lanes.
- **Parallel dm3_runner**: **NO**. Session 6 and Session 7 tested and confirmed 6–10× per-process slowdown. Serial execution is policy.
- **Intermediate adjacency files**: operator-authored, not engineer-authored. Blocked until operator produces.
- **Source-modification probes** on Sri Yantra geometry itself: blocked (geometry sovereign per user conventions memory).
- **Post-Session-8 strategic pivot** (commercial framing re-entry, external operator prospectus, etc.): deferred. Session 8 is pure science.

### Governance fences (standing)

These are set by operator and do not move without an explicit mandate:

- Binary hash gate: `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
- NIST-KAT canary at battery start (4 vectors)
- No parallel `dm3_runner`; check `pidof dm3_runner` before every invocation
- Airplane mode ON during runs
- Pinned Prime core 7 (`taskset 0x80`)
- PMIC-aware thermal gate (since Session 8, 2026-04-23 — see §5 below)
- Commercial framing stays outside `repo_stage/`
- Retractions and weakenings are first-class events — never silently delete prior claim wording
- Source modification blocked (F1/F2/F3)
- Geometry sovereign (no Sri Yantra structure changes)

---

## 3. What's running RIGHT NOW (as of this handover)

### On-device state

- Phone: RM10 serial `FY25013101C8`, plugged in, fan on, airplane ON
- Date: 2026-04-23T~13:45 UTC (check with `adb shell date`)
- Binary: `/data/local/tmp/dm3_runner` — hash verified
- Harness dir: `/data/local/tmp/dm3_harness/bin/`
- Cells dir: `/data/local/tmp/dm3_harness/cells/`

### Live processes

```
# nohup root (session 8 resume chain):
kill -0 19792   # should return 0 (alive)

# dm3_runner (whatever replicate is in flight):
pidof dm3_runner

# Current cell: A2_overfit_boundary, specifically s50_r3 (final of 21)
```

### Live chain log

```
/data/local/tmp/dm3_harness/phase_a_resume.log
  [09:33:39] PHASE_A_RESUME_CHAIN START
  [09:33:40] --- A2_RESUME ---
  (A.3 and A.4 will be appended when A.2 closes)
```

### Expected wall-clock to Phase A close

- s50_r3 finishes: ~14:00–14:20 UTC
- A.3 (12 runs, steps=20, ~9–15 min each + 1 thermal cooldown per 2–3 runs): ~16:00–18:30 UTC
- A.4 (9 runs, steps=20, same profile): ~18:00–20:00 UTC
- Phase A fully closed: **~20:00 UTC 2026-04-23** (uncertain ±2 h)

---

## 4. Key scientific findings to date (accumulated)

From Sessions 1–7, **short form**. Long form is in `DM3_STATUS_SNAPSHOT_20260422.md` and the per-session FINAL_REPORT files.

### SOLID (never kill without re-running the full chain)
- **α** — DM3 state space exhibits C3 rotational symmetry on default Sri Yantra adjacency
- **β** — Default dynamics produce IID Bernoulli p(HIGH) ≈ 0.34 at harmonic `--steps 5`

### CONFIRMED (Session 6)
- **δ** — `exp_r1_r4_campaign` cross-control: R1 flips on `--adj=RA`; R2 flips on `--tags=v2`; both flip on RA+v2
- **δ.1** — r4.transfer_ratio scales with compound RA+v2 condition
- **δ.2** — CL (claim level) advancement coupled to gate count
- **δ.3** — [WEAKENED Session 7] `operational_steps` hard-capped at 10 in SY-default; δ.3's *"r3.k2_uplift scales with --steps"* was an artifact of sub-10-step regime
- **ε** — p(HIGH) invariant across pin/cold/hot/battery/bypass substrate
- **ζ** — 2×2 R1/R2 axes are cleanly separable
- **η** — Substrate null survives gate-layer bit-level test (4 conditions) and dynamics-layer Wilson-CI test (6 arms × 665 episodes)

### CONFIRMED (Session 7)
- **θ** — Compound RA+v2+steps=50 produces R1+R2 flip, CL-1, r4.transfer=2.68
- **ι** — Dynamics p(HIGH) substrate-invariant across 6 arms
- **κ** — `exp_k3_truth_sensor` CLI flags are decorative; task has fixed 79.4% error reduction independent of flags
- **λ** — R1/R2 cross-control cleanly separable; r4.transfer multiplicative
- **μ** — **First positive learning receipt**: `exp_k2_scars` at `--steps 20` produces `best_uplift=1.324074`; overfits at `--steps 50`
- **ν** — `resonance_r3` ignores `--steps` (CLI decorative)

### Candidate claims (Session 8 Phase A, pending full-phase completion)
- **ξ** — `exp_k2_scars` output is bit-identical deterministic at fixed config (N=31 receipts across A.1 and A.2 all bit-identical within their equivalence classes)
- **ο** — `exp_k2_scars` overfit boundary between `--steps 45` and `--steps 50` is sharp-and-discrete (1.333 → 0.000), not gradual

### RETRACTED
- **γ** — C3-asymmetric coupling (Session 5 retraction; was a Session 4 artifact)

### KILLED
- **H2** — "transformer creates bistability" (Session 3)

### DM3 IS (current snapshot)
- A bistable 380-vertex graph system with IID Bernoulli default dynamics
- A system where `exp_k2_scars` produces receipted LEARNS with overfit at high `--steps`
- A system with a cleanly separable R1/R2 gate axis (R1 ↔ adj, R2 ↔ tags)
- A system whose substrate-null is receipted at gate-layer and dynamics-layer
- A system where `exp_k2_scars` is deterministic at fixed config *(candidate)*

### DM3 IS NOT (current snapshot)
- A system with gradient-accumulated learning (H2 killed)
- A system where `--steps > 20` extends SY-default gate surface operational budget above 10
- A system where `--sensor-strength` / `--sensor-threshold` parameterize truth-sensor
- A system where `resonance_r3` responds to `--steps`
- A system with run-to-run variability on `exp_k2_scars` *(candidate)*

---

## 5. Critical infrastructure you must know

### 5.1 Receipt harness (`/data/local/tmp/dm3_harness/bin/`)

Every DM3 invocation goes through `run_cell.sh`. It:

1. Verifies binary hash gate
2. Checks `pidof dm3_runner` (no parallel runs)
3. Runs thermal gate (**CPU/GPU sensors only** — see §5.2)
4. Captures `env_pre` JSON (battery, thermal, radios, fan, charge_type)
5. Executes `dm3_runner` pinned to specified core, cwd=`/data/local/tmp`
6. Captures `env_post`
7. Writes receipt JSON (`<cell>_<run>.json`)
8. Computes raw `.bin.sha` and canonical `.bin.canonical.sha` (run_sec zeroed)
9. Hashes the receipt itself → `.receipt.sha`
10. Writes `.log` with stdout/stderr (important for tasks that write KPIs only to stdout)

Each cell has a summary at `<cell>_summary.json` + `_summary.sha`. Summary verdict `PASS` if all canonical SHAs are identical (deterministic cells only); `FAIL` if runs=0; for stochastic cells, treat verdict=FAIL as a **script limitation** and apply Wilson-CI overlap test manually.

### 5.2 Thermal gate (patched Session 8)

**`pmih010x_lite_tz` (PMIC) has ~hours of thermal inertia** and stuck at 71–72 °C for 2+ hours while CPUs were cool. This broke the Phase A chain on first run. `run_cell.sh` thermal gate now filters to `cpu-*/cpuss-*/gpuss-*` sensor types; PMIC / DDR / NSP / pm-* are excluded.

**If the gate regresses** (unlikely — it's set in stone until operator says otherwise), compare:
```sh
adb shell 'for z in /sys/class/thermal/thermal_zone*; do printf "%s %s\n" "$(cat $z/type)" "$(cat $z/temp)"; done'
```
- CPU zones should report ~30–60 °C at idle.
- PMIC zone (`pmih010x_lite_tz`) can stay > 65 °C long after compute.

### 5.3 KAT canary

`kat_canary.sh` runs 4 NIST SHA-256 test vectors (empty, `"abc"`, fox sentence, 1M "a"s). All batteries gate on it. If KAT fails the shell's `sha256sum` is suspect and we should abort all runs until diagnosed.

### 5.4 Env snapshot

`env_snapshot.sh` emits a JSON with: kernel, CPU-7 governor/freq, battery level/status/current_ua, airplane mode, thermal (all zones — for diagnostic, not gating), radios, fan prop (if exposed), charge_type. Called before and after each run.

### 5.5 Chain patterns

- Cells (individual scripts like `a1_mu_replicate.sh`): run a set of invocations with a thermal cooldown between each
- Chain (like `phase_a_chain.sh` or `phase_a_resume_chain.sh`): orchestrates multiple cells with resume-safe `_COMPLETE` token logic
- **nohup launch**: `adb shell "nohup sh /path/to/chain.sh > /path/stdout 2>&1 < /dev/null &"` — survives ADB disconnect
- Resume: any chain or cell can be re-run; the `_COMPLETE` token check skips completed units

### 5.6 Canonical SHA vs raw SHA

Some tasks (especially `exp_r1_r4_campaign`) write `"run_sec": X.XX` timestamps into their JSON output. The canonical SHA zeros these fields before hashing so we can detect bit-level equivalence across runs. For all other tasks the canonical SHA == raw SHA.

---

## 6. Artifact tree (what's on disk)

### Host (Mac)

`/Users/Zer0pa/DM3/restart-hypothesis-rm10-primary-platform/`
```
├── docs/restart/           — all session PRDs, final reports, handovers, status snapshots
├── artifacts/              — per-phase dated dirs with harness + receipts
│   ├── phase_S7_P0_receipt_harness_20260418T151800Z/bin/  — Session 7 harness (source of truth for run_cell.sh etc.)
│   ├── phase_S8_P0_learning_20260422T213500Z/bin/         — Session 8 Phase A scripts
│   └── (older)
├── repo_stage/             — public-facing repo mirror (repo-agent owns this)
│   ├── README.md, CLAIMS.md, IS_AND_IS_NOT.md, CHARACTERIZATION_REPORT.md
│   ├── JOURNEY_LOG.md, LIVE_PROJECT.md, website_summary.md
│   ├── HANDOVER_TO_REPO_AGENT_20260422.md  — last handover from engineer → repo-agent
│   └── REPO_AGENT_FINDINGS.md
└── operator/               — operator-only, not for repo_stage/
```

### Device

`/data/local/tmp/`
```
├── dm3_runner              — the hash-gated binary
├── SriYantraAdj_v1.bin     — default SY adjacency
├── RandomAdj_v1.bin        — RA variant
├── RegionTags_v1.bin       — v1 tags (default)
├── RegionTags_v2.bin       — v2 tags
├── data/xnor_train.jsonl   — default dataset
├── data/xnor_mini.jsonl
├── data/xnor_test.jsonl
└── dm3_harness/
    ├── bin/                — all scripts (run_cell.sh, kat_canary.sh, env_snapshot.sh, a1..a4, phase_a_*, etc.)
    └── cells/              — output per cell
        ├── A1_mu_replicate/
        ├── A2_overfit_boundary/
        ├── A3_cross_graph/  (pending)
        ├── A4_cross_dataset/ (pending)
        └── (Session 7 cells preserved: S1..S11, T1..T11)
```

---

## 7. How to resume if the chain dies

### Symptom: `adb shell pidof dm3_runner` is empty and chain log doesn't show `PHASE_A_RESUME_CHAIN_COMPLETE`

Run:
```sh
adb shell "sh /data/local/tmp/dm3_harness/bin/resume_phase_a.sh"
```

That script:
- Checks if chain is already alive (no-op)
- Checks if chain is complete (no-op)
- Otherwise relaunches under nohup, appending to `phase_a_chain.log`
- The individual cell scripts (a1_mu_replicate.sh, a2_resume.sh, a3_rerun.sh, a4_rerun.sh) check `_COMPLETE` tokens on their own progress files and skip completed work

### Symptom: the phone rebooted

Same script. It's safe across reboot because nohup will be gone but the `_COMPLETE` tokens are files on disk.

### Symptom: something subtly broken (e.g., KAT fails)

- Check binary hash first: `adb shell sha256sum /data/local/tmp/dm3_runner`
- Compare to `daaaa84a...` — mismatch is kill-switch level
- If hash OK, check KAT manually: `adb shell sh /data/local/tmp/dm3_harness/bin/kat_canary.sh`
- If KAT OK, examine whichever cell's `progress.txt` is newest

### Symptom: thermal gate regression (CPU zones reporting > 70 °C at genuine idle)

That's a real overheat signal (not the PMIC-inertia false alarm). Pause, physically cool the phone, ensure fan is on, ensure airplane ON. Don't patch the gate around it.

---

## 8. Operator interaction patterns

Key operator messages that define current-session posture:

- **2026-04-22 final session-7 operator message**: *"Write a note to the agent who keeps the repo live. And the front door fresh inviting inspection. Sort of a little handover note. Also, capture our status in document form."* → produced `HANDOVER_TO_REPO_AGENT_20260422.md` + `DM3_STATUS_SNAPSHOT_20260422.md`

- **2026-04-22 late evening Session 8 mandate**: *"Operator mandate — Session 8+ scope, scientific-learning frame. ... reorganized phase structure below. Do NOT run the following dropped cells ... Execute these phases in order, with pre-registered verdicts ... Scientific posture, not commercial posture ... no mid-session revision ..."* → defined Phase A–F scope

- **Standing operator preferences** (from user memory):
  - Long-horizon uninterrupted execution. No interim reports. Single end-of-session report.
  - Phone must **always** run something until PRD close or explicit halt — check-ins are "how we doing?" not go/no-go
  - Unplugged periods of 8+ hours are expected; nohup survives
  - Resume scripts are standard tooling

- **Hard fences** (standing): binary frozen; no parallel; no NPU; airplane default; geometry sovereign; no reward hacking; no source mods

When operator sends *"phone reconnected, advise status"* type message: do a health snapshot + science snapshot + schedule next wake-up. Don't propose new work mid-session unless operator explicitly asks.

---

## 9. Pre-registered thresholds for Phase A–F (operator-set, do not revise)

### Phase A
- **A.1** PASS: all 10 replicates `best_uplift ≥ 0.05` AND median within ±30 % of 1.324 (so [0.927, 1.721]). WEAKEN if median ≤ 50 % of 1.324. RETRACT μ if any 3+ replicates `best_uplift < 0.05`.
- **A.2** No pass/fail (characterization). Receipt the LEARNS→overfit transition.
- **A.3** LEARNS: `best_uplift ≥ 0.05` in ≥ 2 of 4 cells. Any cell at `≥ 0.5` receipts cross-graph robustness.
- **A.4** LEARNS: `best_uplift ≥ 0.05` in ≥ 2 of 3 datasets.

### Phase B
- **B.1** candidate LEARNS = monotone-in-some-parameter receipt with effect size ≥ 10× flat-baseline noise band. Requires N=5 per condition.
- **B.2** Either debug `resonance_v2` to runnable state OR receipt failure mode as persistent.
- **B.3** Per-task per-flag responsiveness table: does the flag produce non-identical canonical SHA across ≥ 2 settings?

### Phase C
- **C.1** No threshold — any R3 flip is a finding.
- **C.2** ≥ 20 tag variants, R1/R2/R3 + r4.transfer state for each.
- **C.3** Unsupervised clustering of 6-gate vector + claim_level across 200 configs. Structure-finding, no pass/fail.
- **C.4** Monotonicity check on gate-count → CL advancement.

### Phase D
- **D.1** S5 re-attempt at N=1000 harmonic `--steps 5` pinned Prime with PMIC-aware watchdog. Target p(HIGH) Wilson 95 % CI ±1.5 pp.
- **D.2** 3 sessions ≥ 48 h apart. PASS: all 3 CIs mutually overlap.

### Phase E
- **E.0** Build Wikipedia corpus subset (1000 paragraphs) + sentence-embedding model + region-mapping function + retrieval rubric. Each independently receiptable.
- **E.1** Retrieval accuracy > chance + statistically significant margin (threshold set at E.0 close).
- **E.2** Mapping-function stability: same embedding → same region mapping, bit-identical deterministic.

### Phase F
- **F.1–F.3** Three markdown files: `IS_LEDGER.md`, `IS_NOT_LEDGER.md`, `OPEN_QUESTIONS.md` in `repo_stage/`. Each entry has receipt chain + kill criterion + reopen condition.

---

## 10. What to do first when you sit down

1. **Check phone state**: `adb devices; adb shell pidof dm3_runner; adb shell "cat /data/local/tmp/dm3_harness/phase_a_resume.log"`
2. **Verify binary hash**: `adb shell sha256sum /data/local/tmp/dm3_runner` → `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
3. **Verify airplane + pinned Prime**: `adb shell "settings get global airplane_mode_on; cat /sys/devices/system/cpu/cpu7/cpufreq/cpuinfo_max_freq"`
4. **Count receipts**: see §3 "Expected wall-clock to Phase A close" and compare to actual `ls /data/local/tmp/dm3_harness/cells/A*/` counts
5. **Read the most recent progress.txt**: whichever A-cell is active
6. **If chain has closed** (log shows `PHASE_A_RESUME_CHAIN_COMPLETE`): begin Phase A end-of-phase analysis → author Phase B scripts
7. **If chain has died**: run resume script (§7)
8. **If chain is mid-execution**: schedule a periodic check-in via `ScheduleWakeup`, don't interfere

Do **not**:
- Modify `/data/local/tmp/dm3_runner` — binary is frozen
- Run parallel `dm3_runner` — serial only
- Disable airplane mid-run
- Silently tighten or loosen pre-registered thresholds
- Promote candidate claims to CONFIRMED before the phase they belong to is closed

---

## 11. Where the most recent truth lives

- **Latest status snapshot**: `docs/restart/DM3_STATUS_SNAPSHOT_20260422.md` (Session 7 close; out of date for Session 8 Phase A)
- **Latest interim update**: `docs/restart/DM3_SESSION8_PHASE_A_INTERIM_20260423.md` (companion to this doc)
- **Last handover to repo-agent**: `repo_stage/HANDOVER_TO_REPO_AGENT_20260422.md`
- **Last session final report**: `docs/restart/DM3_SESSION7_FINAL_REPORT.md`
- **Operator's Session 8 mandate**: captured verbatim in the project conversation history; the operative paragraphs are listed in §9 above and §2's "Dropped from earlier PRD v2" list

---

## 12. Contact with the repo-agent

`repo_stage/` is maintained by a **separate repo-agent** (not this engineer-agent). Its job is to keep the public-facing mirror fresh: promoting claims, updating IS_AND_IS_NOT, refreshing README + website_summary, maintaining JOURNEY_LOG and LIVE_PROJECT. The handover at `repo_stage/HANDOVER_TO_REPO_AGENT_20260422.md` lists what the repo-agent should do after Session 7.

As of this handover, **the repo-agent has NOT yet integrated Session 7 claims θ–ν into `CLAIMS.md`**. The interim update doc notes that ξ and ο (Session 8 candidate claims) should wait until Phase A fully closes before being forwarded.

Engineer-agent does not push directly to `repo_stage/`; communicates by writing handover notes and engineer-final-report docs, which the repo-agent reads.

---

## 13. Open scientific questions (known, not yet addressable)

1. Is `exp_k2_scars` determinism robust across graph topology (A.3) and dataset (A.4)?
2. Does the overfit cliff (at steps=45–50 on SY_v1+xnor_train) move with adj, tags, or dataset?
3. Are the other 11 tasks deterministic under fixed config or stochastic?
4. Does `exp_r1_r4_campaign` produce an R3 flip under ANY of the 12 tasks? (Phase C.1)
5. What is the definitive p(HIGH) with Wilson CI ±1.5 pp? (Phase D.1; Session 7 S5 was thermally truncated at N=23/100)
6. Does the 6-gate vector cluster into discrete regimes, or is it smeared? (Phase C.3)
7. Can DM3 do retrieval (Mode A) at better-than-chance on external Wikipedia text? (Phase E)

---

## 14. Deferred work that doesn't belong in Session 8

- Intermediate adjacency files (operator-authored required)
- Source-modification probes (binary frozen)
- AGD-C3/C4 (not scoped)
- NPU / Hexagon offload (standing ABSTAIN)
- Commercial operator prospectus (outside repo_stage/, operator-owned)
- Multi-day continuity tests beyond D.2 (D.2 is 3 sessions; future could be 7+ sessions)
- Adversarial probing of the gate surface (Phase C starts structural; adversarial is post-Phase-C)

---

## 15. Final note

The DM3 project is doing one thing well: producing a **receipted record of what the binary actually does**, including what it does NOT do. Both IS and IS NOT findings are equally valuable. The governance is set by the operator and does not flex inside a session. The engineer-agent's role is to run the chain, read the outputs, flag errors in writing, and produce end-of-session reports.

Session 8 is in the middle of that. Pick up the chain, don't break it, don't improvise.

If you find something that looks overreached or unsupported in the claim ledger or the interim update, flag it to operator in writing — that's the highest-value thing you can do.

—— Outgoing engineer-agent, 2026-04-23
