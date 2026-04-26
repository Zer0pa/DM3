#!/system/bin/sh
# S6 / LAB-B1 — Prime vs Performance core bit identity.
# Prime cores: cpu6, cpu7 (cap=1024). Performance cores: cpu0-5 (cap=792).
# Two arms × N runs, pinned via taskset. No governor change (requires root).
# PRD §5.S6. PASS = 1 unique canonical SHA across 2N.

set -u
N="${N:-5}"
CELL=S6_core
OUT_DIR=/data/local/tmp/dm3_harness/cells/$CELL
HARNESS=/data/local/tmp/dm3_harness/bin
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"

trap "echo '[$(date -u +%T)] EXIT trap' >> $PROG" EXIT

echo "[$(date -u +%T)] S6 start N_per_arm=$N" > "$PROG"

run_arm() {
  arm="$1"
  core="$2"
  echo "[$(date -u +%T)] arm=$arm pinned_core=$core" >> "$PROG"
  i=1
  while [ $i -le $N ]; do
    KAT_PRE_OK=true PIN_CORE=$core "$HARNESS/run_cell.sh" "$CELL" "${arm}_$(printf %03d $i)" "$OUT_DIR" \
      --cpu --mode train --task exp_r1_r4_campaign --steps 1 >> "$PROG" 2>&1
    rc=$?
    [ $rc -ne 0 ] && { echo "[$(date -u +%T)] arm=$arm run $i FAILED rc=$rc" >> "$PROG"; break; }
    i=$((i+1))
  done
}

# Arm 1: Prime (cpu7, cap=1024)
run_arm PRIME 7
# Arm 2: Performance (cpu0, cap=792)
run_arm PERF 0

"$HARNESS/summarize_cell.sh" "$CELL" "$OUT_DIR" >> "$PROG" 2>&1
echo "[$(date -u +%T)] S6_COMPLETE" >> "$PROG"
