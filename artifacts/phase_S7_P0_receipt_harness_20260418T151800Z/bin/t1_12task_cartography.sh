#!/system/bin/sh
# T1 — 12-task baseline cartography.
# Run each accepted task once at default flags, pinned cpu7.
# Produces a reference cartography of default outputs.

set -u
CELL=T1_cartography
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] T1 start: 12-task cartography" > "$PROG"

for TASK in harmonic holography interference holographic_memory exp_r1_r4_campaign \
            exp_i1 exp_i2 exp_h1_h2 exp_k2_scars exp_k3_truth_sensor \
            resonance_r3 resonance_v2; do
  # thermal guard
  worst=0
  for z in /sys/class/thermal/thermal_zone*; do
    t=$(cat "$z/temp" 2>/dev/null); [ -z "$t" ] && continue
    [ "$t" -gt "$worst" ] && worst=$t
  done
  if [ "$worst" -gt 65000 ]; then
    echo "[$(date -u +%T)] cooling 180s (worst=${worst}mC)" >> "$PROG"
    sleep 180
  fi
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "${TASK}_001" "$OUT_DIR" \
    --cpu --mode train --task "$TASK" --steps 1 >> "$PROG" 2>&1
done

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] T1_COMPLETE" >> "$PROG"
