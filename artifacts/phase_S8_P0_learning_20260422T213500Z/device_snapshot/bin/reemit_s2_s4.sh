#!/system/bin/sh
# Re-emit S2 and S4 receipt JSONs through v2 harness (fixes duration_ns 32-bit overflow).
# Does NOT re-run dm3_runner; only recomputes duration from start_ns/end_ns using awk.
# Canonical SHAs unaffected.

set -u
HARNESS=/data/local/tmp/dm3_harness
LOG="$HARNESS/reemit.log"
: > "$LOG"

fix_one() {
  f="$1"
  # Read start_ns and end_ns, recompute duration_ns via awk, replace in-place
  start=$(grep -oE '"start_ns": [0-9]+' "$f" | head -1 | awk '{print $2}')
  end=$(grep -oE '"end_ns": [0-9]+' "$f" | head -1 | awk '{print $2}')
  [ -z "$start" ] || [ -z "$end" ] && return 1
  dur_ns=$(awk -v a="$start" -v b="$end" 'BEGIN{printf "%.0f", b-a}')
  dur_s=$(awk -v a="$start" -v b="$end" 'BEGIN{printf "%.3f", (b-a)/1000000000.0}')
  # Replace duration_ns value and add duration_sec if missing
  tmp="${f}.tmp"
  awk -v dn="$dur_ns" -v ds="$dur_s" '
    /"duration_ns":/ { sub(/-?[0-9]+/, dn); print; next }
    { print }
  ' "$f" > "$tmp"
  if ! grep -q '"duration_sec"' "$tmp"; then
    awk -v ds="$dur_s" '
      /"duration_ns":/ { print; printf "  \"duration_sec\": %s,\n", ds; next }
      { print }
    ' "$tmp" > "${f}.tmp2"
    mv "${f}.tmp2" "$tmp"
  fi
  mv "$tmp" "$f"
  # Recompute receipt SHA
  new_sha=$(sha256sum "$f" | awk '{print $1}')
  echo "$new_sha  $(basename "$f")" > "${f%.json}.receipt.sha"
  echo "FIXED $f dur_ns=$dur_ns dur_s=$dur_s new_sha=$new_sha" >> "$LOG"
}

for d in /data/local/tmp/dm3_harness/cells/S2_pinned /data/local/tmp/dm3_harness/cells/S4_airplane; do
  for j in "$d"/*_[0-9][0-9][0-9].json "$d"/*_[A-Z]*_[0-9][0-9][0-9].json; do
    [ -f "$j" ] || continue
    fix_one "$j"
  done
  # Regenerate summary with new hashes
  exp=$(basename "$d")
  "$HARNESS/bin/summarize_cell.sh" "$exp" "$d" >> "$LOG" 2>&1
done

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] REEMIT_COMPLETE" >> "$LOG"
