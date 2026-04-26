#!/system/bin/sh
# W0 task-name probes for tasks revealed in binary-strings scan.
# Rejected tasks fail clap in <1s. Accepted tasks proceed to real execution.

set -u
OUT_DIR=/data/local/tmp/phase_W0_task_probes
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
RES="$OUT_DIR/results.tsv"
: > "$PROG"
printf "label\targ\tstart\tend\trc\tbytes\tlines\n" > "$RES"

cd /data/local/tmp || exit 2

run_probe() {
  label="$1"; task="$2"
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "[$start] start $label --task $task" >> "$PROG"
  ./dm3_runner --cpu --mode train --task "$task" --steps 1 -o "$out" > "$log" 2>&1
  rc=$?
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  bytes=$(wc -c < "$out" 2>/dev/null || echo 0)
  lines=$(wc -l < "$out" 2>/dev/null || echo 0)
  echo "[$end] done $label rc=$rc bytes=$bytes lines=$lines" >> "$PROG"
  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$label" "$task" "$start" "$end" "$rc" "$bytes" "$lines" >> "$RES"
}

# Task names revealed in binary strings scan but never tried
run_probe "exp_i1"                 "exp_i1"
run_probe "exp_i2"                 "exp_i2"
run_probe "exp_h1_h2"              "exp_h1_h2"
run_probe "exp_i1_thermodynamics"  "exp_i1_thermodynamics"
run_probe "exp_k1_patterns"        "exp_k1_patterns"
run_probe "exp_k2_denoise"         "exp_k2_denoise"
run_probe "exp_k2_scars"           "exp_k2_scars"
run_probe "exp_k3_truth_sensor"    "exp_k3_truth_sensor"
run_probe "exp_j1_holo_capacity"   "exp_j1_holo_capacity"
run_probe "exp_j2_resonant_compute" "exp_j2_resonant_compute"
run_probe "exp_g1_contrastive"     "exp_g1_contrastive"
run_probe "exp_g2_readout"         "exp_g2_readout"
run_probe "exp_o2_interference"    "exp_o2_interference"
run_probe "resonance_r3"           "resonance_r3"
run_probe "resonance_v2"           "resonance_v2"

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
