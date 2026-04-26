#!/system/bin/sh
# S10 / v1-X1 — exp_k3_truth_sensor deep characterization.
# This task emits KPIs to stdout (not a JSONL receipt) showing baseline vs sensor error.
# Session 6 W0 saw sensor strength=0.5 drop final error 89.26 → 22.32.
# Session 7 goal: map error vs sensor_strength across a sweep, test if LEARNS.
# Pre-registered LEARNS = ≥80% error reduction AND monotone over ≥4 sensor points.

set -u
CELL=S10_truth_sensor
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT

echo "[$(date -u +%T)] S10 start" > "$PROG"

# Tier A: sensor strength sweep at default threshold
# Values: 0.0 (baseline), 0.1, 0.25, 0.5, 0.75, 1.0
for S in 0.0 0.1 0.25 0.5 0.75 1.0; do
  s_tag=$(echo "$S" | sed 's/\./p/')
  PIN_CORE=7 KAT_PRE_OK=true "$HARNESS/run_cell.sh" "$CELL" "A_s${s_tag}_001" "$OUT_DIR" \
    --cpu --mode train --task exp_k3_truth_sensor --sensor-strength "$S" >> "$PROG" 2>&1
done

# Tier B: threshold sweep at fixed strength=0.5
for T in 0.01 0.1 1.0 10.0; do
  t_tag=$(echo "$T" | sed 's/\./p/')
  PIN_CORE=7 KAT_PRE_OK=true "$HARNESS/run_cell.sh" "$CELL" "B_t${t_tag}_001" "$OUT_DIR" \
    --cpu --mode train --task exp_k3_truth_sensor --sensor-strength 0.5 --sensor-threshold "$T" >> "$PROG" 2>&1
done

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S10_COMPLETE" >> "$PROG"
