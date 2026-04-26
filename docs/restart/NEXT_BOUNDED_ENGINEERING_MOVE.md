# Next Bounded Engineering Move

Last refreshed: `2026-04-18` (mid-Session 6; W3 verdict pending; W4 in progress)

## Single best next move (Session 7 core)

**Expand the graph cross-product.** Session 6 showed two reproducible
gate flips in `exp_r1_r4_campaign` — both along graph-structure axes
(`--adj` and `--tags` file swaps). Within a fixed graph every dynamical
parameter is null for this task. The space of "what makes R1 / R2
flip" is therefore a graph-topology space, mostly unmapped.

Author or acquire additional adjacency / region-tag files and run the
campaign on each. Highest-value probes:

1. **Intermediate adjacency files** between SriYantra (R1 FAIL) and
   Random (R1 PASS). Examples: a graph with the SriYantra node
   partition but randomized edges; a graph with Random node partition
   but SriYantra edge structure. Identify what property of the
   adjacency moves `r1.margin` from 0 to 0.5.
2. **More region-tag files**. RegionTags_v2 flipped R2; authoring a
   `RegionTags_v3` with a different region partition would probe
   whether R2 responds to region *count* vs region *structure*.
3. **Cross-product of the above**: Random adjacency × RegionTags_v2 →
   does the combination flip more gates, or does it collide?

## Second-best next move: Does `--steps ≥ 50` flip R3?

Session 6 W1 observed R3 payload-moving: `r3.k2_uplift` went from
0.0070 at steps=1 to 0.0292 at steps=20 (4× increase). R3 gate still
false. A steps=50 probe (~85 min serial) would test whether k2_uplift
crosses its threshold. If yes, R3 flips with longer operational steps.
If no, R3 needs a different input channel.

## Third: RNG determinism test

P2a established basin selection is IID Bernoulli. Does the per-episode
RNG draw from a deterministic seed (wall clock, previous-state hash)
or from /dev/urandom? Run two back-to-back identical harmonic sessions
(same flags, same binary); compare basin sequences. If identical → seed
is deterministic and Session 8 could control it without source
modification.

## Fourth: RegimeC (ChaosControl) entrypoint hunt

Binary strings name "RegimeARandomRegimeBSriYantraRegimeCChaosControl"
and a `k_chaos_control` WGSL kernel (OGY-style weight nudge), but there
is no `--regime` flag and no `chaos_control` task name. Hypotheses to
probe:

- Does a specific adjacency file (e.g. one named "ChaosAdj" or
  containing a chaos marker) trigger RegimeC dispatch?
- Does the binary accept a `chaos_control` or `chaos` task name we
  haven't tried? (Session 6 W0 probed a list; new candidates for
  Session 7: `chaos`, `chaos_control`, `regime_c`, `c_chaos`.)
- Does RegimeC have its own binary symbol in a subsection we haven't
  grepped? Session 7 scan: `nm`-style export symbol inspection.

## Parallelization — DO NOT REVISIT

Session 6 confirmed the binary is multi-threaded and saturates the
Snapdragon cores. 2× concurrent processes give ~6-10× per-process
slowdown. Serial throughout is the correct strategy on this device.

## What Session 6 established

### New gate-flip axes
- `--adj RandomAdj_v1.bin` → **R1 flips PASS** (r1.margin 0.0 → 0.5)
- `--tags RegionTags_v2.bin` → **R2 flips PASS** + claim_level CL-0 → CL-1
- `--steps 20` → r3.k2_uplift 4× increase (payload moving, gate unchanged)

### Null axes for exp_r1_r4_campaign
`--asymmetry`, `--rotation`, `--dataset`, `--steps ≤ 10` (for gates).
All produce bit-identical canonical SHA across the tested surface.

### Task inventory
12 total accepted task names. 7 new this session (exp_i1, exp_i2,
exp_h1_h2, exp_k2_scars, exp_k3_truth_sensor, resonance_r3, resonance_v2).

### asym ≤ −3 third regime
Coh compression confirmed smooth and monotone. Basin classifier
recalibrated: Session 4 classifier valid for asym ∈ [−2, +2] only.
Emerging mid-cluster at asym ∈ {−3.5, −4} is suggestive; not yet robust.

### Operational
Parallelization tested and discarded. Serial is faster.
exp_r1_r4_campaign is byte-deterministic up to run_sec.

## What Session 6 killed or weakened

- (No new retractions this session. Claim γ remains retracted from Session 5.)
- W1 Tier A "asymmetry/rotation/steps sweep of exp_r1_r4_campaign"
  truncated to 2 cells when bit-identical output revealed the entire
  SY parameter space is null for this task.

## What is pending (W3)

- Arm A (asym=+0.2) vs Arm 0 (asym=0) vs Arm B (asym=−0.2):
  Is p(HIGH) parameter-dependent at fine asymmetry perturbation? Three
  possible outcomes pre-registered:
  - W3-PARAMETER-DEPENDENT (new order-parameter dimension)
  - W3-INVARIANT (strengthening of Session 5 IID claim)
  - W3-INDEPENDENCE-BROKEN (Session 7 deep-dive)

## Do NOT do next

- Do not parallelize on this binary (confirmed counterproductive).
- Do not expand the SY × (asym/rot/dataset/steps≤10) grid for
  exp_r1_r4_campaign (null axes; already Tier A-truncated).
- Do not reopen H2 (geometry sovereign — strongest it's been).
- Do not reopen Claim γ unless a chirality-adjacent signal surfaces.
- Do not touch NPU / heterogeneous / F1/F2/legacy boundary.
- Do not run `--soak N > 1` (20×N episodes).
- Do not introduce commercial framing.

## Device state at time of write

- Serial: FY25013101C8, hash `daaaa84a...9672` (verified Session 6 start).
- W3 in flight under nohup on device; `phase_W3_p_high_receipts/progress.txt`
  is the recovery beacon. 1 session complete (`arm_plus02_s1`, N=20, p=40%);
  9 sessions pending.
- Resume script staged at `/data/local/tmp/w3_resume.sh` — skips
  already-complete 20-episode sessions; run it if the device reboots
  mid-W3.
- Battery ≥86% AC-powered last checked; `settings put global stay_on_while_plugged_in 7`
  applied for screen-on-while-charging.
