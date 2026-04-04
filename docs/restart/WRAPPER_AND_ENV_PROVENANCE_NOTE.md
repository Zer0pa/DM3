# Wrapper And Environment Provenance Note

## Provenance Question

Which launcher, cwd, and environment assumptions are still evidenced for the
preserved bundled RM10 runner, and which stories are now residue-only?

## Retained Audit Surface

The serious archaeology pass is now mirrored under a stable repo path:

- retained audit root:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404`
- retained parser/help outputs:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/argv/*`
- retained wrapper/env outputs:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/wrappers/*`
- retained comparison tables:
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/comparisons/receipt_hashes.tsv` and
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/comparisons/receipt_hashes_combined.tsv`

Plan 02 should anchor to that repo-retained bundle, not the transient `/tmp`
source root.

## Live Launcher Contract

The only evidenced launcher contract for the current bundled binary is direct
ADB-shell invocation:

- canonical form:
  `adb shell 'cd /data/local/tmp/dm3 && ./dm3_runner ...'`
- smoke-equivalent cwd variant:
  `adb shell 'cd /data/local/tmp && ./dm3/dm3_runner ...'`

The parent-cwd variant remained observable-equivalent to the canonical bundled
cwd when absolute asset paths were supplied. It did not expose a distinct
`G2` route.

## Wrapper Provenance

### Surviving evidence

- recursive search over `/data/local/tmp/*.sh`, `/data/local/tmp/*/*.sh`, and
  `/data/local/tmp/*/*/*.sh` found no reference to `dm3_runner`,
  `/data/local/tmp/dm3`, or `exp_g2_readout`
- the retained outputs for that search now live at
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/wrappers/wrapper_refs.txt` and
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/wrappers/top_level_files.txt`
- `/data/local/tmp/dm3_termux_probe.sh` exists, but only prints Termux
  environment details and does not launch the bundled runner

### Provenance verdict

- no live wrapper survives for `/data/local/tmp/dm3/dm3_runner`
- any historical wrapper or launcher that once emitted the preserved `G2`
  outputs is now absent from the current device surface
- Plan 02 must not invent wrapper semantics, PATH shims, or Termux launch
  stories to compensate

## Environment Provenance

The live adb-shell baseline at `/data/local/tmp/dm3` was:

- `HOME=/`
- `SHELL=/bin/sh`
- `TMPDIR=/data/local/tmp`
- `PATH=/product/bin:/apex/com.android.runtime/bin:/apex/com.android.art/bin:/system_ext/bin:/system/bin:/system/xbin:/odm/bin:/vendor/bin:/vendor/xbin`

No DM3-specific environment knob was evidenced:

- no wrapper required a PATH mutation
- no `LD_*` or similar launcher variable appeared in wrapper provenance
- no device-side `DM3_ALLOW_HOST_RUN`-style override was surfaced in the
  environment or wrapper search
- the retained environment snapshot now lives at
  `/Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/wrappers/env_baseline.txt`

Because no live wrapper justified an environment dependency, no speculative env
probe was admissible under the runbook.

## Asset Provenance

The co-located bundled assets still exist at the live hash surface:

- `SriYantraAdj_v1.bin`:
  `22f4bc8fa1858bb98cce445614d498b04292f7c1b54ba2bacbe5786b969f637c`
- `RegionTags_v2.json`:
  `ecb8711466494c5d516b89096fdb8c685eb252f6b9bcae566260c6f2142e450c`
- `RegionTags_v1.bin`:
  `b5ea6d4c0d10d309a8972d602cdfe1e6b6b776c58d170951ddfa856c08948d6f`

But asset form did not recover semantics:

- default assets, explicit `RegionTags_v2.json`, absolute asset paths, and
  parent-cwd absolute paths all normalized to the same smoke canonical
  `d3e721...`

So the current provenance state is:

- live files: yes
- live `G2` routing effect from those files: no

## Operator Rule For Plan 02

Plan 02 must assume:

- direct binary launch only
- bundled cwd or the already-proved parent-cwd direct-path variant only
- default adb-shell environment only
- no wrapper resurrection
- no environment mutation unless a new surviving launcher is first evidenced

Anything broader would be redevelopment, not same-binary archaeology.
