#!/system/bin/sh
set -eu
source "$HOME/.cargo/env" 2>/dev/null || true
export PATH="$HOME/.cargo/bin:$PATH"

if [ ! -f artifacts/verify.json ]; then
  echo "Run ./scripts/REPRODUCE.sh first"
  exit 1
fi

JQ="$(command -v jq || true)"
if [ -z "$JQ" ]; then
  USE_PY_JSON=1
else
  USE_PY_JSON=0
fi

echo "----- VERIFY SUMMARY -----"
if [ "$USE_PY_JSON" -eq 1 ]; then
  python3 - <<'PY'
import json
from pathlib import Path
verify = json.loads(Path('artifacts/verify.json').read_text())
summary = {
    "gates_ok": verify.get('gate_summary', {}).get('gates_ok'),
    "A_egraph": verify.get('gate_summary', {}).get('egraph_proof_valid'),
    "B_dep_cert": verify.get('gate_summary', {}).get('dep_cert_present'),
    "C_gc": verify.get('gate_summary', {}).get('gc_invariants_pass'),
    "CAD_SOS": verify.get('gate_summary', {}).get('cad_sos_present'),
    "LIFT": verify.get('gate_summary', {}).get('lift_pass'),
    "STAB": verify.get('gate_summary', {}).get('stab_pass'),
    "ts": verify.get('timestamp')
}
print(json.dumps(summary, indent=2))
print()
print("----- GC DETAIL -----")
print(json.dumps(verify.get('sidecars', {}).get('C_gc', {}), indent=2))
print()
solve_path = Path('artifacts/solve_h2.json')
if solve_path.exists():
    solve = json.loads(solve_path.read_text())
    print("----- DEQ REPORT -----")
    report = solve.get('report', {})
    subset = {
        "delta_e_monotone": report.get('delta_e_monotone'),
        "jac_spectral_bound_ok": report.get('jac_spectral_bound_ok'),
        "mode_lock_pass": report.get('mode_lock_pass'),
        "notes": {
            "alpha": report.get('notes', {}).get('alpha'),
            "norm_inf_J": report.get('notes', {}).get('norm_inf_J'),
            "K": report.get('notes', {}).get('K')
        }
    }
    print(json.dumps(subset, indent=2))
    print("----- DEQ ENERGY TRACE (first 8) -----")
    energies = report.get('notes', {}).get('energies_L1', [])
    print(json.dumps(energies[:8], indent=2))
    print()
print()
print()
print("----- CAD/SOS -----")
print(json.dumps(verify.get('sidecars', {}).get('D_cad_sos', {}), indent=2))
print()
print("----- LIFT INVARIANTS -----")
print(json.dumps(verify.get('sidecars', {}).get('LIFT', {}), indent=2))
print()
print("----- STAB DETAILS -----")
print(json.dumps(verify.get('sidecars', {}).get('STAB', {}), indent=2))
print()
print("----- BAREISS DEP-CERT -----")
print(json.dumps(verify.get('sidecars', {}).get('B_bareiss', {}), indent=2))
PY
else
  "$JQ" '{gates_ok: .gate_summary.gates_ok,
     A_egraph: .gate_summary.egraph_proof_valid,
     B_dep_cert: .gate_summary.dep_cert_present,
     C_gc: .gate_summary.gc_invariants_pass,
     CAD_SOS: .gate_summary.cad_sos_present,
     LIFT: .gate_summary.lift_pass,
     STAB: .gate_summary.stab_pass,
     ts: .timestamp}' artifacts/verify.json
  echo
  echo "----- GC DETAIL -----"
  "$JQ" '.sidecars.C_gc | {n_vertices, n_lines_unique, collinear_triplets, max_concurrency_degree, concurrency_points_ge3}' artifacts/verify.json
  echo
  if [ -f artifacts/solve_h2.json ]; then
    echo "----- DEQ REPORT -----"
    "$JQ" '.report | {delta_e_monotone, jac_spectral_bound_ok, mode_lock_pass, notes: {alpha, norm_inf_J, K}}' artifacts/solve_h2.json
    echo "----- DEQ ENERGY TRACE (first 8) -----"
    "$JQ" '.report.notes.energies_L1 | .[0:8]' artifacts/solve_h2.json
  fi
  echo
  echo
  echo "----- CAD/SOS -----"
  "$JQ" '.sidecars.D_cad_sos | {pass, checks}' artifacts/verify.json
  echo
  echo "----- LIFT INVARIANTS -----"
  "$JQ" '.sidecars.LIFT | {pass, pitch, rot, checks}' artifacts/verify.json
  echo
  echo "----- STAB DETAILS -----"
  "$JQ" '.sidecars.STAB' artifacts/verify.json
  echo
  echo "----- BAREISS DEP-CERT -----"
  "$JQ" '.sidecars.B_bareiss' artifacts/verify.json
fi
