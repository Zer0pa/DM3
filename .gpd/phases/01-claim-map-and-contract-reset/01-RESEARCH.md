# Phase 01: Claim Map and Contract Reset - Research

**Researched:** 2026-04-03
**Domain:** falsification-first computational research planning, claim governance, and cross-lane reproducibility setup
**Confidence:** MEDIUM

## Summary

Phase 01 should be executed as an evidence-reduction phase, not as a model-building phase and not as a phone-performance phase. Its job is to turn the manifesto and training-doc narrative into a governed claim inventory, using the recovered Genesis protocol, agent guide, and recoverable source-backed substrate as the only strong anchors. The main output is a claim map and contract reset that downstream phases are forced to obey.

The strongest execution pattern is a two-plan sequence. Plan `01-01` should build the `Txx` registry by tracing each downstream-used manifesto label to a concrete source locator, protocol, ledger, or explicit gap. Plan `01-02` should freeze the skeptical restart contract: what counts as evidence, which claims are hybrid-only, what battery taxonomy the restart will use, how branch creation is governed, and how RM10 Pro hardware facts are allowed to inform later phases without being mistaken for proof.

Research mode is `explore`, but that does not justify architectural sprawl inside Phase 01. The breadth belongs in the comparison of mapping methods and candidate future hypotheses, not in creating many branches or running speculative batteries. The planner should treat Phase 01 as the gate that decides what later branching is allowed to mean.

**Primary recommendation:** Execute Phase 01 as a two-pass claim-governance phase: first map or reject manifesto labels against strong anchors, then freeze the restart contract, branch rules, battery taxonomy, and hardware-scope note before any hypothesis branching or replay work.

## User Constraints

- Honor the working rule in [01-CONTEXT.md](/Users/Zer0pa/DM3/restart/.gpd/phases/01-claim-map-and-contract-reset/01-CONTEXT.md): if a claim cannot be traced to code, a protocol, a ledger, or a reproducible artifact, it does not count as established evidence.
- Preserve the restart posture in [PROJECT.md](/Users/Zer0pa/DM3/restart/.gpd/PROJECT.md) and [REQUIREMENTS.md](/Users/Zer0pa/DM3/restart/.gpd/REQUIREMENTS.md): Phase 01 is about `MAPP-01` through `MAPP-03`, not baseline replay, not hybrid rebuild, and not device proof.
- Keep the hypothesis framing from [TRAINING_DOC_HYPOTHESES.md](/Users/Zer0pa/DM3/restart/docs/restart/TRAINING_DOC_HYPOTHESES.md) visible, but treat those documents as contextual hypotheses, not as source-backed proof.
- Preserve the GPD governance in [GPD_OPERATING_MAP.md](/Users/Zer0pa/DM3/restart/docs/restart/GPD_OPERATING_MAP.md): mainline roadmap first, genuine hypothesis branches later, battery matrix tracked separately from worldview changes.
- Preserve the branch discipline in [HYPOTHESIS_BRANCH_REGISTER.md](/Users/Zer0pa/DM3/restart/docs/restart/HYPOTHESIS_BRANCH_REGISTER.md): branches are for different scientific stories, not for seeds, durations, or hardware lanes by themselves.
- Keep RM10 Pro in scope because the user requires a real phone lane, but do not let hardware availability distort the Phase 01 objective. Hardware facts are a planning input, not a claim-survival result.

## Active Anchor References

| Anchor / Artifact | Type | Why It Matters Here | Required Action | Where It Must Reappear |
| ----------------- | ---- | ------------------- | --------------- | ---------------------- |
| [PROJECT.md](/Users/Zer0pa/DM3/restart/.gpd/PROJECT.md) | project contract | Defines the governing objective, in-scope/out-of-scope boundary, and top acceptance posture | read and preserve | `01-01` plan, `01-02` plan, verification |
| [REQUIREMENTS.md](/Users/Zer0pa/DM3/restart/.gpd/REQUIREMENTS.md) | requirements | Tells Phase 01 exactly which mapping requirements it must satisfy | use as check matrix | `01-01` plan, verification |
| [ROADMAP.md](/Users/Zer0pa/DM3/restart/.gpd/ROADMAP.md) | roadmap | Fixes the phase boundary: Phase 01 maps and freezes; Phase 2+ execute replays | keep phase scope narrow | both plans, state updates |
| [01-CONTEXT.md](/Users/Zer0pa/DM3/restart/.gpd/phases/01-claim-map-and-contract-reset/01-CONTEXT.md) | user constraints | Lists required outputs, non-goals, and stop/rethink conditions | treat as sovereign | both plans |
| [TEST_REFERENCE_STATUS.md](/Users/Zer0pa/DM3/restart/docs/recovery/TEST_REFERENCE_STATUS.md) | prior artifact | Current partial claim-family map and prohibition on citing unmapped `Txx` labels | extend, do not bypass | `01-01` plan, verification |
| [TESTING_PROTOCOL.md](/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/TESTING_PROTOCOL.md) | recovered deterministic protocol | Strongest source-backed definition of canonical batteries, ledgers, and governance evidence | use as primary executable anchor | `01-01` mapping, later Phase 2+ battery specs |
| [AGENT_GUIDE.md](/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f/AGENT_GUIDE.md) | concrete execution guide | Gives concrete CLI commands and outputs that can anchor claim families and later device planning | map claims to these commands and outputs where justified | `01-01` mapping, Phase 2/4 planning |
| [TRAINING_DOC_HYPOTHESES.md](/Users/Zer0pa/DM3/restart/docs/restart/TRAINING_DOC_HYPOTHESES.md) | hypothesis frame | Reduces the manifesto/training-doc story into explicit hypotheses and fallback identities | use to label branches, not to prove claims | `01-02` contract reset, later branch creation |
| [GPD_OPERATING_MAP.md](/Users/Zer0pa/DM3/restart/docs/restart/GPD_OPERATING_MAP.md) | workflow governance | Defines which GPD commands matter now and the order in which to use them | reuse its command logic | `01-02` contract reset |
| [HYPOTHESIS_BRANCH_REGISTER.md](/Users/Zer0pa/DM3/restart/docs/restart/HYPOTHESIS_BRANCH_REGISTER.md) | branch / battery governance | Already distinguishes true hypothesis alternatives from battery classes and sweeps | enforce and refine | `01-02` contract reset, later branching |
| [HARDWARE_LANE_BASELINE.md](/Users/Zer0pa/DM3/restart/docs/restart/HARDWARE_LANE_BASELINE.md) | hardware baseline | Separates confirmed RM10 facts from speculative NPU claims | use only for lane scoping | `01-02` contract reset, Phase 4 planning |

**Missing or weak anchors:** There is no `.gpd/research/SUMMARY.md` in the restart project yet, so there is no project-level research summary to inherit. There is also still no one-to-one source-backed `T01-T236` registry, which is exactly why Phase 01 exists. The hardware baseline is strong enough for lane scoping, but not for any performance or correctness claim.

## Conventions

| Choice | Convention | Alternatives | Source |
| ------ | ---------- | ------------ | ------ |
| Claim status vocabulary | `mapped`, `collapsed`, `unmapped`, `retired` | binary pass/fail | [01-CONTEXT.md](/Users/Zer0pa/DM3/restart/.gpd/phases/01-claim-map-and-contract-reset/01-CONTEXT.md) |
| Evidence hierarchy | source + protocol + ledger outrank prose and images | narrative-first interpretation | [PROJECT.md](/Users/Zer0pa/DM3/restart/.gpd/PROJECT.md), [TEST_REFERENCE_STATUS.md](/Users/Zer0pa/DM3/restart/docs/recovery/TEST_REFERENCE_STATUS.md) |
| Branch rule | branch only when the scientific or architectural story changes | branch per hardware lane or seed | [HYPOTHESIS_BRANCH_REGISTER.md](/Users/Zer0pa/DM3/restart/docs/restart/HYPOTHESIS_BRANCH_REGISTER.md) |
| Battery rule | micro / medium / long are run classes under a fixed hypothesis | separate branch per run class | [HYPOTHESIS_BRANCH_REGISTER.md](/Users/Zer0pa/DM3/restart/docs/restart/HYPOTHESIS_BRANCH_REGISTER.md) |
| Sweep rule | seeds, thresholds, precisions, windows, and durations are parameter sweeps unless they imply a different explanation | treat every numeric variant as a new hypothesis | [GPD_OPERATING_MAP.md](/Users/Zer0pa/DM3/restart/docs/restart/GPD_OPERATING_MAP.md) |
| Hardware rule | RM10 CPU/GPU facts can scope later experiments; NPU remains optional until tooling is proven | assume NPU authority because hardware is present | [HARDWARE_LANE_BASELINE.md](/Users/Zer0pa/DM3/restart/docs/restart/HARDWARE_LANE_BASELINE.md) |

**CRITICAL:** All planning below uses these conventions. If a later phase wants to promote a sweep or hardware difference into a branch, it must explain the new scientific story, not just the new setting.

## Mathematical Framework

### Key Equations and Starting Points

For this phase, the formal starting points are decision rules rather than physics equations.

| Rule / Definition | Name / Description | Source | Role in This Phase |
| ----------------- | ------------------ | ------ | ------------------ |
| `status(T_i) ∈ {mapped, collapsed, unmapped, retired}` | mandatory manifesto-label classification | [01-CONTEXT.md](/Users/Zer0pa/DM3/restart/.gpd/phases/01-claim-map-and-contract-reset/01-CONTEXT.md) | core output schema for `01-01` |
| `mapped(T_i) => locator(T_i) = {path, protocol or command, expected evidence}` | mapped claims need concrete locators | [REQUIREMENTS.md](/Users/Zer0pa/DM3/restart/.gpd/REQUIREMENTS.md) | prevents narrative-only mappings |
| `branch(H) allowed only if H changes the scientific or architectural story` | branch-governance predicate | [HYPOTHESIS_BRANCH_REGISTER.md](/Users/Zer0pa/DM3/restart/docs/restart/HYPOTHESIS_BRANCH_REGISTER.md) | prevents premature branch explosion |
| `battery(B) = {purpose, duration class, lane, expected evidence}` | run-class definition | [HYPOTHESIS_BRANCH_REGISTER.md](/Users/Zer0pa/DM3/restart/docs/restart/HYPOTHESIS_BRANCH_REGISTER.md) | keeps batteries separate from hypotheses |
| `sweep(S) = parameter variation inside a fixed hypothesis and battery` | parameter-sweep definition | [GPD_OPERATING_MAP.md](/Users/Zer0pa/DM3/restart/docs/restart/GPD_OPERATING_MAP.md) | prevents false branching |
| `hardware_fact(H) => lane_scope(H), not correctness(H)` | hardware-scope guardrail | [HARDWARE_LANE_BASELINE.md](/Users/Zer0pa/DM3/restart/docs/restart/HARDWARE_LANE_BASELINE.md) | stops phone facts from being mistaken for scientific evidence |

### Required Techniques

| Technique | What It Does | Where Applied | Standard Reference |
| --------- | ------------ | ------------- | ------------------ |
| Manifesto label extraction | Enumerates every downstream-relevant `Txx` citation and claim family | `01-01` | [GEOMETRY_FIRST_MANIFESTO.md](/Users/Zer0pa/DM3/restart/docs/reference/GEOMETRY_FIRST_MANIFESTO.md), [TEST_REFERENCE_STATUS.md](/Users/Zer0pa/DM3/restart/docs/recovery/TEST_REFERENCE_STATUS.md) |
| Source-locator audit | Requires every mapped row to carry a real path and executable or ledger reference | `01-01` | [TESTING_PROTOCOL.md](/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/TESTING_PROTOCOL.md), [AGENT_GUIDE.md](/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f/AGENT_GUIDE.md) |
| Family collapse with justification | Collapses many manifesto labels onto one recovered protocol only when the observable is genuinely shared | `01-01` | [TEST_REFERENCE_STATUS.md](/Users/Zer0pa/DM3/restart/docs/recovery/TEST_REFERENCE_STATUS.md) |
| Carry-forward contract freezing | Writes what later phases may cite, execute, or branch on | `01-02` | [PROJECT.md](/Users/Zer0pa/DM3/restart/.gpd/PROJECT.md), [ROADMAP.md](/Users/Zer0pa/DM3/restart/.gpd/ROADMAP.md) |
| Hardware-scope classification | Tags confirmed RM10 capabilities versus speculative ones | `01-02` | [HARDWARE_LANE_BASELINE.md](/Users/Zer0pa/DM3/restart/docs/restart/HARDWARE_LANE_BASELINE.md) |

### Approximation Schemes

| Approximation / Abstraction | Regime of Validity | Main Risk | Alternative if Invalid |
| --------------------------- | ------------------ | --------- | ---------------------- |
| Claim-family collapse | Valid only when multiple `Txx` labels truly share one observable and one evidence path | hides distinct failure modes | split the family back into separate rows |
| Hardware capability inference from ADB facts | valid for lane planning only | overclaiming device performance or correctness | defer to Phase 4 replay evidence |
| Training-doc hypothesis reuse | valid for naming hypotheses and pivots | smuggling prose into evidence | keep it in branch framing only |

## Standard Approaches

### Ranked Comparison

| Rank | Approach | Why Use It | Main Strength | Failure Mode | When to Switch |
| ---- | -------- | ---------- | ------------- | ------------ | -------------- |
| 1 | Anchor-first claim reduction | Start from strong executable anchors and map manifesto labels downward onto them | strongest anti-folklore discipline | may leave many labels unmapped | if manifesto-first mapping produces unsupported guesses |
| 2 | Manifesto-first registry build with anchor backfill | Useful for complete `Txx` coverage and gap accounting | best coverage of the narrative surface | can tempt weak mappings | use only after anchor inventory is clear |
| 3 | Hypothesis-first semantic clustering | Useful for grouping hybrid-only or philosophy-heavy claims | helps define later branches and retirements | weak for evidence mapping | use only for rows already known to be weak or unrecovered |

### Approach 1: Anchor-First Claim Reduction (RECOMMENDED)

**What:** Begin from the strongest recovered artifacts, then ask which manifesto labels they can honestly support.

**Why standard here:** The restart objective is to reduce inherited narrative to recoverable evidence. That favors the recovered deterministic protocol and concrete CLI guide over broad manifesto prose.

**Key steps:**

1. Extract the downstream-relevant `Txx` labels from the manifesto and current restart docs.
2. Build an anchor inventory from the Genesis protocol, agent guide, and source-backed recovered workspace.
3. Map each `Txx` label to a concrete locator tuple or mark it `collapsed`, `unmapped`, or `retired`.
4. Record why each mapping is valid, including what evidence would later verify it.
5. Freeze which claims later phases may cite as evidence and which remain hypothesis-only.

**Known difficulties at each step:**

- Step 1: manifesto labels may mix observables, philosophy, and hardware claims in one cluster.
- Step 3: the temptation will be to map by conceptual similarity instead of by source-backed evidence path.
- Step 5: contract-writing often drifts into architecture desire; keep it tied to the mapped matrix.

### Approach 2: Manifesto-First Registry Build With Anchor Backfill (FALLBACK)

**What:** Enumerate all relevant `Txx` labels first, then backfill them with anchors, gaps, or retirements.

**When to switch:** Use this if the project needs full label coverage before the anchor inventory is complete, or if later planning keeps citing labels that the anchor-first method did not surface.

**Caution:** This approach is higher-risk because it invites speculative one-to-one mappings. Every backfilled mapping must still satisfy the locator rule.

### Approach 3: Hypothesis-First Semantic Clustering (LIMITED USE)

**What:** Group claims under hypothesis families such as geometry artifact, field-computation manifold, structure-first memory, or transformer-hybrid roles.

**When to use:** Only after a label is already known to be weak, hybrid-only, or too abstract for a clean protocol mapping.

**Caution:** This is for branch governance and retirement logic, not for proving claims.

## Existing Results to Leverage

- [TEST_REFERENCE_STATUS.md](/Users/Zer0pa/DM3/restart/docs/recovery/TEST_REFERENCE_STATUS.md) already provides a useful partial family structure: determinism/stability, geometry/topology/holography, scaling/hardware/precision, reproducibility/governance, and clearly unmapped later labels.
- [TESTING_PROTOCOL.md](/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/TESTING_PROTOCOL.md) gives the strongest source-backed observables for later mapping: canonical hashes, `--test-battery`, `--lineage-batch`, `audit/report.json`, and the requirement for exact ledger comparison across platforms.
- [AGENT_GUIDE.md](/Users/Zer0pa/DM3/recovery/Zer0paMk1-Genesis-Organism-Executable-Application-27-Oct-2025/00_GENESIS_ORGANISM/snic_workspace_a83f/AGENT_GUIDE.md) supplies concrete executable commands and file outputs that are suitable mapping targets and later device-lane specifications.
- [TRAINING_DOC_HYPOTHESES.md](/Users/Zer0pa/DM3/restart/docs/restart/TRAINING_DOC_HYPOTHESES.md) already separates stronger surviving hypotheses from weaker or unproven ones. Reuse that separation instead of inventing a new philosophical taxonomy.
- [HYPOTHESIS_BRANCH_REGISTER.md](/Users/Zer0pa/DM3/restart/docs/restart/HYPOTHESIS_BRANCH_REGISTER.md) already contains the right separation between branches, battery classes, and execution lanes. Phase 01 should freeze and slightly refine it, not replace it.
- [HARDWARE_LANE_BASELINE.md](/Users/Zer0pa/DM3/restart/docs/restart/HARDWARE_LANE_BASELINE.md) confirms enough about RM10 Pro to plan later CPU and GPU bring-up without claiming replay success or NPU support.

## Don't Re-Derive

- Do not re-prove the manifesto from prose, images, or conceptual sympathy.
- Do not run Phase 02 baseline recovery inside Phase 01 just to feel progress; Phase 01 should map and freeze, not narrate a replay.
- Do not create new architecture branches before the mapping and contract reset exist.
- Do not treat the training docs as executable authority.
- Do not turn hardware availability into a correctness or novelty claim.

## Computational Tools

| Tool / Method | Use in This Phase | Notes |
| ------------- | ----------------- | ----- |
| `rg` / repo text search | extract `Txx` labels, commands, ledgers, and anchor paths | primary search tool for `01-01` |
| manual matrix writing in repo markdown | claim registry and contract-reset artifacts | Phase 01 is document-heavy by design |
| GPD state / roadmap CLI | keep phase scope aligned with requirements | use for checks, not for expanding scope |
| ADB / `getprop` / Termux presence checks | refresh RM10 capability facts only | do not benchmark or infer correctness |

## Common Pitfalls

- Mapping manifesto labels to the nearest-sounding recovered artifact instead of the right one.
- Collapsing too many `Txx` labels into one family and hiding distinct observables.
- Letting hybrid-source folklore leak back in through phrases like "we probably meant".
- Treating battery classes as separate theories.
- Treating device-lane differences as architecture branches before they actually imply different explanations.
- Letting RM10 hardware enthusiasm turn Phase 01 into premature acceleration work.
- Confusing good governance artifacts with scientific passes; Phase 01 prepares proof, it does not yet produce it.

## Validation Strategies

| Check | What It Verifies | How To Apply In Phase 01 |
| ----- | ---------------- | ------------------------ |
| Coverage check | every downstream-cited `Txx` label is classified | compare manifesto and restart docs against the registry |
| Locator audit | every mapped row has a concrete path and command/protocol or ledger reference | sample rows and open the cited anchor |
| Collapse audit | collapsed families do not hide distinct observables | require a short collapse rationale per family |
| Proxy audit | no prose/image-only evidence survives as mapped | reject rows without source-backed locators |
| Branch-governance audit | hypothesis branches are reserved for story changes | verify that seeds, durations, lanes, and precisions stay under batteries/sweeps |
| Hardware-scope audit | phone facts only shape lane planning | tag each hardware statement as confirmed, plausible, or speculative |
| Ready-to-plan gate | Phase 01 outputs are sufficient for planning later phases | confirm mapped matrix, carry-forward contract, branch rules, and battery taxonomy exist together |

## Branches vs Batteries vs Parameter Sweeps

### Hypothesis branches

Create a branch only when the scientific story changes. The current serious candidates are already named in [HYPOTHESIS_BRANCH_REGISTER.md](/Users/Zer0pa/DM3/restart/docs/restart/HYPOTHESIS_BRANCH_REGISTER.md):

- exact geometry artifact
- field-computation manifold
- structure-first scientific memory
- boundary transformer hybrid
- center model hybrid
- nodewise transformer hybrid
- training-regime pivot
- device-lane hypothesis, but only if device behavior implies a different scientific interpretation rather than just a different execution lane

### Battery classes

Battery classes are execution packages, not worldviews:

- micro-batteries for fast falsification, regression checks, and lane bring-up
- medium batteries for local hypothesis checks and curriculum slices
- long batteries for thermal behavior, cross-platform replay, and honest falsification

Phase 01 should define their taxonomy and carry-forward expectations, but it should not yet run the long batteries.

### Parameter sweeps

Parameter sweeps stay inside one hypothesis and one battery class. Examples:

- seed changes
- precision changes
- window size or run-count changes
- reduction-order or checkpoint cadence changes
- CPU versus GPU lane under the same fixed hypothesis, unless that difference starts implying a different causal story

If a sweep outcome would force a different explanation of what DM3 is, then it graduates into a branch candidate later. Until then, it remains a sweep.

## RM10 Pro Hardware Examination: How It Should Inform Phase 01

Confirmed from the current hardware baseline:

- device `NX789J`
- Android `15`
- `arm64-v8a`
- Adreno graphics path
- about `23.66 GB` RAM visible to Linux
- about `742 GB` available on `/sdcard`
- Termux installed

This is enough to justify the following Phase 01 planning conclusions:

- RM10 CPU is a real future bring-up lane.
- RM10 GPU is a plausible future acceleration lane.
- storage and memory are not immediate blockers for planned micro-batteries and some longer later runs.
- NPU-assisted execution remains unproven and must stay optional.

This is **not** enough to justify the following claims:

- that RM10 Pro is already an authority lane
- that GPU or NPU execution is deterministic
- that mobile execution proves the manifold thesis
- that hardware fit implies the training or geometry story is correct

So Phase 01 should use hardware examination only to write a later lane plan and to prevent fake assumptions, not to elevate or demote any manifesto claim directly.

## Risks That Must Be Planned Around

- **R1: registry drift risk**. The planner may create a neat registry that quietly imports unsupported one-to-one mappings.
- **R2: folklore contamination risk**. Missing hybrid source may leak in through memory, compiled-residue interpretation, or conceptual overreach.
- **R3: branch explosion risk**. Early branching can fragment the project before the mainline claim boundary is stable.
- **R4: hardware distortion risk**. The phone can become a false organizing principle if capability facts are mistaken for evidence.
- **R5: collapse error risk**. Over-collapsing `Txx` labels can erase real failure modes.
- **R6: governance-as-success risk**. Good documents can masquerade as scientific progress if Phase 02 and later acceptance gates are not kept sovereign.

## What Must Be Planned Before Branching

Before any `$gpd-branch-hypothesis` use, the mainline must have:

1. A Phase 01 registry that classifies every downstream-cited `Txx` label.
2. A carry-forward rule stating which labels may be cited as source-backed evidence and which remain hypothesis-only.
3. A clear separation between recoverable baseline claims and unrecovered hybrid claims.
4. A stable battery taxonomy covering micro, medium, and long runs across Mac and RM10 lanes.
5. A written branch gate explaining why a future alternative is a different scientific story rather than a sweep.
6. A hardware-scope note that marks RM10 CPU/GPU as planning lanes and NPU as optional until proven.

If any of those are missing, branching is premature and should be refused.

## Recommended Planning Skeleton

### Plan 01-01: Build the manifesto test-reference matrix with source locators and gaps

Use the anchor-first approach.

Required outputs:

- updated `Txx` registry
- locator tuples for mapped claims
- explicit collapse justifications
- explicit unmapped or retired rows

### Plan 01-02: Freeze the skeptical restart contract and carry-forward set

Use the mapped matrix from `01-01` to write:

- the source-backed versus hybrid-only boundary
- branch-versus-battery-versus-sweep governance
- the battery hierarchy for later phases
- the hardware-scope rule for RM10 Pro

The planner should not create execution work in Phase 01 beyond what is needed to inspect anchors and refresh the hardware baseline facts.
