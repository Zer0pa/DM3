#!/system/bin/sh
# A.2 resume — run the 14 A.2 cells missed by the thermal wall:
#   s30 r2,r3 | s35 r1,r2,r3 | s40 r1,r2,r3 | s45 r1,r2,r3 | s50 r1,r2,r3
# Uses CPU-only thermal filter in the inline cooldown loop.
# Pre-existing receipts (s20 r1-r3, s25 r1-r3, s30 r1) are NOT re-run.

set -u
CELL=A2_overfit_boundary
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

cpu_worst() {
  worst=0
  for z in /sys/class/thermal/thermal_zone*; do
    tp=$(cat "$z/type" 2>/dev/null)
    case "$tp" in
      cpu-*|cpuss-*|gpuss-*) : ;;
      *) continue ;;
    esac
    t=$(cat "$z/temp" 2>/dev/null)
    [ -z "$t" ] && continue
    [ "$t" -gt "$worst" ] && worst=$t
  done
  echo "$worst"
}

wait_cool() {
  # Cap at 10 × 60s = 10 min wait; then proceed and let run_cell.sh arbitrate.
  tries=0
  while [ "$tries" -lt 10 ]; do
    w=$(cpu_worst)
    if [ "$w" -le 65000 ]; then break; fi
    echo "[$(date -u +%T)] cpu cooling 60s (cpu_worst=$w)" >> "$PROG"
    sleep 60
    tries=$((tries + 1))
  done
}

trap 'echo "[$(date -u +%T)] EXIT" >> $PROG' EXIT
echo "[$(date -u +%T)] A2 RESUME start: 14 missing runs (s30 r2-r3; s35-s50 N=3 each)" >> "$PROG"

run_one() {
  S=$1
  N=$2
  target="$OUT_DIR/A2_overfit_boundary_s${S}_r${N}.json"
  if [ -f "$target" ]; then
    echo "[$(date -u +%T)] s${S}_r${N} already present; skip" >> "$PROG"
    return 0
  fi
  wait_cool
  KAT_PRE_OK=true PIN_CORE=7 "$HARNESS/run_cell.sh" "$CELL" "s${S}_r${N}" "$OUT_DIR" \
    --cpu --mode train --task exp_k2_scars --steps "$S" >> "$PROG" 2>&1
}

run_one 30 2
run_one 30 3
for S in 35 40 45 50; do
  for N in 1 2 3; do
    run_one $S $N
  done
done

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] A2_RESUME_COMPLETE" >> "$PROG"
