#!/system/bin/sh
# phase_a_resume_chain — recover A.2 (14 missed), A.3 (full 12), A.4 (full 9).
# Uses the CPU-only thermal filter (pmih010x_lite_tz excluded).
# A.1 already closed with 10/10 bit-identical receipts.

set -u
HARNESS=/data/local/tmp/dm3_harness/bin
LOG=/data/local/tmp/dm3_harness/phase_a_resume.log
CELLS_ROOT=/data/local/tmp/dm3_harness/cells
: > "$LOG"

echo "[$(date -u +%T)] PHASE_A_RESUME_CHAIN START" >> "$LOG"

# Reuse KAT from prior chain (binary hasn't changed). Re-run for cleanliness.
sh "$HARNESS/kat_canary.sh" >> "$LOG" 2>&1 || { echo "KAT_FAIL" >> "$LOG"; exit 4; }

run_sub() {
  TAG=$1
  SCRIPT=$2
  CELL=$3
  PROG=$CELLS_ROOT/$CELL/progress.txt
  if [ -f "$PROG" ] && grep -q "${TAG}_COMPLETE" "$PROG"; then
    echo "[$(date -u +%T)] $TAG already complete; skipping" >> "$LOG"
    return 0
  fi
  echo "[$(date -u +%T)] --- $TAG ---" >> "$LOG"
  KAT_PRE_OK=true "$HARNESS/$SCRIPT" >> "$LOG" 2>&1
}

run_sub A2_RESUME a2_resume.sh A2_overfit_boundary
run_sub A3_RERUN  a3_rerun.sh  A3_cross_graph
run_sub A4_RERUN  a4_rerun.sh  A4_cross_dataset

echo "[$(date -u +%T)] PHASE_A_RESUME_CHAIN_COMPLETE" >> "$LOG"
