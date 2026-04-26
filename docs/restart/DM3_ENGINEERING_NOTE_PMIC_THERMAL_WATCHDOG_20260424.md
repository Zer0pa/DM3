# DM3 Engineering IS-NOT Finding — PMIC Thermal Watchdog Pattern

Written: `2026-04-24` ~00:55 UTC (02:55 SAST)
For: DM3 engineering team (promoted to first-class finding per orchestrator mandate 2026-04-24)
Status: CONFIRMED
Scope: smartphone / mobile SoC thermal-gate design

---

## Claim

**Smartphone thermal watchdogs that max-over-all-zones will false-trigger due to PMIC thermal-mass lag. CPU/GPU-domain sensor filtering is the correct pattern.**

This is not a scientific claim about DM3 the binary. It is an **engineering IS-NOT** finding about how thermal watchdog design interacts with Qualcomm-class PMIC (power management IC) voltage-regulator thermal sensors on 4-nm class mobile SoCs.

---

## Evidence

### Observation (2026-04-23, Session 8 Phase A.2)

- Harness: `run_cell.sh` (Session 7 version), thermal gate `worst = max(/sys/class/thermal/thermal_zone*/temp)`, hard ceiling 70,000 mC (70 °C)
- Device: Red Magic 10 Pro+ (Qualcomm Snapdragon 8 Elite, SM8750, 4 nm), serial `FY25013101C8`
- Chain: continuous compute on pinned Prime (cpu7) from 21:37 UTC 2026-04-22 to 02:39 UTC 2026-04-23 (~5 h)
- Post-compute state (02:39 UTC onward): CPU cores dropped to low-30 °C within minutes, but the PMIC sensor `pmih010x_lite_tz` remained **71–72 °C for 2+ hours**

### Impact
- Every subsequent run of A.3 and A.4 (after the thermal halt) false-tripped the 70 °C gate on the PMIC sensor alone
- The chain looped through `thermal_abort → cooldown 180 s → thermal_abort` for 64 minutes before the cell scripts exited with `SUMMARY runs=0 verdict=FAIL`
- A.3: 0 receipts produced in the original run. A.4: 0 receipts produced in the original run.

### Root cause
- `pmih010x_lite_tz` is a PMIC voltage-regulator thermal sensor, not a compute-domain sensor
- PMIC has much higher thermal mass than the CPU core (physically larger silicon + more copper + different package thermal path)
- Thermal inertia time constant is **hours**, not minutes — the PMIC stays hot long after compute stops
- CPU/GPU compute cores cool in minutes (small, well-ducted, actively fanned)
- max-over-all-zones gate tracks the **slowest-cooling sensor**, not the **load-responsive sensor** — inverting the intended semantics of "gate compute on compute temperature"

### Patch (deployed 2026-04-23 ~08:30 UTC)
```sh
# Session 8 fix in run_cell.sh — filter thermal sensors by type
worst=0
worst_zone=""
for z in /sys/class/thermal/thermal_zone*; do
  tp=$(cat "$z/type" 2>/dev/null)
  case "$tp" in
    cpu-*|cpuss-*|gpuss-*) : ;;
    *) continue ;;
  esac
  t=$(cat "$z/temp" 2>/dev/null)
  [ -z "$t" ] && continue
  if [ "$t" -gt "$worst" ]; then worst=$t; worst_zone="$tp"; fi
done
```

PMIC / DDR / NSP / aoss / pm-* / any non-compute-domain sensors are excluded from gating decisions. They remain captured in the full `thermal_zones` diagnostic array in each receipt's env_pre JSON for post-hoc analysis.

### Validation
- A.2 resume (09:33 UTC onward) + A.3 + A.4 all ran to completion under the patched gate
- Real thermal events during RA_v2_r1 (cpu-1-1-1 hit 75.7 °C during compute) correctly triggered 180 s cooldowns
- No false-positive gate trips for the remainder of Phase A (55 total receipts ran clean)

---

## Pattern

For any mobile-SoC compute harness:

**Correct pattern**: filter thermal sensors by type prefix matching compute domains (`cpu-*`, `cpuss-*`, `gpuss-*` on Snapdragon; equivalent on other SoCs). Gate on the max of that filtered set.

**Incorrect pattern**: max over all `/sys/class/thermal/thermal_zone*/temp`. This will false-trigger on any of:
- PMIC / power-regulator sensors (hours-long thermal mass)
- Modem / NSP / DSP idle-hot sensors (different thermal paths, not load-correlated)
- Battery / skin / case sensors (slower time constant than CPU, often at higher steady-state due to user-hand contact)
- Any ambient-coupled sensor

**Diagnostic one-liner** to see per-sensor temperatures in real time:
```sh
adb shell 'for z in /sys/class/thermal/thermal_zone*; do printf "%s %s\n" "$(cat $z/type)" "$(cat $z/temp)"; done | sort'
```

**Spotting the anti-pattern in existing harnesses**: grep for `thermal_zone*/temp` without an accompanying `type` filter. If the harness reads all zones and takes max or any, it is vulnerable.

---

## Generalization beyond Snapdragon

The anti-pattern applies to any mobile SoC with exposed per-domain thermal sensors:

- Qualcomm Snapdragon: `pmih010x_lite_tz`, `pmic_xo_therm`, `pm8550*-*` families — all exclude
- MediaTek Dimensity: `soc_max`, `mtktscpu-sys*` — compute-domain; `pmic*` — exclude
- Apple A/M-series (iPad/iPhone — not directly relevant to DM3 but pattern transfers): `pmu tcal`, `charger tcal` — exclude; `soc`, `gpu` — include
- Google Tensor: `tpu*`, `g3d` — compute; `pmic_0_tz`, `quiet_therm` — exclude
- Samsung Exynos: `BIG`, `LITTLE`, `GPU` — compute; `SUB_PMIC*` — exclude

A safe design rule: **allowlist compute-domain sensors explicitly; do not denylist exceptions**. Adding a new SoC requires ~10 lines of config, not thermal-table archaeology.

---

## Why this belongs in the ledger, not a footnote

The operator's 2026-04-24 directive: *"PMIC thermal-gate patch: promote to first-class engineering IS-NOT finding. Write it up as a self-contained engineering note alongside the scientific claims."*

Rationale:
1. This is the second "mobile-substrate misunderstanding kills experiment time" finding of the project (Session 4 had the NPU-offload false start; this is the thermal-gate false start)
2. Any future mobile-SoC experiment harness — DM3-related or otherwise — is at risk of repeating this mistake
3. Engineering findings that invalidate prior design assumptions are IS-NOT data, equal standing with scientific IS-NOT findings
4. The finding was discovered the hard way and cost ~7 h of wall-clock in Phase A.2 recovery; future harnesses should inherit the lesson for free

This note is referenceable as **DM3 Engineering IS-NOT #001: PMIC-thermal-mass-lag-masquerading-as-CPU-overheat**.

---

## Related findings (open)

- **NPU offload was ABSTAIN from project inception**, but the Session 4 NPU probe exposed a secondary anti-pattern: userspace Hexagon libraries return signature-valid fake hashes when asked to hash themselves. Not the same class of finding but adjacent — both are "the phone lies to the harness about its internal state if you ask the wrong surface".
- **Fan-speed sensors on Red Magic**: `fan_rpm` is exposed via `/sys/class/hwmon/*/fan1_input` but reports null on this device; fan control is via a vendor-proprietary driver. Not a gate failure, but worth noting for any future substrate cell that wants to gate on fan state.

---

## Reproduction notes

The false-trigger event is reproducible:
1. Start any heavy-compute chain (~4+ hours continuous on Prime core) on a Snapdragon 8 Elite device
2. Stop compute; wait 5 minutes (CPUs return to idle temps)
3. Check `pmih010x_lite_tz` temp — will read 68–72 °C for 2+ hours
4. If a thermal gate with ceiling 70 °C reads max-over-all-zones, it will refuse to start new runs even though the compute surface is fully cool

The window for false-trigger is approximately 0.5–4 h post-compute-end, depending on ambient temperature and fan state.

---

—— Session 8 engineer-agent, 2026-04-24
