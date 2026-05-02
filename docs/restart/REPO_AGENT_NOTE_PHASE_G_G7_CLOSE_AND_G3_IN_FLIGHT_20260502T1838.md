# Repo-agent note — Phase G partial data pull (fourth pull): G.7 closed, G.3 in flight

Written: `2026-05-02` ~18:38 UTC
From: DM3 engineer-orchestrator (support / advisor mode)
For: the repo-agent
Companion to:
- `HANDOVER_TO_REPO_AGENT_PHASE_G_G2_PASS_AND_G7_IN_FLIGHT_20260428.md` (still the canonical promotion target)
- `REPO_AGENT_NOTE_PHASE_G_PARTIAL_DATA_PULL_20260429.md` (02:35 UTC)
- `REPO_AGENT_NOTE_PHASE_G_PARTIAL_DATA_PULL_20260429T1300.md` (13:05 UTC)
- `REPO_AGENT_NOTE_PHASE_G_PARTIAL_DATA_PULL_20260430T0830.md` (08:30 UTC)

This note adds: **G.7 closed at 2026-05-01 15:07 UTC with a dual verdict (harness summary PASS / cell outcome KILL). Chain advanced to G.3 (in flight, 17/48 receipts done). New observations DO NOT promote in this cycle — chain-close handover will land them.**

**OPERATOR REQUEST:** push the morning bundle (the `HANDOVER_..._20260428.md` integration target) to public `Zer0pa/DM3` **now** to bring GitHub current. The four partial-pull notes (this one plus the prior three) accumulate as evidence handles; **nothing in them changes the morning bundle's promotion list**.

---

## 1. Evidence handles — on-device only (host pull at chain close)

```
on-device:
  /data/local/tmp/dm3_harness/cells/G7_cliff_class_characterization/outcome.json
  /data/local/tmp/dm3_harness/cells/G7_cliff_class_characterization/G7_cliff_class_characterization_summary.json
  /data/local/tmp/dm3_harness/cells/G7_cliff_class_characterization/G7_cliff_class_characterization_summary.sha
  /data/local/tmp/dm3_harness/cells/G7_cliff_class_characterization/G7_cliff_class_characterization_<cfg>_<step>_<rep>.{bin,json,log,*.sha}  (45 receipts × 4 files)
  /data/local/tmp/dm3_harness/cells/G3_learns_cartography/progress.txt   (17 OK lines at write time)
  /data/local/tmp/dm3_harness/cells/G3_learns_cartography/<cfg>_<task>_s<step>.{bin,json,log,*.sha}
  /data/local/tmp/dm3_harness/phase_g_chain.log
host (post-close):
  artifacts/phase_S8_PG_followup_<TS>/cells/<cell>/...
```

Earlier partial pulls (`phase_S8_PG_followup_20260429T023308Z/`, `_20260429T130215Z/`, `_20260430T082723Z/`) remain valid for the previously-pulled cells.

---

## 2. G.7 closed — dual-verdict shape (this is by design, not a contradiction)

Two artifact files in G.7 carry independent verdicts measuring different things. Both are required reading.

### `G7_cliff_class_characterization_summary.json` — `verdict = PASS`

```
total_runs                       : 45
unique_output_sha256_raw         : 45        (timestamps differ run-to-run)
unique_output_sha256_canonical   : 1         (all 45 byte-identical after run_sec zeroed)
unique_canonical_sha             : e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
unique_receipt_sha256            : 45        (every receipt JSON has its own hash, expected)
verdict_basis                    : "canonical (run_sec zeroed)"
verdict                          : PASS
```

This is the **harness-level determinism summary**. 45/45 receipts across `cfg-A × cfg-B × cfg-C × steps {48,49,50,51,52} × reps {1,2,3}` produced byte-identical canonical output. Adds 45 receipts to the claim `ξ` evidence base. **No promotion in this cycle**; lands at chain close.

### `outcome.json` — `verdict = KILL`

```json
{
  "cell": "G7_cliff_class_characterization",
  "verdict": "KILL",
  "summary": "cliff moved in at least one preserved config",
  "metrics": {
    "preserved_configs": "a b c",
    "cfg_a": {"v48":"1.750137","v49":"1.897110","v50":"0.000000","v51":"0.000000","v52":"1.368141","cliff_at_s50":0},
    "cfg_b": {"v48":"0.569172","v49":"0.543240","v50":"0.000000","v51":"0.000000","v52":"0.000000","cliff_at_s50":0},
    "cfg_c": {"v48":"1.677055","v49":"1.819397","v50":"0.000000","v51":"0.000000","v52":"1.322502","cliff_at_s50":0}
  },
  "next_actions": []
}
```

This is the **cell-level cliff-class verdict**. The chain's hypothesis (`cliff_at_s50` predicate) was that the cliff is a *single-step* event at s50. The data refutes that:

- cfg-A (`RandomAdj_v1`): cliff spans s50 *and* s51 (two-step cliff; recovers at s52 to 1.37)
- cfg-B (`RegionTags_v2`): cliff spans s50, s51, *and* s52 (three-step cliff; no recovery in this window)
- cfg-C (`xnor_mini`): cliff spans s50 *and* s51 (two-step cliff; recovers at s52 to 1.32)

KILL is the chain's tag for "scope claim weakened — do not generalize." It does **not** retract σ″ shape (G.2 PASS stands). It sharpens the σ″ scope-note: cliff *width* is config-dependent, not a fixed single-step event.

### What this means for σ″ (currently CONFIRMED for shape via G.2)

| Property | Status |
|---|---|
| σ″ trimodal sawtooth shape preserved across cross-controls | **CONFIRMED** (G.2 PASS — no change) |
| σ″ magnitudes config-dependent | already in morning bundle scope guard |
| σ″ cliff *width* config-dependent (NEW from G.7 KILL) | **scope-note refinement, lands at chain close** |
| σ″ cliff direction (negative-uplift, from prior partial-pull notes) | preserved cross-config; lands at chain close |

**DO NOT promote G.7 verdict (KILL or PASS), the dual-verdict shape, the σ″ width-config-dependence refinement, or the 45-receipt ξ extension in this cycle.** All of these wait for the next chain-close handover.

---

## 3. G.3 in flight

G.3 (`learns_cartography`) launched `2026-05-02 13:07 SAST` (~11:07 UTC). At write time, 17 OK lines in progress.txt:

```
harmonic           s1/s5/s10/s20/s30/s50   6/6 ✓
holography         s1/s5/s10/s20/s30/s50   6/6 ✓
interference       s1/s5/s10/s20           4/6 (s30, s50 pending)
holographic_memory                         0/6 pending
exp_r1_r4_campaign                         0/6 pending
exp_i1                                     0/6 pending
exp_h1_h2                                  0/6 pending
exp_k3_truth_sensor                        0/6 pending
```

Cell plan: 8 tasks × 6 step values × N=1 = 48 receipts. Verdict format is `PARTIAL` by design — characterization cell, classes tasks as `DECORATIVE` / `MONOTONE` / `RESPONSIVE-LIKELY-LEARNS` by counting unique log SHAs across step values.

**Notes for the repo-agent:**
- The leading `FAIL` block in G.3's `progress.txt` (with `DM3_RUNNER_ALREADY_RUNNING` errors) is from the 2026-04-25 first chain pass and is stale. The current pass starts at `[13:07:21] G3_learns_cartography start: 8 tasks x 6 steps x N=1 = 48 runs` — that is the real run.
- The `interference` task receipts produce empty `out_sha=` lines because that task does not emit a `.bin` output at small step values. Receipt JSON and log files exist; the cell's outcome aggregation reads logs (`sha256sum *.log`) not bins. **Not a chain bug.**

---

## 4. Operational state (path-scoped, my workstream only)

```
phone wall:        2026-05-02 18:38 UTC
chain master:      PID 636, PPid=1, sleeping ✓
death watcher:     PID 9655 ✓
g4 launcher:       PID 28711 ✓
dm3_runner:        alive (PID rotates per receipt; current at write time = 14786) ✓
battery:           85% / AC / charging / status=2 / voltage 8427 mV / 30.0°C
```

Chain progressing healthily. The phone hosts other workstreams; CPU/thermal queries here are intentionally scoped to my chain's processes and paths only.

---

## 5. ETA

| Cell | Status | ETA |
|---|---|---|
| G.3 | in flight, 17/48 done in ~7.5 h | 8–24 h to close (the 5 pending tasks include `holographic_memory`, `exp_*` which weight toward larger step values) |
| G.4 / G.5 / G.5+ | pending; first-pass log marked them complete-skip; v2 chain may re-run | uncertain (0–24 h if mostly skip; 12–48 h if full re-run) |
| `PHASE_G_CHAIN_V2_COMPLETE` | | 24–72 h, point estimate ~36 h |

The next chain-close handover will supersede this note **and** the morning bundle, integrating: σ″ scope-note refinement (cliff width config-dependent), G.3 cartography classes, G.4/G.5/G.5+ verdicts, and the full ξ evidence-base extension.

---

## 6. What the repo-agent should do **now**

**Push the morning bundle to public `Zer0pa/DM3`.**

The integration target is `HANDOVER_TO_REPO_AGENT_PHASE_G_G2_PASS_AND_G7_IN_FLIGHT_20260428.md`. That handover lists the exact promotions (CLAIMS, IS_AND_IS_NOT, RETRACTIONS, README, CHARACTERIZATION_REPORT, new RECONSTRUCTION_TIER2_NOTE.md). Promote per its instructions. The four partial-pull notes accumulate as evidence handles only; none change the promotion list.

If the partial-pull notes themselves should be added to public, treat them as appendix/evidence material (not as promotion drivers). Operator preference: keep them as in-tree audit trail; do not splash them across the public README.

## 7. What the repo-agent should **NOT** do in this cycle

- **DO NOT** promote G.7 verdict (KILL or PASS), the dual-verdict shape, the cliff-width-config-dependent observation, or the 45-receipt ξ extension. All G.7 promotion waits for the next chain-close handover.
- **DO NOT** promote G.3 receipts or any class assignment (cell is in flight; no closing `outcome.json` yet at write time).
- **DO NOT** push `MANIFEST.tsv` updates for in-flight Phase G receipts.
- **DO NOT** alter `LICENSE`, `CITATION.cff`, `TRADEMARK.md`, `CONTACT.md`, or the SAL exception unless the operator explicitly authorizes.
- **DO NOT** migrate `dm3-runner-reconstruction-2026-04-27/` artifacts into public `artifacts/`. That workspace stays separate; cite by handle only.
- **DO NOT** smooth over the σ → σ′ → σ″ rejection lineage, the σ″ "shape preserved, magnitudes not preserved" distinction, or (when the chain-close handover lands) the σ″ "cliff *width* config-dependent" refinement.

## 8. Suggested commit-message stems

(Identical to the morning handover. No changes — those stems still describe what to push.)

```
docs(claims): G.2 PASS — σ″ shape geometry-independent across cross-controls
docs(claims): add χ path-independence, ψ cycle-extension, Reconstruction R1-R8
docs(is-and-is-not): G.2 close — σ″ shape portable, magnitudes not portable
docs(is-and-is-not): add Phase G + Reconstruction Tier-2 sections
docs(retractions): δ.3 weakened, σ/σ′ rejected-before-promoted, θ wording superseded
docs(reconstruction): add RECONSTRUCTION_TIER2_NOTE.md, R8 OPEN_TIER3_BLOCKED
docs(characterization): add Phase G v2 G.2 close + Reconstruction Tier-2
docs(readme): G.2 PASS note, σ″ shape promotion, R8 open, magnitudes-not-portable
```

Squash-merge or per-file commits at the repo-agent's discretion.

---

—— DM3 engineer-orchestrator (support/advisor mode), 2026-05-02 18:38 UTC
