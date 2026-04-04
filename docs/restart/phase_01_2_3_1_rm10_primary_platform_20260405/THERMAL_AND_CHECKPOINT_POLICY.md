# Thermal And Checkpoint Policy

## Purpose

This document defines when RM10 branch runs may start, when they must pause,
what telemetry is primary, and how checkpoint identity must be carried through
later execution.

The branch is not allowed to manufacture evidence by heating the phone or by
losing checkpoint identity mid-comparison.

## Current Preflight Anchor

This policy is anchored to the retained preflight bundle at:

`artifacts/phase_01_2_3_1_rm10_preflight_20260405/`

Key preflight values:

- thermal status: `0`
- battery level: `80`
- battery temperature: `29.0 C`
- HAL skin temperature: `31.532 C`
- HAL GPU temperatures: about `31.4 C` to `31.8 C`
- HAL `nsp*` temperatures: about `31.2 C` to `32.0 C`
- available memory: `13909884 kB`
- device is AC powered during the captured preflight

## Sensor Trust Rule

Use thermal-service status and HAL temperatures as primary.

Cached temperatures in the same dump may be higher or stale.
They are advisory only.

Primary thermal gates for later branch work are therefore:

- `Thermal Status`
- HAL `battery`
- HAL `skin`
- HAL `GPU*`
- HAL `nsp*`

## Run Entry Gates

### Setup probes

Allowed when:

- thermal status is `0`
- no active throttling or cooling intervention is visible

### Serious or feasibility runs

Allowed only when all of the following are true:

1. thermal status is `0`
2. battery temperature is `<= 35.0 C`
3. skin temperature is `<= 38.0 C`
4. available memory is `>= 8000000 kB`
5. the exact command surface and checkpoint identity are already defined

If any of these fail, cool down or abstain.

## Warning Thresholds

Raise a warning checkpoint when any of the following occurs:

- thermal status rises above `0`
- battery temperature exceeds `38.0 C`
- battery temperature rises by `>= 4.0 C` from the run baseline
- skin temperature exceeds `42.0 C`
- skin temperature rises by `>= 5.0 C` from baseline
- available memory drops below `6000000 kB`

At warning level:

- finish the current bounded segment only if the comparable observable is
  still intact
- write a checkpoint immediately
- do not start the next segment until status returns to safe range

## Hard Stop Thresholds

Stop the run immediately when any of the following occurs:

- thermal status reaches `2` or higher
- battery temperature exceeds `42.0 C`
- skin temperature exceeds `45.0 C`
- available memory drops below `4000000 kB`
- an accelerator-specific run produces heat without a comparable observable or
  receipt
- checkpoint identity is lost or contradicted

These stop values are deliberately well below the device HAL hot-throttle
thresholds.
Branch evidence ends before the phone's own emergency boundaries.

## Snapshot Cadence

### Setup probes

Capture:

- battery pre and post
- thermal pre and post

### Feasibility probes

Capture:

- battery pre and post
- thermal pre and post
- memory pre and post

### Serious runs

Capture:

- battery pre and post
- thermal pre and post
- memory pre and post
- one checkpoint snapshot after the first load-bearing result
- one checkpoint snapshot before any downstream fanout or lane transition
- one snapshot on every resume event

## Checkpoint Identity Contract

Every checkpoint must bind the run to the same scientific story.

Required checkpoint fields:

- `checkpoint_id`
- `checkpoint_parent`
- `run_id`
- `phase`
- `plan`
- `observable_family`
- `device_lane`
- `compute_lane`
- `build_class`
- `command_hash`
- `cwd`
- `env_hash`
- current receipt path or explicit absence
- thermal snapshot path
- battery snapshot path

## Resume Rules

Resume is allowed only when all of the following remain unchanged:

- observable family
- compute lane
- command semantics
- build class
- working directory semantics

If any of those change, start a new run ID.
Do not splice incompatible segments into one comparison narrative.

## Lane Transition Rule

Changing from CPU to GPU, GPU to NPU, or any single lane to heterogeneous
requires:

1. a closing checkpoint on the prior lane
2. a fresh entry-gate check on the next lane
3. explicit confirmation that the observable family is unchanged

If the observable changes, it is a new battery, not a lane transition.

## Cooldown Rule

After any warning or hard stop:

- do not restart the same battery until thermal status returns to `0`
- require battery and skin temperatures to return within `2.0 C` of their
  run-entry baselines, or explicitly record an abstain decision

## Meaningless Heat Rule

Stop and record a blocker if:

- the device gets hotter,
- but no new comparable receipt, checkpointed state, or observable is created

The branch is not allowed to treat warm silicon as progress.

## Bottom Line

The RM10 branch may run hot only when it stays interpretable.
If thermal motion outruns observable integrity or checkpoint identity, the run
stops and the branch records the stop honestly.
