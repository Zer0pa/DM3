# RM10 Resonance-Chamber Observable Contract

Last refreshed: `2026-04-06`

## Purpose

Define the smallest honest observable family for the RM10 resonance-chamber and
heterogeneity-first battery.

This contract is deliberately narrower than the training document. It uses only
what the current RM10 surfaces can actually emit or retain.

## Current-Surface Observable Family

### Anchor Observable

The primary anchor is the row-wise tuple:

- `delta_E`
- `coherence`
- completion class
- receipt-bearing output size and path

Completion class is one of:

- `completed`
- `timeout`
- `zero_byte_receipt`
- `other_failure`

### Drift Observable

The primary drift family is:

- low/high cluster flip across rows or repeats
- closing-row timeout or zero-byte receipt dropout
- lane-marker mismatch
- thermal-correlated collapse

Lane markers:

- CPU row: `cpu_forced`
- GPU-backed row: `gpu_init`

### Telemetry Observables

These do not count as signal by themselves, but they are mandatory context:

- battery level and battery temperature
- thermal status
- runner snapshot
- load average
- exact command and cwd

## Training-Document Terms Versus Phase Terms

| Training-document term | Phase-local status | Honest handling |
| --- | --- | --- |
| energy descent | partially exposed | use `delta_E` only |
| coherence | exposed | use retained `coherence` field |
| ECC | not exposed | background concept only |
| Laplacian tension | not exposed | background concept only |
| isotropy | not exposed | background concept only |
| synchronization | not exposed directly | only use as interpretive hypothesis if repeatable lane-sensitive structure appears |
| projection or priming | maybe exposed if NPU path exists | requires callable path evidence |

## Lane Comparison Rules

### CPU Control

The CPU control lane is the governed `F1` Genesis packet.

It is used for:

- environment sanity
- run identity discipline
- device health baseline

It is not the same observable family as the top-level `F2` residue bracket, so
it is a control anchor, not a same-family equivalence claim.

### CPU/GPU Coupled Bracket

The top-level `F2` CPU/GPU/GPU/CPU bracket is the only live lane family that
currently exposes a usable coupled-lane comparison surface on the attached
device.

The phase may compare:

- row class
- `delta_E`
- `coherence`
- completion behavior
- receipt survival
- thermal context

The phase may not claim:

- same-family preserved truth
- governed authority
- explicit heterogeneous pass

without stronger evidence than this phase is designed to produce.

### NPU Path

The NPU path is admissible only if:

- a user-space executable or callable surface exists
- the surface can be invoked directly and retained
- the result can be localized to that path rather than to infrastructure
  inventory

Otherwise the NPU verdict is `ABSTAIN`.

## Phase Verdict Classes

### `signal_survives`

Use only if the battery shows a repeatable lane-sensitive change in the anchor
tuple that survives direct artifact checks.

### `artifact_collapse`

Use if the apparent effect reduces to:

- timeout ceiling
- thermal collapse
- stale-path substitution
- missing or zero-byte receipts
- inventory-only NPU evidence

### `abstain`

Use if:

- the lanes remain incomparable
- the battery is too thin to localize drift
- the NPU path remains non-callable
- the coupled bracket remains uninterpretable

## Forbidden Proxies

The following never count as success by themselves:

- GPU initialization
- runtime length
- thermal rise
- device marketing claims
- library or daemon presence
- prose similarity to the training document

## Contract Bottom Line

This phase is allowed to say only that:

- heterogeneity changed or did not change the measured row class
- the change survived or collapsed under direct falsification
- the NPU path is callable or remains abstain

Everything stronger stays outside the claim ceiling of this battery.
