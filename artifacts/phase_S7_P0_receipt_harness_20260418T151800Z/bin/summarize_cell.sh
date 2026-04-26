#!/system/bin/sh
# summarize_cell.sh — builds the top-level experiment summary receipt.
# Usage: summarize_cell.sh <exp_id> <cell_dir>
# Emits: <cell_dir>/<exp_id>_summary.json + <exp_id>_summary.sha
set -u

EXP="$1"
DIR="$2"

cd "$DIR" || exit 1

# Count unique output SHAs (raw + canonical) + unique receipt SHAs
uniq_out_raw=$(cat ${EXP}_*.bin.sha 2>/dev/null | awk '{print $1}' | sort -u | wc -l | tr -d ' ')
uniq_out_can=$(cat ${EXP}_*.bin.canonical.sha 2>/dev/null | awk '{print $1}' | sort -u | wc -l | tr -d ' ')
uniq_rec=$(cat ${EXP}_*.receipt.sha 2>/dev/null | awk '{print $1}' | sort -u | wc -l | tr -d ' ')
total_runs=$(ls ${EXP}_*.json 2>/dev/null | wc -l | tr -d ' ')

# Collect per-run receipt SHAs as JSON arrays
sha_arr=$(cat ${EXP}_*.receipt.sha 2>/dev/null | awk '{printf "\"%s\",", $1}' | sed 's/,$//')
out_sha_arr=$(cat ${EXP}_*.bin.sha 2>/dev/null | awk '{printf "\"%s\",", $1}' | sed 's/,$//')
can_sha_arr=$(cat ${EXP}_*.bin.canonical.sha 2>/dev/null | awk '{printf "\"%s\",", $1}' | sed 's/,$//')

# Unique SHA lists
uniq_out_list=$(cat ${EXP}_*.bin.sha 2>/dev/null | awk '{print $1}' | sort -u | awk '{printf "\"%s\",", $0}' | sed 's/,$//')
uniq_can_list=$(cat ${EXP}_*.bin.canonical.sha 2>/dev/null | awk '{print $1}' | sort -u | awk '{printf "\"%s\",", $0}' | sed 's/,$//')

# Verdict: canonical hash determines substrate invariance (run_sec is wallclock noise)
# PASS = 1 unique canonical SHA
verdict="FAIL"
[ "$uniq_out_can" = "1" ] && verdict="PASS"

ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)

cat > "${EXP}_summary.json" <<EOF
{
  "harness_version": "s7_p0_v1",
  "experiment_id": "${EXP}",
  "timestamp_utc": "${ts}",
  "binary_expected_sha256": "daaaa84a052b60523bf9d63152f1154225abf119c279aa4b3aabf14487279672",
  "total_runs": ${total_runs},
  "unique_output_sha256_raw": ${uniq_out_raw},
  "unique_output_sha256_canonical": ${uniq_out_can},
  "unique_receipt_sha256": ${uniq_rec},
  "unique_output_sha256_list_raw": [${uniq_out_list}],
  "unique_output_sha256_list_canonical": [${uniq_can_list}],
  "output_sha256_per_run": [${out_sha_arr}],
  "output_canonical_sha256_per_run": [${can_sha_arr}],
  "receipt_sha256_per_run": [${sha_arr}],
  "verdict_basis": "canonical (run_sec zeroed)",
  "verdict": "${verdict}"
}
EOF

summary_sha=$(sha256sum "${EXP}_summary.json" | awk '{print $1}')
echo "$summary_sha  ${EXP}_summary.json" > "${EXP}_summary.sha"

echo "SUMMARY exp=${EXP} runs=${total_runs} unique_canonical=${uniq_out_can} verdict=${verdict} summary_sha=${summary_sha}"
