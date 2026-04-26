#!/system/bin/sh
# A.4 — Cross-dataset: xnor_train / xnor_mini / xnor_test at --steps 20, N=3 each.
# Pre-registered LEARNS: best_uplift >= 0.05 in >=2 of 3 datasets.

set -u
CELL=A4_cross_dataset
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] A4 start: cross-dataset xnor_{train,mini,test} @ steps=20 N=3" > "$PROG"

if [ "${KAT_PRE_OK:-}" != "true" ]; then
  sh "$HARNESS/kat_canary.sh" >> "$PROG" 2>&1 || { echo "KAT_FAIL" >> "$PROG"; exit 4; }
fi

run_dataset() {
  LABEL=$1
  DATASET_PATH=$2
  for N in 1 2 3; do
    worst=0
    for z in /sys/class/thermal/thermal_zone*; do
      t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
      [ "$t" -gt "$worst" ] && worst=$t
    done
    if [ "$worst" -gt 65000 ]; then
      echo "[$(date -u +%T)] cooling 180s (worst=$worst)" >> "$PROG"
      sleep 180
    fi
    KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "${LABEL}_r${N}" "$OUT_DIR" \
      --cpu --mode train --task exp_k2_scars --steps 20 \
      --dataset "$DATASET_PATH" >> "$PROG" 2>&1
  done
}

run_dataset xnor_train data/xnor_train.jsonl
run_dataset xnor_mini  data/xnor_mini.jsonl
run_dataset xnor_test  data/xnor_test.jsonl

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] A4_COMPLETE" >> "$PROG"
