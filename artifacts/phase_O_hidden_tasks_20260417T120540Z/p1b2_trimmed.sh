#!/system/bin/sh
# P1b2: trimmed after finding interference is asymmetry-invariant.
# Focus on multi-step behavior.

set -u
OUT_DIR=/data/local/tmp/phase_P1b2_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
: > "$PROG"

cd /data/local/tmp || exit 2

run_cell() {
  label="$1"; shift
  outfile="$OUT_DIR/${label}.jsonl"
  logfile="$OUT_DIR/${label}.log"
  rm -f "$outfile" "$logfile" /data/local/tmp/holographic_memory_log.csv
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  bat=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo "?")
  echo "[$start] start $label bat=$bat" >> "$PROG"
  ./dm3_runner --cpu --mode train -o "$outfile" "$@" > "$logfile" 2>&1
  rc=$?
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  lines=$(wc -l < "$outfile" 2>/dev/null || echo 0)
  bytes=$(wc -c < "$outfile" 2>/dev/null || echo 0)
  if [ -f /data/local/tmp/holographic_memory_log.csv ]; then
    cp /data/local/tmp/holographic_memory_log.csv "$OUT_DIR/${label}_holo.csv"
  fi
  echo "[$end] done $label rc=$rc bytes=$bytes lines=$lines" >> "$PROG"
}

# interference: does accuracy converge with more epochs?
run_cell "interf_steps5"   --task interference --steps 5

# holographic_memory: CSV should grow with --steps if epochs scale
run_cell "holo_steps5"     --task holographic_memory --steps 5
run_cell "holo_steps10"    --task holographic_memory --steps 10

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
