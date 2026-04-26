# RM10 Lane Contrast Ledger

Plan: `01.2.3.4.1.1-05`

Classification: `explicit abstain`

Lane verdict: `no usable lane`

Status: `battery not admissible`

## Gate Input

- `docs/restart/RM10_PROPERTY_MAP.md` closed Wave 3 as an explicit no-signal
  stop and stated that no property family is available to carry into downstream
  batteries.
- `docs/restart/RM10_SAME_FAMILY_HANDOFF_TRUTH_LEDGER.md` closed Wave 4 as an
  explicit abstain and stated that no same-family property-preservation battery
  is admissible on current evidence.
- Phase context says Battery E runs only when the alternative lane is both
  callable and interpretable.
- `docs/restart/HARDWARE_LANE_BASELINE.md` confirms CPU and GPU hardware
  presence on RM10, but presence alone does not create a usable comparison
  lane.

## Missing Anchor Property

No mapped property exists that is both:

- carried forward from the cleaned `F1` discovery lane
- measurable on both sides of one declared CPU-versus-accelerator comparison
- distinct from receipt emission, runtime length, thermal steadiness, or
  hardware inventory

Explicitly absent on current evidence:

- a second retained semantic family on cleaned `F1`
- any threshold, persistence, hysteresis, recovery, or boundary property opened
  by Wave 3
- any preserved same-family observable on the official top-level `F2`
  CPU/GPU/GPU/CPU bracket

## Candidate Lane Pair Review

### Pair A: cleaned `F1` CPU versus accelerator-bearing `F2`

Rejected.

Why:

1. `RUNBOOK_RM10_CPU.md` defines the governed control lane on cleaned `F1`.
2. `RUNBOOK_RM10_GPU.md` defines the only current callable GPU-backed path on
   the bundled-residue `F2` `dm3_runner` harmonic family.
3. That would compare two different families, not one mapped property under one
   matched boundary. It would splice governed `F1` control rhetoric to
   residue-family `F2` feasibility and violate the plan's interpretation gate.

### Pair B: same-family `F2` CPU versus GPU on the official top-level bracket

Rejected.

Why:

1. Wave 4 already records that no property was available to carry into the
   same-family battery.
2. The retained official `F2` rerun remains an abstain-level localization
   packet: low `cpu_a`, high `gpu_a`, low `gpu_b`, then missing `cpu_b`
   custody after timeout.
3. A lane contrast cannot start from a same-family surface that still fails to
   preserve one honest observable under its own locked bracket.

## Why Lane Contrast Is Not Interpretable Now

1. Wave 3 produced no property to contrast. The cleaned `F1` lane retained one
   semantic receipt family and nothing stronger.
2. The only accelerator-bearing callable family is still `F2`, which remains
   residue-feasibility evidence rather than a common scientific family with
   cleaned `F1`.
3. The only same-family CPU/GPU bracket on `F2` is still unstable and does not
   close receipt custody.
4. Hardware presence, thermal channels, or faster execution would violate the
   forbidden proxies `fp-hardware-presence` and `fp-speed-is-behavior`.

## Strongest Disconfirming Observation

The branch still cannot point to one property that survives both of the
required gates at once: Wave 3 found no carryable property on cleaned `F1`, and
the retained same-family `F2` bracket still loses the closing `cpu_b` anchor
before any CPU-versus-accelerator contrast can be interpreted.

## Packet Status

- no `artifacts/phase_01_2_3_4_1_1_lane_contrast_*/` packet was created
- no real lane comparison was run
- no speed, utilization, or heat delta was promoted into behavior

## Reopen Conditions

Reopen Battery E only if all of the following become true first:

1. A later discovery cycle surfaces one concrete mapped property instead of the
   current no-signal stop.
2. That property is measurable on a CPU lane and one accelerator lane within a
   single declared family and matched comparison boundary.
3. The alternative lane is callable with retained commands, cwd, telemetry, and
   repo-custodied outputs on both sides of the comparison.
4. The comparison can end in a behavior verdict grounded in the property
   itself, not in runtime, hardware presence, or opaque internal accelerator
   activity.

## Verdict

Verdict: `ABSTAIN / NO USABLE LANE`

Why:

- there is no mapped property to carry from Wave 3
- there is no preserved same-family observable from Wave 4 or the retained `F2`
  reruns
- the only callable accelerator path remains either cross-family or unstable,
  so any lane contrast today would be mythology rather than evidence
