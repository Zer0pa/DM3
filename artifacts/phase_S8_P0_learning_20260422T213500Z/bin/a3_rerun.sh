#!/system/bin/sh
# A.3 rerun — full 12-run cross-graph sweep, CPU-only thermal gate.
# Existing progress.txt + summary from thermal-walled run get archived.
# 4 cells (SY_v1, SY_v2, RA_v1, RA_v2) x N=3.

set -u
CELL=A3_cross_graph
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
# Archive the walled summary / progress; don't delete (audit trail).
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
echo "[$(date -u +%T)] A3 RERUN start: cross-graph SY/RA x v1/v2 @ steps=20 N=3 (CPU-only thermal gate)" >> "$PROG"

run_cell_cross() {
  LABEL=$1
  ADJ=$2
  TAGS=$3
  for N in 1 2 3; do
    target="$OUT_DIR/A3_cross_graph_${LABEL}_r${N}.json"
    if [ -f "$target" ]; then
      echo "[$(date -u +%T)] ${LABEL}_r${N} already present; skip" >> "$PROG"
      continue
    fi
    wait_cool
    KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "${LABEL}_r${N}" "$OUT_DIR" \
      --cpu --mode train --task exp_k2_scars --steps 20 \
      --adj "$ADJ" --tags "$TAGS" >> "$PROG" 2>&1
  done
}

run_cell_cross SY_v1 SriYantraAdj_v1.bin RegionTags_v1.bin
run_cell_cross SY_v2 SriYantraAdj_v1.bin RegionTags_v2.bin
run_cell_cross RA_v1 RandomAdj_v1.bin   RegionTags_v1.bin
run_cell_cross RA_v2 RandomAdj_v1.bin   RegionTags_v2.bin

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] A3_RERUN_COMPLETE" >> "$PROG"
