#!/system/bin/sh
# Probe hidden task and mode names discovered in binary strings scan.
# Runs on device under nohup so device disconnect is survivable.
# Output goes to /data/local/tmp/phase_O_receipts/ and progress.txt.

set -u
OUT_DIR=/data/local/tmp/phase_O_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
RESULTS="$OUT_DIR/results.tsv"
: > "$PROG"
: > "$RESULTS"
printf "label\tkind\targ\tstart_iso\tend_iso\trc\tbytes\tlines\n" >> "$RESULTS"

cd /data/local/tmp || exit 2

run_probe() {
  label="$1"
  kind="$2"     # task | mode | combo
  shift 2
  outfile="$OUT_DIR/${label}.jsonl"
  logfile="$OUT_DIR/${label}.log"
  rm -f "$outfile" "$logfile"

  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  echo "[$start] start $label: $*" >> "$PROG"

  ./dm3_runner --cpu --mode train --steps 1 -o "$outfile" "$@" > "$logfile" 2>&1
  rc=$?

  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  if [ -f "$outfile" ]; then
    bytes=$(wc -c < "$outfile" 2>/dev/null || echo 0)
    lines=$(wc -l < "$outfile" 2>/dev/null || echo 0)
  else
    bytes=0
    lines=0
  fi
  echo "[$end] done $label rc=$rc bytes=$bytes lines=$lines" >> "$PROG"
  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$label" "$kind" "$*" "$start" "$end" "$rc" "$bytes" "$lines" >> "$RESULTS"
}

# --task probes
run_probe "task_interference"          task --task interference
run_probe "task_holographic_memory"    task --task holographic_memory
run_probe "task_InterferenceTask"      task --task InterferenceTask
run_probe "task_run_holographic_memory" task --task run_holographic_memory
run_probe "task_K1"                    task --task K1
run_probe "task_G2"                    task --task G2
run_probe "task_pattern_ontology"      task --task pattern_ontology
run_probe "task_boundary_readout"      task --task boundary_readout
run_probe "task_exp_i0_classifier"     task --task exp_i0_classifier
run_probe "task_exp_r1_r4_campaign"    task --task exp_r1_r4_campaign
run_probe "task_r1_r4_campaign"        task --task r1_r4_campaign
run_probe "task_interference_task"     task --task interference_task
run_probe "task_holographic_memory_hyphen" task --task holographic-memory

# --mode probes
run_probe "mode_G2"                    mode --mode G2
run_probe "mode_K1"                    mode --mode K1
run_probe "mode_inference_hm"          combo --mode inference --task holographic_memory
run_probe "mode_inference_interference" combo --mode inference --task interference

# Gated probes (strict resonance gating from Doc #5)
run_probe "gated_holography"           combo --task holography --gated
run_probe "gated_harmonic"             combo --task harmonic --gated

# Control: harmonic default for receipt schema baseline
run_probe "control_harmonic_default"   control --task harmonic

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
