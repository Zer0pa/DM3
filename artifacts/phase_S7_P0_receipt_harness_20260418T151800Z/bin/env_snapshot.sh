#!/system/bin/sh
# env_snapshot.sh — emits a JSON environment snapshot to stdout.
# Called pre- and post-run; run_cell.sh merges them into the final receipt.
# All fields are best-effort; unavailable fields come out as null.

set -u

j_str() { printf '"%s"' "$(echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g')"; }
j_num() { n="$1"; [ -z "$n" ] && printf 'null' || printf '%s' "$n"; }
j_bool() { case "$1" in 1|true|on|yes) printf 'true';; 0|false|off|no) printf 'false';; *) printf 'null';; esac; }

safecat() { cat "$1" 2>/dev/null | tr -d '\r\n ' || true; }
safe() { "$@" 2>/dev/null || true; }

# --- build JSON ---
printf '{'

printf '"ts_ns":%s,' "$(date +%s%N)"
printf '"ts_iso":%s,' "$(j_str "$(date -u +%Y-%m-%dT%H:%M:%SZ)")"
printf '"kernel_release":%s,' "$(j_str "$(uname -r)")"
printf '"device_serial":%s,' "$(j_str "${ANDROID_SERIAL:-FY25013101C8}")"

# CPU state (if PIN_CORE passed via env)
printf '"cpu_pinned":%s,' "${PIN_CORE:-null}"
if [ -n "${PIN_CORE:-}" ]; then
  cap=$(safecat "/sys/devices/system/cpu/cpu${PIN_CORE}/cpu_capacity")
  gov=$(safecat "/sys/devices/system/cpu/cpu${PIN_CORE}/cpufreq/scaling_governor")
  fmin=$(safecat "/sys/devices/system/cpu/cpu${PIN_CORE}/cpufreq/scaling_min_freq")
  fmax=$(safecat "/sys/devices/system/cpu/cpu${PIN_CORE}/cpufreq/scaling_max_freq")
  fcur=$(safecat "/sys/devices/system/cpu/cpu${PIN_CORE}/cpufreq/scaling_cur_freq")
  printf '"cpu_capacity":%s,"governor":%s,"scaling_min_khz":%s,"scaling_max_khz":%s,"scaling_cur_khz":%s,' \
    "$(j_num "$cap")" "$(j_str "$gov")" "$(j_num "$fmin")" "$(j_num "$fmax")" "$(j_num "$fcur")"
else
  printf '"cpu_capacity":null,"governor":null,"scaling_min_khz":null,"scaling_max_khz":null,"scaling_cur_khz":null,'
fi

# FPCR — needs asm helper, stubbed null for now (B2 bundle may inject)
printf '"fpcr_value":%s,' "${FPCR_HEX:-null}"

# Radio state
airplane=$(safe settings get global airplane_mode_on | tr -d '\r\n ')
wifi=$(safe settings get global wifi_on | tr -d '\r\n ')
bt=$(safe settings get global bluetooth_on | tr -d '\r\n ')
data=$(safe settings get global mobile_data | tr -d '\r\n ')
printf '"airplane_mode":%s,"wifi_enabled":%s,"bt_enabled":%s,"mobile_data_enabled":%s,' \
  "$(j_bool "$airplane")" "$(j_bool "$wifi")" "$(j_bool "$bt")" "$(j_bool "$data")"

# Battery
bcap=$(safecat /sys/class/power_supply/battery/capacity)
bstat=$(safecat /sys/class/power_supply/battery/status)
bcur=$(safecat /sys/class/power_supply/battery/current_now)
bvolt=$(safecat /sys/class/power_supply/battery/voltage_now)
btemp=$(safecat /sys/class/power_supply/battery/temp)
bctype=$(safecat /sys/class/power_supply/battery/charge_type)
printf '"battery_capacity_pct":%s,"battery_status":%s,"battery_current_ua":%s,"battery_voltage_uv":%s,"battery_temp_dc":%s,"battery_charge_type":%s,' \
  "$(j_num "$bcap")" "$(j_str "$bstat")" "$(j_num "$bcur")" "$(j_num "$bvolt")" "$(j_num "$btemp")" "$(j_str "$bctype")"

# USB
uon=$(safecat /sys/class/power_supply/usb/online)
ucm=$(safecat /sys/class/power_supply/usb/current_max)
uct=$(safecat /sys/class/power_supply/usb/charge_type)
printf '"usb_online":%s,"usb_current_max":%s,"usb_charge_type":%s,' \
  "$(j_bool "$uon")" "$(j_num "$ucm")" "$(j_str "$uct")"

# Fan (best-effort)
fen=$(safecat /sys/kernel/fan/enable)
flvl=$(safecat /sys/kernel/fan/level)
frpm=$(safecat /sys/kernel/fan/rpm)
printf '"fan_enable":%s,"fan_level":%s,"fan_rpm":%s,' \
  "$(j_num "$fen")" "$(j_num "$flvl")" "$(j_num "$frpm")"

# Thermal zones — only non-zero, first 12
printf '"thermal_zones":['
first=1
i=0
for z in /sys/class/thermal/thermal_zone*; do
  [ -d "$z" ] || continue
  t=$(safecat "$z/temp")
  [ -z "$t" ] && continue
  [ "$t" = "0" ] && continue
  tp=$(safecat "$z/type")
  if [ "$first" = "1" ]; then first=0; else printf ','; fi
  printf '{"type":%s,"temp_mc":%s}' "$(j_str "$tp")" "$(j_num "$t")"
  i=$((i+1))
  [ $i -ge 12 ] && break
done
printf '],'

# core_ctl
cce=$(safecat /sys/module/msm_performance/parameters/core_ctl_enable)
printf '"core_ctl_enable":%s' "$(j_num "$cce")"

printf '}'
