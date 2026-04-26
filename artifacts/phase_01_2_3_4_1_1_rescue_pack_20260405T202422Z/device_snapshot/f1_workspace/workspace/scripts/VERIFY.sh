#!/system/bin/sh
set -eu
source "$HOME/.cargo/env" 2>/dev/null || true
export PATH="$HOME/.cargo/bin:$PATH"

JQ="$(command -v jq || true)"
if [ -z "$JQ" ]; then
  USE_PY_JSON=1
else
  USE_PY_JSON=0
fi

./scripts/POLICY_CHECK.sh
cargo run -p io_cli --bin snic_rust -- verify --config configs/CONFIG.json | tee artifacts/VERIFY.stdout.log
if [ "$USE_PY_JSON" -eq 1 ]; then
  python3 - <<'PY'
import json
from pathlib import Path
verify = json.loads(Path('artifacts/verify.json').read_text())
summary = verify.get('gate_summary', {})
print(json.dumps({
    'gates_ok': summary.get('gates_ok'),
    'egraph_proof_valid': summary.get('egraph_proof_valid'),
    'dep_cert_present': summary.get('dep_cert_present'),
    'gc_invariants_pass': summary.get('gc_invariants_pass'),
    'cad_sos_present': summary.get('cad_sos_present')
}, indent=2))
PY
else
  "$JQ" '.gate_summary | {gates_ok, egraph_proof_valid, dep_cert_present, gc_invariants_pass, cad_sos_present}' artifacts/verify.json
fi
