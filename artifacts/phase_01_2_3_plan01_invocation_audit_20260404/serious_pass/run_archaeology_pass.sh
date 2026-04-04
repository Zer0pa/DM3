#!/bin/bash
set -euo pipefail
RUN_ROOT=/tmp/dm3_phase_01_2_3_plan01_20260404T194225Z
OFFLINE_DIR="$RUN_ROOT/cometml-runs"
mkdir -p "$RUN_ROOT"/{preflight,identity,telemetry,argv,strings,wrappers,cwd_env_matrix,attempts,comparisons}
mkdir -p "$OFFLINE_DIR"
RUN_ID="phase-01-2-3-plan01-archaeology-pass-20260404T194225Z"
NAME="dm3-01.2.3-G2A-rm10_hybrid-cpu-archaeology"
IDENTITY_JSON="$RUN_ROOT/identity/run_identity.json"
COMMAND_TXT="$RUN_ROOT/identity/command.txt"
CHECKPOINT_POLICY="$RUN_ROOT/identity/checkpoint_policy.txt"
CHECKPOINT_INDEX="$RUN_ROOT/identity/checkpoint_index.json"
RESUME_EVENTS="$RUN_ROOT/identity/resume_events.jsonl"
MANIFEST_JSON="$RUN_ROOT/identity/comet_manifest.json"
COMET_KEY_FILE="$RUN_ROOT/identity/comet_experiment_key.txt"
COMET_OFFLINE_FILE="$RUN_ROOT/identity/comet_offline_bundle_path.txt"

cat > "$CHECKPOINT_POLICY" <<'EOF'
rerun-only
EOF
printf '%s\n' "$OFFLINE_DIR" > "$COMET_OFFLINE_FILE"
cat > "$COMMAND_TXT" <<'EOF'
Phase 01.2.3 Plan 01 bounded same-binary archaeology pass.
All live routes are executed against /data/local/tmp/dm3/dm3_runner only.
Per-attempt commands are stored under attempts/*_command.txt.
EOF
cat > "$IDENTITY_JSON" <<EOF
{
  "run_id": "$RUN_ID",
  "name": "$NAME",
  "phase_surface": "01.2.3",
  "plan": "01",
  "workstream": "g2-invocation-surface-archaeology",
  "branch": "main",
  "battery_id": "G2A",
  "battery_class": "micro",
  "run_kind": "archaeology",
  "machine_class": "rm10_device",
  "device_lane": "rm10_hybrid",
  "compute_lane": "cpu",
  "command_surface": "dm3_runner",
  "reference_baseline": "bundled_g2_smoke_d3e721",
  "receipt_root": "$RUN_ROOT",
  "authority_metric": "governed executable sufficiency",
  "authority_status": "archaeology_only",
  "evidence_surface": "archaeology",
  "build_class": "exploratory_compiled_residue",
  "canonical_validation_mode": "not_applicable",
  "observable_family": "g2_boundary_readout",
  "comet_offline_bundle_path": "$OFFLINE_DIR",
  "checkpoint_policy": "rerun-only"
}
EOF
cat > "$CHECKPOINT_INDEX" <<'EOF'
{
  "policy": "rerun-only",
  "attempts": []
}
EOF
cat > "$RESUME_EVENTS" <<EOF
{"run_id":"$RUN_ID","resume_index":0,"checkpoint_seq":0,"phase_surface":"01.2.3","battery_id":"G2A","battery_class":"micro","branch":"main","device_lane":"rm10_hybrid","compute_lane":"cpu","command_surface":"dm3_runner","receipt_root":"$RUN_ROOT","thermal_pre_resume_path":"$RUN_ROOT/preflight/thermal_before.txt","battery_pre_resume_path":"$RUN_ROOT/preflight/battery_before.txt","comet_offline_bundle_path":"$OFFLINE_DIR","resume_reason":"new_run","operator_verdict_before_resume":"fresh archaeology pass"}
EOF
cat > "$MANIFEST_JSON" <<EOF
{
  "name": "$NAME",
  "workspace": "zer0pa",
  "project_name": "dm3",
  "tags": [
    "restart",
    "dm3",
    "phase-01-2-3",
    "battery-class-micro",
    "run-kind-archaeology",
    "authority-archaeology_only",
    "build-exploratory_compiled_residue",
    "surface-archaeology",
    "machine-rm10_device",
    "lane-rm10_hybrid",
    "g2-router",
    "bundled-runner",
    "invocation-surface"
  ],
  "parameters": {
    "authority_metric": "governed executable sufficiency",
    "phase_surface": "01.2.3",
    "workstream": "g2-invocation-surface-archaeology",
    "branch": "main",
    "battery_id": "G2A",
    "battery_class": "micro",
    "run_kind": "archaeology",
    "machine_class": "rm10_device",
    "device_lane": "rm10_hybrid",
    "compute_lane": "cpu",
    "authority_status": "archaeology_only",
    "evidence_surface": "archaeology",
    "reference_baseline": "bundled_g2_smoke_d3e721",
    "command_surface": "dm3_runner",
    "receipt_surface": "jsonl_receipts",
    "build_class": "exploratory_compiled_residue",
    "canonical_validation_mode": "not_applicable",
    "observable_family": "g2_boundary_readout"
  },
  "metrics": [
    {"name": "run/exit_code", "value": 0},
    {"name": "run/phase_outcome_code", "value": 0},
    {"name": "run/route_outcome_code", "value": 0},
    {"name": "run/verdict_code", "value": 0},
    {"name": "run/resume_count", "value": 0},
    {"name": "run/receipt_complete", "value": 0},
    {"name": "run/thermal_nominal_pre", "value": 1},
    {"name": "run/thermal_nominal_post", "value": 1}
  ],
  "others": {
    "command_text_path": "$COMMAND_TXT",
    "run_identity_path": "$IDENTITY_JSON",
    "comet_manifest_path": "$MANIFEST_JSON",
    "receipt_root": "$RUN_ROOT",
    "primary_receipt_path": "$RUN_ROOT/comparisons/receipt_hashes.tsv",
    "telemetry_root": "$RUN_ROOT/telemetry",
    "thermal_pre_path": "$RUN_ROOT/preflight/thermal_before.txt",
    "thermal_post_path": "$RUN_ROOT/telemetry/final_thermal_after.txt",
    "battery_pre_path": "$RUN_ROOT/preflight/battery_before.txt",
    "battery_post_path": "$RUN_ROOT/telemetry/final_battery_after.txt",
    "checkpoint_policy": "rerun-only",
    "checkpoint_policy_path": "$CHECKPOINT_POLICY",
    "checkpoint_index_path": "$CHECKPOINT_INDEX",
    "resume_events_path": "$RESUME_EVENTS",
    "comet_key_file": "$COMET_KEY_FILE",
    "comet_offline_bundle_path": "$OFFLINE_DIR",
    "logging_mode": "offline",
    "notes": "Bounded same-binary archaeology pass over bundled RM10 runner route surfaces."
  },
  "assets": []
}
EOF

adb devices -l > "$RUN_ROOT/preflight/adb_devices.txt"
adb shell getprop ro.product.model > "$RUN_ROOT/preflight/model.txt"
adb shell getprop ro.hardware.vulkan > "$RUN_ROOT/preflight/vulkan.txt"
adb shell 'cd /data/local/tmp/dm3 && pwd && ls -la' > "$RUN_ROOT/preflight/dm3_listing.txt"
adb shell 'cd /data/local/tmp/dm3 && sha256sum dm3_runner SriYantraAdj_v1.bin RegionTags_v2.json RegionTags_v1.bin RegionTags_v2.bin' > "$RUN_ROOT/preflight/hashes.txt"
adb shell dumpsys battery > "$RUN_ROOT/preflight/battery_before.txt"
adb shell dumpsys thermalservice > "$RUN_ROOT/preflight/thermal_before.txt"

adb pull /data/local/tmp/dm3/dm3_runner "$RUN_ROOT/strings/dm3_runner" >/dev/null
file "$RUN_ROOT/strings/dm3_runner" > "$RUN_ROOT/strings/file.txt"
strings "$RUN_ROOT/strings/dm3_runner" | rg -n 'G2|R2Contrastive|Readout|RegionTags|exp_g2|boundary|mode|task|inference|train|cpu|gpu|holography|harmonic' > "$RUN_ROOT/strings/candidate_strings.txt"

adb shell 'cd /data/local/tmp/dm3 && ./dm3_runner --help' > "$RUN_ROOT/argv/help.txt" 2>&1 || true
adb shell 'cd /data/local/tmp/dm3 && ./dm3_runner --mode inference --help' > "$RUN_ROOT/argv/help_mode_inference.txt" 2>&1 || true
adb shell 'cd /data/local/tmp/dm3 && ./dm3_runner --task exp_g2_readout --help' > "$RUN_ROOT/argv/help_task_exp_g2_readout.txt" 2>&1 || true
set +e
adb shell 'cd /data/local/tmp/dm3 && ./dm3_runner --task __bogus__ --mode inference' > "$RUN_ROOT/argv/bogus_task_inference_stdout.txt" 2> "$RUN_ROOT/argv/bogus_task_inference_stderr.txt"
printf '%s\n' "$?" > "$RUN_ROOT/argv/bogus_task_inference_exit_code.txt"
adb shell 'cd /data/local/tmp/dm3 && ./dm3_runner --mode train --task __bogus__' > "$RUN_ROOT/argv/bogus_task_train_stdout.txt" 2> "$RUN_ROOT/argv/bogus_task_train_stderr.txt"
printf '%s\n' "$?" > "$RUN_ROOT/argv/bogus_task_train_exit_code.txt"
set -e

adb shell 'find /data/local/tmp/dm3 -maxdepth 1 -type f | sort' > "$RUN_ROOT/wrappers/top_level_files.txt"
adb shell 'grep -R -n "dm3_runner\|/data/local/tmp/dm3\|exp_g2_readout" /data/local/tmp/*.sh /data/local/tmp/*/*.sh /data/local/tmp/*/*/*.sh 2>/dev/null || true' > "$RUN_ROOT/wrappers/wrapper_refs.txt"
adb shell 'sed -n "1,200p" /data/local/tmp/dm3_termux_probe.sh' > "$RUN_ROOT/wrappers/dm3_termux_probe.sh.txt" 2>&1 || true
adb shell 'cd /data/local/tmp/dm3 && env | sort' > "$RUN_ROOT/wrappers/env_baseline.txt"

ATTEMPTS_TSV="$RUN_ROOT/comparisons/receipt_hashes.tsv"
printf 'name\texit_code\tdevice_receipt\traw_sha256\tnormalized_sha256\trun_id\n' > "$ATTEMPTS_TSV"

run_attempt() {
  local name="$1"
  local remote_cwd="$2"
  local device_receipt="$3"
  local command_body="$4"
  local stdout_file="$RUN_ROOT/attempts/${name}_stdout.txt"
  local stderr_file="$RUN_ROOT/attempts/${name}_stderr.txt"
  local exit_file="$RUN_ROOT/attempts/${name}_exit_code.txt"
  local cmd_file="$RUN_ROOT/attempts/${name}_command.txt"
  local pull_file="$RUN_ROOT/attempts/${name}.jsonl"
  printf "adb shell 'cd %s && %s'\n" "$remote_cwd" "$command_body" > "$cmd_file"
  cat "$cmd_file" >> "$COMMAND_TXT"
  adb shell dumpsys battery > "$RUN_ROOT/telemetry/${name}_battery_pre.txt"
  adb shell dumpsys thermalservice > "$RUN_ROOT/telemetry/${name}_thermal_pre.txt"
  set +e
  adb shell "cd $remote_cwd && $command_body" > "$stdout_file" 2> "$stderr_file"
  status=$?
  set -e
  printf '%s\n' "$status" > "$exit_file"
  adb shell dumpsys battery > "$RUN_ROOT/telemetry/${name}_battery_post.txt"
  adb shell dumpsys thermalservice > "$RUN_ROOT/telemetry/${name}_thermal_post.txt"
  if [ -n "$device_receipt" ]; then
    adb pull "$device_receipt" "$pull_file" >/dev/null 2>&1 || true
  fi
  local raw="-"
  local norm="-"
  local run_id="-"
  if [ -f "$pull_file" ] && [ -s "$pull_file" ]; then
    raw=$(sha256sum "$pull_file" | awk '{print $1}')
    if command -v jq >/dev/null 2>&1; then
      norm=$(jq -c 'del(.timestamp)' "$pull_file" | sha256sum | awk '{print $1}')
      run_id=$(jq -r '.run_id // empty' "$pull_file" | head -n 1)
      [ -n "$run_id" ] || run_id="-"
    fi
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$name" "$status" "$device_receipt" "$raw" "$norm" "$run_id" >> "$ATTEMPTS_TSV"
}

run_attempt g2_default_assets /data/local/tmp/dm3 /data/local/tmp/dm3/phase0123_plan01_g2_default_assets.jsonl '/system/bin/timeout 30 ./dm3_runner --task exp_g2_readout --mode inference -o phase0123_plan01_g2_default_assets.jsonl'
run_attempt g2_explicit_assets_v2json /data/local/tmp/dm3 /data/local/tmp/dm3/phase0123_plan01_g2_explicit_assets_v2json.jsonl '/system/bin/timeout 30 ./dm3_runner --task exp_g2_readout --mode inference --adj SriYantraAdj_v1.bin --tags RegionTags_v2.json -o phase0123_plan01_g2_explicit_assets_v2json.jsonl'
run_attempt g2_abs_assets /data/local/tmp/dm3 /data/local/tmp/dm3/phase0123_plan01_g2_abs_assets.jsonl '/system/bin/timeout 30 ./dm3_runner --task exp_g2_readout --mode inference --adj /data/local/tmp/dm3/SriYantraAdj_v1.bin --tags /data/local/tmp/dm3/RegionTags_v2.json -o phase0123_plan01_g2_abs_assets.jsonl'
run_attempt g2_parent_cwd_abs_assets /data/local/tmp /data/local/tmp/dm3/phase0123_plan01_g2_parent_cwd_abs_assets.jsonl '/system/bin/timeout 30 ./dm3/dm3_runner --task exp_g2_readout --mode inference --adj /data/local/tmp/dm3/SriYantraAdj_v1.bin --tags /data/local/tmp/dm3/RegionTags_v2.json -o /data/local/tmp/dm3/phase0123_plan01_g2_parent_cwd_abs_assets.jsonl'
run_attempt infer_holography /data/local/tmp/dm3 /data/local/tmp/dm3/phase0123_plan01_infer_holography.jsonl '/system/bin/timeout 30 ./dm3_runner --mode inference --task holography -o phase0123_plan01_infer_holography.jsonl'
run_attempt infer_harmonic /data/local/tmp/dm3 /data/local/tmp/dm3/phase0123_plan01_infer_harmonic.jsonl '/system/bin/timeout 30 ./dm3_runner --mode inference --task harmonic -o phase0123_plan01_infer_harmonic.jsonl'
run_attempt train_holography /data/local/tmp/dm3 /data/local/tmp/dm3/phase0123_plan01_train_holography.jsonl '/system/bin/timeout 30 ./dm3_runner --mode train --task holography -o phase0123_plan01_train_holography.jsonl'
run_attempt train_harmonic /data/local/tmp/dm3 /data/local/tmp/dm3/phase0123_plan01_train_harmonic.jsonl '/system/bin/timeout 30 ./dm3_runner --mode train --task harmonic -o phase0123_plan01_train_harmonic.jsonl'
run_attempt train_exp_g2_readout /data/local/tmp/dm3 /data/local/tmp/dm3/phase0123_plan01_train_exp_g2_readout.jsonl '/system/bin/timeout 30 ./dm3_runner --mode train --task exp_g2_readout -o phase0123_plan01_train_exp_g2_readout.jsonl'

adb shell dumpsys battery > "$RUN_ROOT/telemetry/final_battery_after.txt"
adb shell dumpsys thermalservice > "$RUN_ROOT/telemetry/final_thermal_after.txt"

python3 - "$ATTEMPTS_TSV" "$CHECKPOINT_INDEX" <<'PY'
import csv, json, sys
attempts_tsv, checkpoint_index = sys.argv[1], sys.argv[2]
with open(attempts_tsv, newline='', encoding='utf-8') as fh:
    reader = csv.DictReader(fh, delimiter='\t')
    rows = list(reader)
with open(checkpoint_index, 'w', encoding='utf-8') as fh:
    json.dump({"policy": "rerun-only", "attempts": rows}, fh, indent=2)
PY

set +e
PYTHONDONTWRITEBYTECODE=1 COMET_OFFLINE_DIRECTORY="$OFFLINE_DIR" /Users/Zer0pa/DM3/restart/.venv/bin/python /Users/Zer0pa/DM3/restart/tools/comet_manifest_logger.py --manifest "$MANIFEST_JSON" --offline --write-key-file "$COMET_KEY_FILE" > "$RUN_ROOT/identity/comet_logger_stdout.txt" 2> "$RUN_ROOT/identity/comet_logger_stderr.txt"
set -e

echo "$RUN_ROOT"
