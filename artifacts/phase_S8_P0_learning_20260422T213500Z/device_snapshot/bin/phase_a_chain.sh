#!/system/bin/sh
# phase_a_chain — A.1 -> A.2 -> A.3 -> A.4 sequentially.
# Resume-safe: skips any cell whose progress.txt contains the _COMPLETE token.
# Session 8 Phase A = mu robustness and overfit boundary characterization.

set -u
HARNESS=/data/local/tmp/dm3_harness/bin
LOG=/data/local/tmp/dm3_harness/phase_a_chain.log
CELLS_ROOT=/data/local/tmp/dm3_harness/cells
: > "$LOG"

echo "[$(date -u +%T)] PHASE_A_CHAIN START" >> "$LOG"

# Single KAT canary for the whole chain; sub-cells inherit via KAT_PRE_OK=true
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

run_sub A1 a1_mu_replicate.sh      A1_mu_replicate
run_sub A2 a2_overfit_boundary.sh  A2_overfit_boundary
run_sub A3 a3_cross_graph.sh       A3_cross_graph
run_sub A4 a4_cross_dataset.sh     A4_cross_dataset

echo "[$(date -u +%T)] PHASE_A_CHAIN_COMPLETE" >> "$LOG"
