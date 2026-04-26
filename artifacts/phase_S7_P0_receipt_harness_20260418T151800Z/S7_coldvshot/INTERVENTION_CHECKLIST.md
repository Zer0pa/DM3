# S7 Cold vs Hot — Operator Intervention Checklist

S7 is a two-arm battery with mandatory operator physical intervention
between arms. The on-device script halts at each intervention point and
waits for a sentinel file to be touched before continuing.

## Protocol

### Arm 1: COLD

**Operator action before COLD arm starts (set once, before kicking off):**

1. Open REDMAGIC OS cooling fan control (swipe from top or Game Space).
2. Set fan to **level 5** (maximum).
3. Verify the fan is audibly running.
4. Confirm charger is plugged in (wall AC; not a bypass state).
5. Wait until the device feels cool to the touch (or `thermal_zone*` values
   stay below ~45 °C; the harness will also verify automatically).
6. Touch the continue sentinel:
   ```
   adb -s FY25013101C8 shell 'touch /data/local/tmp/dm3_harness/continue_s7_cold'
   ```

The harness will then run N=20 `harmonic --steps 5` cells, all pinned to
Prime core 7. Auto-abort if any thermal zone ≥ 70 °C.

### Inter-arm pause (automatic)

After COLD arm completes, the harness pauses 15 minutes and emits
`S7_ARM1_COLD_COMPLETE` in progress.txt. This is the mandatory reporting
point — the autonomous agent will send an operator report here before
arm 2 begins, per the Session 7 v2 mandate (§ "Next mandatory report is
at completion of S7 arm 1 (cold)").

### Arm 2: HOT

**Operator action after cold arm + report are approved:**

1. Open REDMAGIC OS cooling fan control.
2. Set fan to **OFF** (level 0).
3. Confirm charger remains plugged in AND that REDMAGIC "Charge
   Separation" is **DISABLED** (bypass OFF — battery IS charging so it
   will heat under load).
4. Optional but recommended: cover the back of the device with a thermal
   blanket or small towel to trap heat.
5. Touch the sentinel:
   ```
   adb -s FY25013101C8 shell 'touch /data/local/tmp/dm3_harness/continue_s7_hot'
   ```

The harness will then run N=20 `harmonic --steps 5` cells with the same
pinning as COLD. Auto-abort at 70 °C.

### Cleanup

After HOT arm completes, the harness emits `S7_BATTERY_COMPLETE`. The
operator should then:

1. Restore fan to auto (UI).
2. Re-verify device is cooling back below 45 °C.

## Pass / fail criteria (S2H-STAT methodology)

Each arm runs 20 × harmonic --steps 5 = 100 episodes. For each arm:
- Observed p(HIGH) Wilson 95 % CI computed.
- Compared against Session 5 P2a baseline CI [25.5 %, 43.7 %].

**PASS (substrate-invariant at dynamics layer under thermal):**
  both arms' CIs overlap the baseline CI AND overlap each other.

**FAIL (thermal coupling in dynamics):**
  either arm's CI disjoint from baseline, OR cold vs hot CIs disjoint
  from each other. Triggers halt + `SESSION7_PIVOT_THERMAL.md`.

Per-run canonical SHAs will all differ (harmonic is stochastic); that is
not a failure condition — only CI misalignment is.
