#!/system/bin/sh
# Rehydrate a fresh checkout to green proofs with receipts.
set -euo pipefail
source "$HOME/.cargo/env" 2>/dev/null || true
export PATH="$HOME/.cargo/bin:$PATH"

JQ="$(command -v jq || true)"
if [ -z "$JQ" ]; then
  USE_PY_JSON=1
else
  USE_PY_JSON=0
fi

check_gate_summary() {
  local json_file="$1"
  if [ "$USE_PY_JSON" -eq 1 ]; then
    python3 - "$json_file" <<'PY'
import json, sys
path = sys.argv[1]
with open(path) as fh:
    data = json.load(fh)
summary = data.get('gate_summary', {})
if summary.get('gates_ok') and summary.get('cad_sos_present'):
    sys.exit(0)
sys.exit(1)
PY
  else
    "$JQ" -e '.gate_summary | (.gates_ok==true and .cad_sos_present==true)' "$json_file" >/dev/null
  fi
}

./scripts/POLICY_CHECK.sh
python3 - <<'PY'
import json, pathlib
p=pathlib.Path('configs/CONFIG.json')
cfg=json.loads(p.read_text())
cfg['yantra']={'layout':'TEST_TRIADS'}
lift=cfg.setdefault('lift_3d',{})
lift['pitch']='1/1'; lift['rotation_t']='1/2'; lift['rotor_t_half']='1/3'; lift['base_radii']=['1/1','2/1','3/1']
p.write_text(json.dumps(cfg,indent=2)+"\n")
print('[CFG] baseline restored')
PY
cargo build --locked
cargo test --workspace -- --nocapture
./scripts/REPRODUCE.sh
./scripts/REPORT.sh
check_gate_summary artifacts/verify.json
mkdir -p receipts
python3 - <<'PY'
import json, pathlib, hashlib
verify_path = pathlib.Path('artifacts/verify.json')
v=json.loads(verify_path.read_text())
if isinstance(v, dict):
    v['timestamp'] = 'DETERMINISTIC_BUILD'
sumj={"ts_utc": "DETERMINISTIC_BUILD",
      "gates": v["gate_summary"],
      "cad_sos": v["sidecars"].get('D_cad_sos', {})}
verify_path.write_text(json.dumps(v, sort_keys=True, indent=2) + "\n")
pathlib.Path('receipts/VERIFY_SUMMARY.json').write_text(json.dumps(sumj, sort_keys=True, indent=2) + "\n")

def sha256(path):
    h=hashlib.sha256()
    with open(path,'rb') as f:
        h.update(f.read())
    return h.hexdigest()
paths=['artifacts/verify.json','artifacts/solve_h2.json','receipts/VERIFY_SUMMARY.json']
lines=[f"{sha256(p)}  {p}" for p in sorted(paths) if pathlib.Path(p).exists()]
pathlib.Path('receipts/MERKLE.txt').write_text('\n'.join(lines)+'\n')
print('[REBUILD] receipts refreshed.')
PY
echo "[REBUILD] PASS: full verify and receipts complete"
