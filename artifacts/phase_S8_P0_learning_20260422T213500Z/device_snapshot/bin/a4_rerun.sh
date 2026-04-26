#!/system/bin/sh
# A.4 rerun — full 9-run cross-dataset sweep, CPU-only thermal gate.
# Existing progress.txt + summary from thermal-walled run get archived.
# 3 datasets (xnor_train/mini/test) x N=3.

set -u
CELL=A4_cross_dataset
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
if [ -f "$OUT_DIR/progress.txt" ]; then
  mv "$OUT_DIR/progress.txt" "$OUT_DIR/progress.pre_resume.txt" 2>/dev/null
fi
if [ -f "$OUT_DIR/${CELL}_summary.json" ]; then
  mv "$OUT_DIR/${CELL}_summary.json" "$OUT_DIR/${CELL}_summary.pre_resume.json" 2>/dev/null
  mv "$OUT_DIR/${CELL}_summary.sha"  "$OUT_DIR/${CELL}_summary.pre_resume.sha"  2>/dev/null
fi
PROG="$OUT_DIR/progress.txt"

cpu_worst() {
  worst=0
  for z in /sys/class/thermal/thermal_zone*; do
    tp=$(cat "$z/type" 2>/dev/null)
    case "$tp" in
      cpu-*|cpuss-*|gpuss-*) : ;;
      *) continue ;;
    esac
    t=$(cat "$z/temp" 2>/dev/null)
    [ -z "$t" ] && continue
    [ "$t" -gt "$worst" ] && worst=$t
  done
  echo "$worst"
}

wait_cool() {
  tries=0
  while [ "$tries" -lt 10 ]; do
    w=$(cpu_worst)
    if [ "$w" -le 65000 ]; then break; fi
    echo "[$(date -u +%T)] cpu cooling 60s (cpu_worst=$w)" >> "$PROG"
    sleep 60
    tries=$((tries + 1))
  done
}

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] A4 RERUN start: xnor_{train,mini,test} @ steps=20 N=3 (CPU-only thermal gate)" >> "$PROG"

run_dataset() {
  LABEL=$1
  DATASET_PATH=$2
  for N in 1 2 3; do
    target="$OUT_DIR/A4_cross_dataset_${LABEL}_r${N}.json"
    if [ -f "$target" ]; then
      echo "[$(date -u +%T)] ${LABEL}_r${N} already present; skip" >> "$PROG"
      continue
    fi
    wait_cool
    KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "${LABEL}_r${N}" "$OUT_DIR" \
      --cpu --mode train --task exp_k2_scars --steps 20 \
      --dataset "$DATASET_PATH" >> "$PROG" 2>&1
  done
}

run_dataset xnor_train data/xnor_train.jsonl
run_dataset xnor_mini  data/xnor_mini.jsonl
run_dataset xnor_test  data/xnor_test.jsonl

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] A4_RERUN_COMPLETE" >> "$PROG"
