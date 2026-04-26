# RM10 Width-Boundary Observable Contract

Last refreshed: `2026-04-15`

## Purpose

Define the narrowest honest observable family for same-family width-boundary
replay on the top-level `/data/local/tmp/dm3_runner` surface.

This contract is narrower than the older resonance framing. It asks only what
the decisive replay boundary actually is.

## Anchor Tuple

The decisive per-row tuple is:

- `delta_E`
- `coherence`
- completion class
- receipt path and receipt size

Completion class is one of:

- `completed`
- `timeout`
- `zero_byte_receipt`
- `other_failure`

## Drift Tuple

The decisive drift family is:

- change in `cpu_b` completion class when row timeout is increased
- change in receipt survival on the decisive row
- difference between full replay and isolated follow-up replay
- thermal or process-state excursions that correlate with the decisive row

## Telemetry Context

The following are mandatory context, not signal by themselves:

- battery level and battery temperature
- thermal status
- load average
- runner snapshot
- exact command, cwd, and row set

## Admissible Outcome Classes

- `wrapper_ceiling_relaxed`
- `late_session_hang_retained`
- `session_width_sensitive`
- `receipt_corruption_unresolved`
- `unresolved`

## Lane And Family Rule

This phase stays on one family only:

- binary: `/data/local/tmp/dm3_runner`
- cwd: `/data/local/tmp`
- row family: top-level same-family `cpu_a/gpu_a/gpu_b/cpu_b`

The isolated follow-up replay is admissible only if it uses the same binary and
cwd and is treated as a bounded diagnostic, not a new family.

## Abstain Rules

Return `ABSTAIN` or `UNRESOLVED` if any of the following happen:

- decisive row receipts remain missing or zero-byte on both primary and
  follow-up replay
- the replay surface drifts off the top-level family
- the follow-up replay is not comparable to the primary replay
- telemetry is too thin to separate timeout from receipt corruption

## What This Phase May Not Claim

This phase may not claim:

- chamber science success
- heterogeneous role partition success
- NPU progress
- a new authority lane

It may only sharpen or collapse the retained same-family width-boundary story.
