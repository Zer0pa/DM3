#!/system/bin/sh
# S2 + bundled B2: pinned-baseline hash identity.
# 20 runs of exp_r1_r4_campaign at defaults, pinned to Prime core 7.
# PRD §5.S2. PASS = 1 unique canonical SHA across 20.
#
# Note: per Session 6 W0, --seed does not exist in this binary;
#       exp_r1_r4_campaign is byte-deterministic up to run_sec per Session 6 W1.
#       We use it as the deterministic reference workload.

set -u
N="${N:-20}"
CELL=S2_pinned
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"

trap 'echo "[$(date -u +%T)] EXIT trap; fan/gov left as-is (no permissioned changes made)." >> $OUT_DIR/progress.txt' EXIT

echo "[$(date -u +%T)] S2 start N=$N" > "$OUT_DIR/progress.txt"
echo "[$(date -u +%T)] S2 start N=$N"

kat_pre=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
echo "kat_pre=$kat_pre" >> "$OUT_DIR/progress.txt"
[ "$kat_pre" != "OK" ] && { echo "KAT pre-run FAIL ($kat_pre); aborting."; exit 4; }

i=1
while [ $i -le $N ]; do
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "$(printf %03d $i)" "$OUT_DIR" \
    --cpu --mode train --task exp_r1_r4_campaign --steps 1 >> "$OUT_DIR/progress.txt" 2>&1
  rc=$?
  if [ $rc -ne 0 ]; then
    echo "[$(date -u +%T)] run $i FAILED rc=$rc; halting" >> "$OUT_DIR/progress.txt"
    break
  fi
  i=$((i+1))
done

kat_post=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
echo "kat_post=$kat_post" >> "$OUT_DIR/progress.txt"

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$OUT_DIR/progress.txt" 2>&1
echo "[$(date -u +%T)] S2_COMPLETE" >> "$OUT_DIR/progress.txt"
