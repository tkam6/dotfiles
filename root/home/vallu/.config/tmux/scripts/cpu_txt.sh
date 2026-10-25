#!/bin/bash
STATE="${XDG_RUNTIME_DIR:-/tmp}/cpu-usage-$USER"

read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle=$((idle + iowait))

if [[ -f "$STATE" ]]; then
    read -r prev_total prev_idle < "$STATE"

    total_delta=$((total - prev_total))
    idle_delta=$((idle - prev_idle))
    if (( total_delta > 0 )); then
        usage=$((100 * (total_delta - idle_delta) / total_delta))
        printf '%d%%\n' "$usage"
    else
        printf '0%%\n'
    fi
else
    # No previous sample yet.
    printf -- '--\n'
fi

printf '%d %d\n' "$total" "$idle" > "$STATE"
