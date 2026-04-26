#!/system/bin/sh
# A.3 — Cross-graph: SY/RA x v1/v2 at --steps 20, N=3 per cell.
# Pre-registered LEARNS: best_uplift >= 0.05 in >=2 of 4 cells.
# Any cell with best_uplift >= 0.5 receipts mu cross-graph robustness.
# 4 cells: SY_v1, SY_v2, RA_v1, RA_v2.

set -u
CELL=A3_cross_graph
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] A3 start: cross-graph SY/RA x v1/v2 @ steps=20 N=3" > "$PROG"

if [ "${KAT_PRE_OK:-}" != "true" ]; then
  sh "$HARNESS/kat_canary.sh" >> "$PROG" 2>&1 || { echo "KAT_FAIL" >> "$PROG"; exit 4; }
fi

# Cell label : adj file : tags file
#   SY_v1 -> SriYantraAdj_v1.bin RegionTags_v1.bin
#   SY_v2 -> SriYantraAdj_v1.bin RegionTags_v2.bin
#   RA_v1 -> RandomAdj_v1.bin    RegionTags_v1.bin
#   RA_v2 -> RandomAdj_v1.bin    RegionTags_v2.bin
run_cell_cross() {
  LABEL=$1
  ADJ=$2
  TAGS=$3
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
      --adj "$ADJ" --tags "$TAGS" >> "$PROG" 2>&1
  done
}

run_cell_cross SY_v1 SriYantraAdj_v1.bin RegionTags_v1.bin
run_cell_cross SY_v2 SriYantraAdj_v1.bin RegionTags_v2.bin
run_cell_cross RA_v1 RandomAdj_v1.bin   RegionTags_v1.bin
run_cell_cross RA_v2 RandomAdj_v1.bin   RegionTags_v2.bin

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] A3_COMPLETE" >> "$PROG"
