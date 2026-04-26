# Observable Contract Note

Last refreshed: `2026-04-05`

## Purpose

Define the minimal honest observable contract for phase `01.2.3.4.1` before any
fresh official same-family rerun is allowed to speak about preserved
observability.

This note is not proof of survival. It only freezes what counts.

## Anchor Observable

Anchor observable: the same-session CPU bracket on the official same-family
`F2` row schema, measured only from receipt-bearing fields already surfaced in
the retained packets:

- `delta_E`
- `coherence`
- `decision`
- `duration_ms`
- lane marker showing the row was CPU-forced

On the retained older stable family packet
`artifacts/phase_01_2_3_2_f2_harmonic_repeat_20260405/metrics/summary.tsv`,
the CPU bracket is tight:

- `cpu_a`: `delta_E=76.0338`, `coherence=0.877201`
- `cpu_b`: `delta_E=76.0675`, `coherence=0.877085`

On the retained official same-family instability packet
`artifacts/rm10_f2_outlier_20260405T171018Z/metrics/summary.tsv`, that CPU
anchor breaks:

- `cpu_a`: `delta_E=88.6270`, `coherence=0.770285`
- `cpu_b`: `delta_E=75.4385`, `coherence=0.891245`

The first survival question is therefore not "did GPU run?" It is "did the CPU
anchor stay intact across the same-family session?"

## Drift Observable

Drift observable: GPU-to-CPU-bracket distance on the same receipt schema, not a
separate theory signal.

The drift observable compares:

- fresh `gpu_a` against the fresh CPU bracket
- fresh `gpu_b` against the fresh CPU bracket
- fresh `gpu_a` against fresh `gpu_b`

using the same fields:

- `delta_E`
- `coherence`
- `decision`
- `duration_ms`
- lane markers

The retained official instability packet shows that this drift is only
meaningful after the CPU bracket holds. In the unstable packet, the GPU rows
split across the two broken CPU values instead of clustering against a stable
anchor.

## Accept / Abstain Rule

`ACCEPT` only if all of the following are true on a fresh official same-family
CPU/GPU/GPU/CPU rerun of `/data/local/tmp/dm3_runner`:

1. `cpu_a` and `cpu_b` preserve one tight CPU anchor on the retained receipt
   schema.
2. `gpu_a` and `gpu_b` remain mutually consistent on that same schema.
3. both GPU rows stay inside the neighborhood of the fresh CPU anchor rather
   than alternating between two incompatible states.
4. the packet preserves the pre-handoff artifact, post-handoff artifact, and
   row-by-row custody needed to say where drift enters if drift appears.

`ABSTAIN` if any of the following are true:

- the CPU anchor breaks
- the GPU rows disagree with each other or with the CPU bracket in a way that
  cannot be localized
- the packet lacks custody strong enough to tie the observable to one same-family
  boundary
- the only apparent signal is runtime duration, utilization, filenames, or
  prose similarity

`FAIL` if the rerun cleanly preserves custody but destroys the anchor observable
across the same-family boundary.

## Current Phase State

Current status remains `ABSTAIN`.

Why:

- the retained official same-family packet is classified
  `whole_session_instability`
- the CPU anchor is not preserved across the retained CPU/GPU/GPU/CPU session
- no fresh packet has yet restored that anchor under the new `01.2.3.4.1`
  locked-identity rules

## Required Same-Family Comparisons Before Any Heterogeneous Reopen

Any fresh official same-family rerun must compare:

1. `cpu_a` vs `cpu_b`
2. `gpu_a` vs the fresh CPU bracket
3. `gpu_b` vs the fresh CPU bracket
4. `gpu_a` vs `gpu_b`
5. the fresh packet vs
   `artifacts/phase_01_2_3_2_f2_harmonic_repeat_20260405/metrics/summary.tsv`
6. the fresh packet vs
   `artifacts/rm10_f2_outlier_20260405T171018Z/metrics/summary.tsv`

No heterogeneous reopen is admissible unless that fresh same-family rerun is a
real `PASS` on this exact contract.

## Inadmissible Candidates

The following do not count as observables for this phase:

- output looked right
- `true_pass`-style filenames
- runtime duration alone
- GPU utilization alone
- GPU initialization logs alone
- prose similarity between packets

