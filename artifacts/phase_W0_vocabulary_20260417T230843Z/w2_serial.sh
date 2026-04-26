#!/system/bin/sh
# W2 serial: remaining harmonic + holo cells.
# Parallel W2 produced 7/10 eps for H_m5 and H_m4 before kill (kept as partial N=7).
# Now run serial for H_m35, H_m3, H_m25 + HO_m5, HO_m3.

set -u
OUT_DIR=/data/local/tmp/phase_W2_third_regime_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

cd /data/local/tmp || exit 2

run_cell() {
  label="$1"; task="$2"; asym="$3"; steps="$4"
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ts_s=$(date +%s)
  echo "[$start] start $label task=$task asym=$asym steps=$steps" >> "$PROG"
  ./dm3_runner --cpu --mode train --task "$task" \
    --asymmetry="$asym" --steps "$steps" -o "$out" > "$log" 2>&1
  rc=$?
  ts_e=$(date +%s)
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  lines=$(wc -l < "$out" 2>/dev/null || echo 0)
  dur=$((ts_e - ts_s))
  echo "[$end] done $label rc=$rc lines=$lines sec=$dur" >> "$PROG"
}

run_cell "H_m35" harmonic -3.5 10
run_cell "H_m3"  harmonic -3.0 10
run_cell "H_m25" harmonic -2.5 10
run_cell "HO_m5" holography -5.0 5
run_cell "HO_m3" holography -3.0 5

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] W2_SERIAL_COMPLETE" >> "$PROG"
