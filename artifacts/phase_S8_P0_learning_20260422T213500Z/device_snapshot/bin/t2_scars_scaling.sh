#!/system/bin/sh
# T2 — exp_k2_scars multi-lesson scaling.
# Tests whether scar-formation uplift scales with operational budget.
# Pre-registered LEARNS = best_uplift ≥ 0.05 AND monotone over ≥ 4 lesson counts.

set -u
CELL=T2_scars_scaling
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] T2 start: exp_k2_scars scaling" > "$PROG"

# Sweep --steps ∈ {1, 5, 10, 20, 50} for scars task
for S in 1 5 10 20 50; do
  worst=0
  for z in /sys/class/thermal/thermal_zone*; do
    t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
    [ "$t" -gt "$worst" ] && worst=$t
  done
  [ "$worst" -gt 65000 ] && { echo "cooling 180s" >> "$PROG"; sleep 180; }
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "s${S}_001" "$OUT_DIR" \
    --cpu --mode train --task exp_k2_scars --steps "$S" >> "$PROG" 2>&1
done

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] T2_COMPLETE" >> "$PROG"
