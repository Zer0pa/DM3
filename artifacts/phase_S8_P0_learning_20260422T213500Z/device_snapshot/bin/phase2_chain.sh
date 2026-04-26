#!/system/bin/sh
# phase2_chain.sh — runs S4 (airplane vs radios) then S6 (Prime vs Perf core).
# S7 (thermal), S8 (battery), S9 (freq) require root — deferred.

set -u
HARNESS=/data/local/tmp/dm3_harness/bin
LOG=/data/local/tmp/dm3_harness/phase2_chain.log
: > "$LOG"

echo "[$(date -u +%T)] === PHASE2 CHAIN START ===" >> "$LOG"

echo "[$(date -u +%T)] --- S4 START ---" >> "$LOG"
N=5 "$HARNESS/s4_airplane_battery.sh" >> "$LOG" 2>&1
echo "[$(date -u +%T)] --- S4 END ---" >> "$LOG"

sleep 30

echo "[$(date -u +%T)] --- S6 START ---" >> "$LOG"
N=5 "$HARNESS/s6_core_battery.sh" >> "$LOG" 2>&1
echo "[$(date -u +%T)] --- S6 END ---" >> "$LOG"

echo "[$(date -u +%T)] === PHASE2 CHAIN COMPLETE ===" >> "$LOG"
