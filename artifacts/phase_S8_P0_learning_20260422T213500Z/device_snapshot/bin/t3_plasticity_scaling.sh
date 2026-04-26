#!/system/bin/sh
# T3 — resonance_r3 plasticity scaling.
# Task intrinsically runs 10 training episodes per invocation.
# We sweep --steps to see if plasticity outcome varies.
# Pre-registered LEARNS = |Δ dE| ≥ 0.01 AND monotone over ≥ 3 configs.

set -u
CELL=T3_plasticity
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] T3 start: resonance_r3 scaling" > "$PROG"

for S in 1 5 10 20; do
  worst=0
  for z in /sys/class/thermal/thermal_zone*; do
    t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
    [ "$t" -gt "$worst" ] && worst=$t
  done
  [ "$worst" -gt 65000 ] && { echo "cooling 180s" >> "$PROG"; sleep 180; }
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "s${S}_001" "$OUT_DIR" \
    --cpu --mode train --task resonance_r3 --steps "$S" >> "$PROG" 2>&1
done

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] T3_COMPLETE" >> "$PROG"
