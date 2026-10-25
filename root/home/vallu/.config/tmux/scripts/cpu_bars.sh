#!/bin/bash
STATE="${XDG_RUNTIME_DIR:-/tmp}/cpu-core-usage-$USER"

# Read current counters
mapfile -t cpus < <(awk '/^cpu[0-9]+ / {print}' /proc/stat)
current=()

for line in "${cpus[@]}"; do
    read -r _ user nice system idle iowait irq softirq steal _ <<< "$line"
    total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle=$((idle + iowait))
    current+=("$total $idle")
done

# First invocation: establish baseline
if [[ ! -f "$STATE" ]]; then
    printf '%s\n' "${current[@]}" > "$STATE"
    printf '%s' "──────────────────"
    exit
fi

mapfile -t previous < "$STATE"
bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
output=""

for i in "${!current[@]}"; do
    read -r total idle <<< "${current[i]}"
    read -r prev_total prev_idle <<< "${previous[i]}"

    total_delta=$((total - prev_total))
    idle_delta=$((idle - prev_idle))
    if (( total_delta > 0 )); then
        usage=$((100 * (total_delta - idle_delta) / total_delta))
    else
        usage=0
    fi
    # Map 0-100% → 0-7
    index=$((usage * 7 / 100))
    output+="${bars[index]}"
done

printf '%s\n' "$output"
# Save current counters
printf '%s\n' "${current[@]}" > "$STATE"
