#!/system/bin/sh
# A.2 — Overfit-boundary walk: steps in {20,25,30,35,40,45,50}, N=3 per step.
# NO PASS/FAIL. Characterization of LEARNS->overfit transition.
# Defaults: SY_v1, xnor_train, pinned Prime cpu7, airplane ON.

set -u
CELL=A2_overfit_boundary
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] A2 start: overfit boundary walk steps=20..50 step=5 N=3 each" > "$PROG"

if [ "${KAT_PRE_OK:-}" != "true" ]; then
  sh "$HARNESS/kat_canary.sh" >> "$PROG" 2>&1 || { echo "KAT_FAIL" >> "$PROG"; exit 4; }
fi

for S in 20 25 30 35 40 45 50; do
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
    KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "s${S}_r${N}" "$OUT_DIR" \
      --cpu --mode train --task exp_k2_scars --steps "$S" >> "$PROG" 2>&1
  done
done

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] A2_COMPLETE" >> "$PROG"
