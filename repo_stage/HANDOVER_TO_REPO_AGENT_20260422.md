# Handover to repo-agent — Session 7 close

Written: `2026-04-22` by the Session 7 engineer-agent.
For: the repo-agent keeping `repo_stage/` fresh and the front door inviting.

---

## TL;DR

Session 7's PRD v2 core is **closed**. Six new claims are promoted
(**θ, ι, κ, λ, μ, ν**) and one prior claim is weakened (**δ.3**). The
strongest new headline is **Claim μ: the first receipted positive
learning finding in Sessions 3–7** — `exp_k2_scars` LEARNS-STRONG at
`--steps 20` and overfits at `--steps 50`. The substrate-null story is
now receipted at **both** layers (gate surface bit-level, dynamics
layer statistical). S9 freq-locked remains the sole documented gap
(root required). Everything else is ready for your pass.

Please inspect, integrate, and flag anything that reads as
overstated or unsupported. The engineer-agent's final report is at
[`docs/restart/DM3_SESSION7_FINAL_REPORT.md`](../docs/restart/DM3_SESSION7_FINAL_REPORT.md).

---

## What's new since your last pass

### New promoted claims (in the engineer-agent final report, not yet in repo_stage/CLAIMS.md)

| Claim | One-line | Evidence path |
|-------|----------|---------------|
| **θ** | Compound `RA+v2+steps=50` → R1+R2 flip, CL-1, r4.transfer=2.68 | `artifacts/.../S11_partial/S11_r3_flip_B_RA_tagsV2_s50_001.bin` |
| **ι** | Dynamics p(HIGH) substrate-invariant across 6 arms × 665 eps | `artifacts/.../{S2H_final,S7_thermal_final,S8_final,S5_final}/` |
| **κ** | exp_k3_truth_sensor CLI flags decorative; fixed 79.4% error reduction | `artifacts/.../S10_final/*.log` (9 configs) |
| **λ** | R1/R2 cross-control cleanly separable; r4.transfer multiplicative | `artifacts/.../T11_cross_control/` (N=3 replicates) |
| **μ** | exp_k2_scars LEARNS-STRONG: best_uplift 0.01→1.32 across steps 1→20; overfits at 50 | `artifacts/.../T2_scars_scaling/*.log` (5 step values) |
| **ν** | resonance_r3 ignores `--steps` flag (CLI decorative) | `artifacts/.../T3_plasticity/*.log` (4 step values) |

### Claim weakening

**δ.3 (R3 payload-moves along `--steps`)**: Session 6 observed
`r3.k2_uplift` scaling linearly with `--steps`. Session 7 T11 A-cells
(steps=20/50/100) showed `operational_steps` caps internally at 10,
producing **bit-identical canonical SHAs** for steps ≥ 20. Claim δ.3
should be revised to: *"R3 gate is structurally unreachable from the
currently-exposed CLI; internal `operational_steps` hard-caps at 10
regardless of `--steps` request."*

### Artifact trees to mirror (your prior pending-sync list closes here)

All of these now live under
`artifacts/phase_S7_P0_receipt_harness_20260418T151800Z/`:

- **Substrate battery (bit-level gate null):** `S1_smoke/`, `S2_pinned/`, `S4_airplane/`, `S6_core/`, all with summary JSONs + canonical SHAs
- **Substrate battery (dynamics statistical null):** `S2H_final/`, `S7_thermal_final/`, `S8_final/`, `S5_final/`
- **Learning probes:** `S10_final/` (stdout KPIs, 9 configs), `S11_final/` (5 configs)
- **Tier-1 cross-control + learning:** `T11_cross_control/`, `T1_cartography/`, `T2_scars_scaling/`, `T3_plasticity/`

Each cell has:
- `<cell>_<run>.json` — receipt (env_pre + env_post + hashes + cli + duration)
- `<cell>_<run>.bin` — raw dm3 output (or empty if task writes to CSV/stdout only)
- `<cell>_<run>.bin.sha` — raw SHA
- `<cell>_<run>.bin.canonical.sha` — canonical SHA (run_sec zeroed)
- `<cell>_<run>.receipt.sha` — SHA of the receipt JSON itself
- `<cell>_<run>.log` — stdout/stderr capture (important for S10/T2/T3 where task writes outside JSON)
- `<cell>_summary.json` + `<cell>_summary.sha` — battery-level summary receipt

---

## What the engineer-agent recommends you do

1. **Promote Claims θ, ι, κ, λ, μ, ν** into `repo_stage/CLAIMS.md` with
   status CONFIRMED. Keep the kill criteria verbatim from the
   engineer-agent final report so nothing dilutes in translation.

2. **Amend Claim δ.3** with the Session 7 weakening language. Do NOT
   delete the original — retractions/weakenings remain visible per
   project governance.

3. **Mirror the full Session 7 artifact trees** into your artifact
   accounting. The `MANIFEST.tsv` should have entries for every
   `.bin`, `.json`, `.sha`, `.log` under the Session 7 phase dir.

4. **Refresh README.md and website_summary.md** with the expanded
   Session 7 story. Suggested headline for README:
   > *Session 7 closed PRD v2. First positive learning receipt in the
   > project's history (exp_k2_scars LEARNS at steps=20, overfits at
   > steps=50). Substrate-null receipted at both gate-layer (bit-level,
   > 40 invocations) and dynamics-layer (statistical, 665 episodes).
   > The 2×2 gate-flip cross-control is closed with cleanly separable
   > axes.*

5. **Update IS_AND_IS_NOT.md** with the new Session 7 positives:
   - DM3 IS: "a system where `exp_k2_scars` exhibits receipted LEARNS
     with overfit at high --steps"
   - DM3 IS: "a system whose R1 gate responds only to `--adj` and whose
     R2 gate responds only to `--tags`"
   - DM3 IS NOT: "a system where `--steps > 20` extends SY-default
     gate surface operational budget above 10"
   - DM3 IS NOT: "a system where `--sensor-strength`/`--sensor-threshold`
     parameterize the truth-sensor task"

6. **Update JOURNEY_LOG.md Session 7 paragraph** to reflect closed rather
   than interim status. The current interim paragraph flags pending
   sync items; those items are now satisfied by the artifact trees
   listed above.

7. **Retire `REPO_AGENT_FINDINGS.md`'s pending-sync list** once the
   above mirroring lands. The repo-agent findings document can then
   record the Session 7 integration pass itself as the latest entry.

---

## What NOT to do

- **Do not silently delete the Session 6 interim claim wording.** Keep
  Session 6's δ.3 language visible and append the Session 7 weakening
  underneath. Retractions/weakenings are first-class events.
- **Do not roll Claim μ into a broader "DM3 learns" narrative.** Claim
  μ is strictly about `exp_k2_scars` at the tested `--steps` window,
  with the overfit edge documented. It is the first receipted positive,
  not a general capability claim.
- **Do not overstate the substrate null beyond the tested envelope.**
  The gate-layer null covers 4 substrate conditions (pinned, airplane,
  core topology, default thermal/power). The dynamics-layer null covers
  6 arms (pinned cool, cold, hot, battery, bypass, basin-volume).
  Anything outside that envelope remains untested.
- **Do not let commercial language cross the `repo_stage/` boundary.**
  Operator prospectus (if any) stays in the operator-only dir, not
  repo_stage/.
- **Do not promote claims from tasks where the CLI is decorative**
  (κ truth-sensor, ν resonance_r3) as "tunable capability." They are
  narrow claims about the *task's invariance to the flag*, not broad
  claims about the task's function.

---

## Scope fences remain intact

- No NPU / Hexagon / Adreno DM3 offload (still ABSTAIN)
- No parallel `dm3_runner` (confirmed counterproductive Session 6, reaffirmed Session 7)
- No reopening H2 (transformer-creates-bistability: killed Session 3, strengthened S4)
- No reopening Claim γ (C3-asymmetric coupling: retracted Session 5)
- No source-modification claims (F1, F2, F3 tier-4 cells still blocked)
- Commercial framing stays outside `repo_stage/`
- `dm3_runner` binary SHA-256 `daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672`
  remains the hash-gate; any receipt whose `binary_sha256` != this value
  should be flagged and quarantined

---

## Sync seams that may reappear during your pass

1. **S10 `.bin` files are empty by design.** The truth-sensor task writes
   KPIs to stdout, not to `-o <path>`. The 9 S10 receipts show `out_sha = <empty>`
   — that's correct behavior, not a data-loss bug. The scientific content
   is in the `.log` files (KPI_K3 + KPI_RING_GAP lines).

2. **resonance_v2 self-test failure.** T1 cartography ran resonance_v2
   and it returned in 0.392s with no useful output. Not a harness bug
   — the task itself appears to need ring-selection flags we haven't
   surfaced. Flag as `NEEDS_INVESTIGATION` in your findings doc.

3. **Duration field in S2 and S4 receipts was affected by the 32-bit
   overflow** that was fixed mid-session. Re-emission pass happened
   (files now show `duration_sec`), but if you re-hash, note that the
   `canonical.sha` is unaffected (canonicalization zeroes run_sec and
   only covers the bin file, not the receipt JSON).

4. **S5 thermal-truncation.** S5 was budgeted at N=100 but halted at
   N=23 on thermal ceiling (70°C on `pmih010x_lite_tz`). The remaining
   77 runs are a documented deferred item, not lost data. The N=23
   sample still gives an overlapping-baseline Wilson CI, so Claim ι is
   supported by what exists.

5. **S2H summary script verdict = FAIL** is a script limitation, not a
   science verdict. The summarize_cell.sh script was built for
   deterministic cells (unique_canonical_sha == 1 → PASS) and applies
   that logic to harmonic, which is intrinsically non-deterministic.
   For harmonic cells (S2H, S7, S8 arms, S5, T3), the correct verdict is
   the Wilson-CI overlap test documented in the engineer-agent final
   report. Please note this in your findings.

---

## Three questions for the repo-agent to pose back

If anything in the above reads as overstated or unsupported to you,
please flag it rather than silently correcting. The engineer-agent
wrote the above in fresh context and may have overreached. Three
specific things to scrutinize:

1. **Is Claim μ (exp_k2_scars LEARNS-STRONG) tight enough?** The N=1
   per step value is thin. The monotone trend 0.01 → 0.075 → 0.273 →
   1.324 is clean, but should we demand N=3 per step before promoting?

2. **Is Claim λ (cross-control separable) observing the multiplicative
   transfer effect correctly?** The r4.transfer_ratio pattern is
   0.658 (RA+v1), 1.369 (SY+v1), 1.442 (SY+v2), 2.133 (RA+v2). Is
   that "multiplicative" or just "RA+v2 has highest transfer for
   unclear reasons"?

3. **Is the Session 7 total artifact count sufficient** for the PRD v2
   §6 receipt-format requirement that "the summary's hash is the
   primary citable artefact"? We have ~350 receipts across ~20 cell
   batteries. Should the MANIFEST.tsv entry be single-file-level or
   single-cell-level?

Treat these as invitations to push back.

---

## Final note

The engineer-agent has taken Session 7 as far as this binary +
operator's PRD v2 allows without: (a) rooting the device, (b)
authoring new adjacency/tag files, or (c) running multi-day tier-2/3
campaigns. Those are Session 8+ territory and are flagged in the
final report's "roadmap ahead" section.

The repo-agent's pass closes the public-facing story for the
Monday-style go-live call. The engineer-agent's final report is
scoped internally; the repo-agent decides what gets promoted to the
front door.

Thank you for keeping the door fresh.

—— Session 7 engineer-agent, 2026-04-22
