# S7 INTERVENTION_CHECKLIST

## Arm 1: COLD (autonomous, no intervention needed)
Preconditions:
- Fan on (REDMAGIC UI set to level 5 or higher)
- Airplane mode ON (optional; airplane state recorded per-run regardless)
- Skin/CPU thermal zones ≤ 45 °C

Observed at launch: thermal zones all < 40 °C, fan verified on by operator.

## BETWEEN ARMS — INTERVENTION REQUIRED
When COLD arm completes, the script pauses and writes:
  [15:41:48] INTERVENTION REQUIRED: switch to HOT arm

### Your steps for the HOT arm:
1. Turn fan **off** via REDMAGIC UI (or leave fan on but set to level 0/minimum)
2. Plug charger in (wall wart preferred); verify status=Charging
3. In REDMAGIC UI, **DISABLE** Charge Separation / Bypass
   (battery should charge normally so it warms under load)
4. Optional: place device on a thermal blanket or warm surface
5. When ready, touch this file:  /data/local/tmp/dm3_harness/cells/S7_thermal/continue
   via:  adb -s FY25013101C8 shell 'touch /data/local/tmp/dm3_harness/cells/S7_thermal/continue'
   The script will resume within 30 s.

**The script auto-aborts any run where any thermal zone ≥ 70 °C.**
If you see "THERMAL_OVER_CEILING" in progress.txt, cool the device and restart.
