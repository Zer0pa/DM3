# Thermal Baseline Refresh

Last refreshed: `2026-04-05`

## Purpose

Refresh the RM10 thermal and memory startup baseline from live evidence without
pretending that a startup probe is a serious run.

## Sensor Priority

Use the same precedence locked by
`docs/restart/phase_01_2_3_1_rm10_primary_platform_20260405/THERMAL_AND_CHECKPOINT_POLICY.md`:

1. `Thermal Status`
2. HAL temperatures from `dumpsys thermalservice`
3. cached temperatures as advisory only

## Retained Baseline Anchors

### Preflight anchor

From `artifacts/phase_01_2_3_1_rm10_preflight_20260405/`:

- AC powered: `true`
- battery level: `80`
- battery temperature: `29.0 C`
- `Thermal Status`: `0`
- HAL skin: about `31.532 C`
- `MemAvailable`: `13909884 kB`

### Governed `F1` anchor run

From `artifacts/phase_01_2_3_2_f1_anchor_20260405/`:

- battery pre and post: `31.0 C`
- `Thermal Status` pre and post: `0`
- HAL skin pre and post: `33.774 C`
- `MemAvailable` sample: `13556864 kB`

## Live Startup Snapshot On `2026-04-05`

Re-verified live in this session:

| Metric | Live value |
| --- | --- |
| AC powered | `true` |
| battery level | `70` |
| battery temperature | `29.0 C` |
| `Thermal Status` | `0` |
| HAL skin | `32.529 C` |
| HAL GPU range | `33.3 C` to `33.7 C` |
| HAL `nsp*` range | `33.6 C` to `34.3 C` |
| `MemAvailable` | `13675052 kB` |

## Cached-vs-HAL Split Reconfirmed

The live thermal dump still shows cached temperatures far above the HAL sample,
for example:

- cached skin `45.987 C`
- cached `nsp0` `48.2 C`
- cached GPU values `50.0 C` to `58.5 C`

At the same time, HAL reports nominal current temperatures:

- skin `32.529 C`
- `nsp0` `33.9 C`
- GPU values `33.3 C` to `33.7 C`

This confirms the branch rule: cached values are advisory and must not be used
as the startup gate.

## Entry-Gate Reading

Against the current branch gates:

- setup-probe thermal gate: `PASS`
- serious-run thermal and memory gate: temperature and memory values are inside
  the retained thresholds

What is still missing is not thermal headroom. What is missing is a fresh
run-identity and checkpoint declaration for any new serious run.

## Practical Consequences

- the phone is currently in a nominal thermal state for startup
- current live temperatures are close to the retained preflight envelope and
  cooler than the retained governed `F1` run envelope
- battery level has dropped from the retained preflight `80` to live `70`, but
  that is not itself a declared block
- a future serious run must still capture fresh pre and post battery, thermal,
  and memory files into a repo-retained artifact root before the output is
  cited

## Missing Retained Startup Evidence

This refresh is based on live shell output observed during startup.
No new repo-retained telemetry bundle was created for the startup probe itself.

That means the branch currently has live startup confirmation, but not a fresh
startup artifact root that a later operator can inspect offline.
