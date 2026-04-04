# G2 Route Decision Object

```yaml
decision_version: 2
phase: 01.2.3
plan: 01
decision_timestamp_utc: 2026-04-04T20:07:25Z

binary:
  path: /data/local/tmp/dm3/dm3_runner
  sha256: d678e8d355601d13dd1608032fd5e6fdf5eaa81bdde0af5f124125ff1bcea8b1

identity_packet:
  transient_receipt_root: /tmp/dm3_phase_01_2_3_plan01_20260404T194225Z
  retained_audit_root: /Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404
  retained_serious_pass_root: /Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass
  retained_supplement_root: /Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/supplement
  retained_combined_comparison: /Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/comparisons/receipt_hashes_combined.tsv
  comet_mode: offline
  comet_experiment_key: 81886795bff24e73bd1e948f272205fa
  comet_offline_bundle: /Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/serious_pass/cometml-runs/81886795bff24e73bd1e948f272205fa.zip
  checkpoint_policy: rerun-only

route_objective:
  observable_family: g2_boundary_readout
  smoke_canonical_normalized_sha256: d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9
  smoke_canonical_run_id: t1_contraction

evaluated_same_binary_surfaces:
  smoke_equivalent:
    - id: g2_default_assets
      tuple:
        wrapper: direct
        cwd: /data/local/tmp/dm3
        env: adb_shell_baseline
        mode: inference
        task: exp_g2_readout
        assets: default_help_assets
      normalized_sha256: d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9
    - id: g2_explicit_assets_v2json
      tuple:
        wrapper: direct
        cwd: /data/local/tmp/dm3
        env: adb_shell_baseline
        mode: inference
        task: exp_g2_readout
        assets: SriYantraAdj_v1.bin + RegionTags_v2.json
      normalized_sha256: d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9
    - id: g2_abs_assets
      tuple:
        wrapper: direct
        cwd: /data/local/tmp/dm3
        env: adb_shell_baseline
        mode: inference
        task: exp_g2_readout
        assets: absolute_paths_to_bundled_assets
      normalized_sha256: d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9
    - id: g2_parent_cwd_abs_assets
      tuple:
        wrapper: direct
        cwd: /data/local/tmp
        env: adb_shell_baseline
        mode: inference
        task: exp_g2_readout
        assets: absolute_paths_to_bundled_assets
      normalized_sha256: d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9
    - id: infer_holography
      tuple:
        wrapper: direct
        cwd: /data/local/tmp/dm3
        env: adb_shell_baseline
        mode: inference
        task: holography
        assets: default_help_assets
      normalized_sha256: d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9
    - id: infer_harmonic
      tuple:
        wrapper: direct
        cwd: /data/local/tmp/dm3
        env: adb_shell_baseline
        mode: inference
        task: harmonic
        assets: default_help_assets
      normalized_sha256: d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9
    - id: infer_boundary_alignment
      tuple:
        wrapper: direct
        cwd: /data/local/tmp/dm3
        env: adb_shell_baseline
        mode: inference
        task: boundary_alignment
        assets: default_help_assets
      normalized_sha256: d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9
    - id: infer_boundary_power
      tuple:
        wrapper: direct
        cwd: /data/local/tmp/dm3
        env: adb_shell_baseline
        mode: inference
        task: boundary_power
        assets: default_help_assets
      normalized_sha256: d3e721e7f2dd8999f564b09cb5d8043fe628ad6817cd2a90e5cae0bd548c7ad9

  non_g2_live_routes:
    - id: train_holography
      class: callable_non_smoke
    - id: train_harmonic
      class: callable_non_smoke

  route_guarded:
    - id: train_exp_g2_readout
      exit_code: 1
      stderr: Error: Unknown task: exp_g2_readout
    - id: train_boundary_alignment
      exit_code: 1
      stderr: Error: Unknown task: boundary_alignment
    - id: train_boundary_power
      exit_code: 1
      stderr: Error: Unknown task: boundary_power

  wrapper_or_env_candidates:
    wrappers: []
    env_mutations: []

  string_promoted_candidates:
    - name: boundary_alignment
      provenance: /Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/supplement/strings/boundary_string_residue_from_prior_repo_extract.txt
      classification: inference_smoke_alias_plus_train_guard
    - name: boundary_power
      provenance: /Users/Zer0pa/DM3/restart/artifacts/phase_01_2_3_plan01_invocation_audit_20260404/supplement/strings/boundary_string_residue_from_prior_repo_extract.txt
      classification: inference_smoke_alias_plus_train_guard

decision:
  status: no_candidate
  approved_route_tuple: null
  plan_02_branch: retirement_only
  reason: >
    Every justified same-binary inference route, including every tested G2
    asset/cwd form, both help-listed inference tasks, and the explicit
    boundary_alignment / boundary_power supplement probes, normalized to the
    same smoke canonical d3e721.... The only non-smoke live routes are the
    help-listed train tasks, while exp_g2_readout, boundary_alignment, and
    boundary_power are explicitly rejected in train mode. No surviving wrapper
    or environment contract remains to justify a further same-binary route
    attempt.

plan_02_instructions:
  - Do not probe a second route.
  - Do not invent wrapper logic.
  - Do not mutate environment beyond the adb-shell baseline.
  - Do not escalate to GPU or NPU to compensate for the missing route.
  - Assemble exact retirement proof from the repo-retained audit bundle plus the 01.2.2 smoke control.
  - Cite the combined retained comparison table rather than the transient /tmp root.

disallowed_improvisations:
  - strings_only_task_belief
  - wrapper_resurrection_from_residue
  - speculative_env_sweep
  - source_or_binary_edit
  - gpu_first_escalation
```
