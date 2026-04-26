#!/system/bin/sh
# S2H — harmonic substrate-invariance (statistical).
# Operator mandate: S2H-STAT, N=50, harmonic --steps 5, pinned same as S2.
# Pre-registered PASS:
#   observed p(HIGH) 95% Wilson CI overlaps baseline CI [0.255, 0.437]
#   AND sorted multiset of canonical SHAs is invariant (ie, each SHA appears
#   a predictable count matching basin stats).
# Pre-registered FAIL (= Tier-4-unlock class):
#   observed CI disjoint from baseline → halt, write SESSION7_PIVOT_DYNAMICS.md

set -u
N="${N:-50}"
CELL=S2H_harmonic
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT trap" >> $PROG' EXIT

echo "[$(date -u +%T)] S2H start N=$N task=harmonic --steps 5 pin=cpu7 airplane_preserve" > "$PROG"

kat_pre=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
echo "kat_pre=$kat_pre" >> "$PROG"
[ "$kat_pre" != "OK" ] && { echo "KAT pre-run FAIL ($kat_pre); aborting."; exit 4; }

i=1
while [ $i -le $N ]; do
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "$(printf %03d $i)" "$OUT_DIR" \
    --cpu --mode train --task harmonic --steps 5 >> "$PROG" 2>&1
  rc=$?
  if [ $rc -ne 0 ]; then
    echo "[$(date -u +%T)] run $i FAILED rc=$rc; halting" >> "$PROG"
    break
  fi
  i=$((i+1))
done

kat_post=$("$HARNESS/kat_canary.sh" 2>&1 | head -1)
echo "kat_post=$kat_post" >> "$PROG"

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S2H_BATTERY_COMPLETE" >> "$PROG"
