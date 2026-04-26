#!/system/bin/sh
# T11 — R1/R2 cross-control @ default steps.
# Completes the 2x2 table SY×v1 (default), SY×v2 (S6), RA×v1 (S4/W0), RA×v2 (NEW).
# 3 replicates of RA+v2 at defaults to confirm compound flip is deterministic.

set -u
CELL=T11_cross_control
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT

echo "[$(date -u +%T)] T11 start: RA+v2 @ default steps, 3 replicates" > "$PROG"

for i in 1 2 3; do
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "RAv2_$(printf %03d $i)" "$OUT_DIR" \
    --cpu --mode train --task exp_r1_r4_campaign \
    --adj RandomAdj_v1.bin --tags RegionTags_v2.bin --steps 1 >> "$PROG" 2>&1
  rc=$?
  [ $rc -ne 0 ] && { echo "[$(date -u +%T)] run $i FAIL rc=$rc" >> "$PROG"; break; }
done

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] T11_COMPLETE" >> "$PROG"
