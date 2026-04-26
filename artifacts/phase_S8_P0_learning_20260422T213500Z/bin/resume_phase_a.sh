#!/system/bin/sh
# resume_phase_a.sh — relaunch phase_a_chain under nohup after reboot/disconnect.
# Safe to run multiple times — chain is resume-safe at the cell level.

set -u
HARNESS=/data/local/tmp/dm3_harness/bin
LOG=/data/local/tmp/dm3_harness/phase_a_chain.log

# If chain is already alive, no-op.
if pidof dm3_runner > /dev/null 2>&1; then
  echo "[$(date -u +%T)] dm3_runner PID=$(pidof dm3_runner) already running; not relaunching"
  exit 0
fi

# If chain completed, no-op.
if [ -f "$LOG" ] && grep -q PHASE_A_CHAIN_COMPLETE "$LOG"; then
  echo "[$(date -u +%T)] PHASE_A_CHAIN_COMPLETE present; nothing to resume"
  exit 0
fi

# Relaunch.
echo "[$(date -u +%T)] RESUMING phase_a_chain" >> "$LOG"
nohup sh "$HARNESS/phase_a_chain.sh" > /data/local/tmp/dm3_harness/phase_a_chain.stdout 2>&1 < /dev/null &
echo "RESUMED_PID=$!"
