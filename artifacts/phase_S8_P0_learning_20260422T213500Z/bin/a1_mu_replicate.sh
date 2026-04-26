#!/system/bin/sh
# A.1 — μ replication: exp_k2_scars at --steps 20, N=10 independent runs.
# Pre-registered PASS: all 10 replicates show best_uplift >= 0.05
#                     AND median best_uplift within +/-30% of S7 baseline 1.324.
#                     (median in [0.927, 1.721] is PASS; <=50% of S7 is WEAKEN;
#                      any 3+ replicates with best_uplift < 0.05 is RETRACT.)
# Defaults: pinned Prime (cpu7), airplane ON, SY_v1, xnor_train, --steps 20.

set -u
CELL=A1_mu_replicate
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] A1 start: mu replication N=10 @ steps=20 pinned-Prime airplane" > "$PROG"

# KAT canary once per battery
if [ "${KAT_PRE_OK:-}" != "true" ]; then
  sh "$HARNESS/kat_canary.sh" >> "$PROG" 2>&1 || { echo "KAT_FAIL" >> "$PROG"; exit 4; }
fi

for N in 01 02 03 04 05 06 07 08 09 10; do
  # Per-run thermal gate + cooldown
  worst=0
  for z in /sys/class/thermal/thermal_zone*; do
    t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
    [ "$t" -gt "$worst" ] && worst=$t
  done
  if [ "$worst" -gt 65000 ]; then
    echo "[$(date -u +%T)] cooling 180s (worst=$worst)" >> "$PROG"
    sleep 180
  fi
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "r${N}" "$OUT_DIR" \
    --cpu --mode train --task exp_k2_scars --steps 20 >> "$PROG" 2>&1
done

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] A1_COMPLETE" >> "$PROG"
