#!/system/bin/sh
# S11 / v1-X2 — exp_r1_r4_campaign R3 gate flip search.
# Session 6 saw r3.k2_uplift 0.0070 → 0.0292 at steps=20 (no flip).
# Session 7: probe steps=50 and 100 to see if k2_uplift crosses R3 threshold.

set -u
CELL=S11_r3_flip
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] S11 start" > "$PROG"

# Tier A: steps sweep on SY default
for S in 20 50 100; do
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "A_s${S}_001" "$OUT_DIR" \
    --cpu --mode train --task exp_r1_r4_campaign --steps "$S" >> "$PROG" 2>&1
done

# Tier B: combined axes at steps=50
KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "B_RA_tagsV2_s50_001" "$OUT_DIR" \
  --cpu --mode train --task exp_r1_r4_campaign --adj RandomAdj_v1.bin --tags RegionTags_v2.bin --steps 50 >> "$PROG" 2>&1

KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "B_RA_tagsV2_s100_001" "$OUT_DIR" \
  --cpu --mode train --task exp_r1_r4_campaign --adj RandomAdj_v1.bin --tags RegionTags_v2.bin --steps 100 >> "$PROG" 2>&1

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S11_COMPLETE" >> "$PROG"
