#!/system/bin/sh
# W1 Tier C: new-flag / graph-topology sweep after Tier A proved
# asym/rot/steps are null for exp_r1_r4_campaign. Test:
#   - RandomAdj_v1.bin at 3 asym values (confirm R1 flip)
#   - SY with --tags RegionTags_v2.bin (swap ring structure)
#   - SY with --dataset xnor_mini and xnor_test
#   - SY with steps=5 and steps=20 (last-chance steps probe)
# Budget target: ~4 hours.

set -u
OUT_DIR=/data/local/tmp/phase_W1_tier_c_receipts
mkdir -p "$OUT_DIR"
PROG="$OUT_DIR/progress.txt"
RES="$OUT_DIR/results.tsv"
: > "$PROG"
printf "label\targs\tstart\tend\trc\tbytes\tsec\n" > "$RES"

cd /data/local/tmp || exit 2

run_cell() {
  label="$1"; shift
  out="$OUT_DIR/${label}.jsonl"
  log="$OUT_DIR/${label}.log"
  rm -f "$out" "$log"
  start=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  ts_s=$(date +%s)
  echo "[$start] start $label args=$*" >> "$PROG"
  ./dm3_runner --cpu --mode train --task exp_r1_r4_campaign "$@" -o "$out" > "$log" 2>&1
  rc=$?
  ts_e=$(date +%s)
  end=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  bytes=$(wc -c < "$out" 2>/dev/null || echo 0)
  dur=$((ts_e - ts_s))
  echo "[$end] done $label rc=$rc bytes=$bytes sec=$dur" >> "$PROG"
  printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$label" "$*" "$start" "$end" "$rc" "$bytes" "$dur" >> "$RES"
}

# === RA replicates and parameter variations ===
# RA at defaults (already have one from W0; this is replicate-of-replicate to confirm determinism)
run_cell "C_RA_det_r2"           --adj RandomAdj_v1.bin --steps 1
# RA with asymmetry (does RA respond to asym when SY doesn't?)
run_cell "C_RA_asymn05"          --adj RandomAdj_v1.bin --asymmetry=-0.5 --steps 1
run_cell "C_RA_asym05"           --adj RandomAdj_v1.bin --asymmetry=0.5 --steps 1

# === SY with RegionTags_v2.bin (different ring structure) ===
run_cell "C_SY_tags_v2"          --adj SriYantraAdj_v1.bin --tags RegionTags_v2.bin --steps 1

# === SY with alternate datasets ===
run_cell "C_SY_ds_mini"          --adj SriYantraAdj_v1.bin --dataset /data/local/tmp/dm3/data/xnor_mini.jsonl --steps 1
run_cell "C_SY_ds_test"          --adj SriYantraAdj_v1.bin --dataset /data/local/tmp/dm3/data/xnor_test.jsonl --steps 1

# === SY with bigger operational_steps ===
run_cell "C_SY_s20"              --adj SriYantraAdj_v1.bin --steps 20
run_cell "C_SY_s50"              --adj SriYantraAdj_v1.bin --steps 50

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] COMPLETE" >> "$PROG"
