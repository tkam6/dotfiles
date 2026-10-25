#!/bin/bash
STATE="${XDG_RUNTIME_DIR:-/tmp}/cpu-core-usage-$USER"

# --- Thresholds ---
CPU_CRIT=80
CPU_WARN=60
MEM_CRIT=75
MEM_WARN=50

# --- Colors ---
RED='#[fg=red]'
YELLOW='#[fg=yellow]'
GREEN='#[fg=green]'
RESET='#[default]'

# --- Memory ---
mem_total_kb=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
mem_avail_kb=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
mem_used_kb=$((mem_total_kb - mem_avail_kb))
mem_pct=$((100 * mem_used_kb / mem_total_kb))

human() {
    local first=$1
    local kb=$2
    if [[ $first == true ]]; then
        awk -v kb="$kb" 'BEGIN { printf "%.1f", kb/1024/1024 }'
    else
        awk -v kb="$kb" 'BEGIN { printf "%.1fGiB", kb/1024/1024 }'
    fi
}

mem_color="$GREEN"
(( mem_pct >= MEM_WARN )) && mem_color="$YELLOW"
(( mem_pct >= MEM_CRIT )) && mem_color="$RED"

mem_str="mem ${mem_color}$(human true "$mem_used_kb")${RESET}/$(human false "$mem_total_kb")"

# --- CPU ---
agg_line=$(awk '/^cpu / {print}' /proc/stat)
mapfile -t cpus < <(awk '/^cpu[0-9]+ / {print}' /proc/stat)

read_counters() {
    local line="$1" _ user nice system idle iowait irq softirq steal
    read -r _ user nice system idle iowait irq softirq steal _ <<< "$line"
    local total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle=$((idle + iowait))
    echo "$total $idle"
}

current_agg=$(read_counters "$agg_line")
current=()
for line in "${cpus[@]}"; do
    current+=("$(read_counters "$line")")
done

# First invocation: establish baseline
if [[ ! -f "$STATE" ]]; then
    {
        printf '%s\n' "$current_agg"
        printf '%s\n' "${current[@]}"
    } > "$STATE"
    printf '  -%% %s  %s' "$(printf '─%.0s' "${cpus[@]}")" "$mem_str"
    exit
fi

mapfile -t stored < "$STATE"
prev_agg="${stored[0]}"
previous=("${stored[@]:1}")

bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

calc_usage() {
    local total="$1" idle="$2" prev_total="$3" prev_idle="$4"
    local total_delta=$((total - prev_total))
    local idle_delta=$((idle - prev_idle))
    if (( total_delta > 0 )); then
        echo $((100 * (total_delta - idle_delta) / total_delta))
    else
        echo 0
    fi
}

# Overall CPU percentage
read -r total idle <<< "$current_agg"
read -r prev_total prev_idle <<< "$prev_agg"
overall_usage=$(calc_usage "$total" "$idle" "$prev_total" "$prev_idle")

overall_color="$GREEN"
(( overall_usage >= CPU_WARN )) && overall_color="$YELLOW"
(( overall_usage >= CPU_CRIT )) && overall_color="$RED"

output="cpu ${overall_color}$(printf '%3d%%' "$overall_usage")${RESET} ["

for i in "${!current[@]}"; do
    read -r total idle <<< "${current[i]}"
    read -r prev_total prev_idle <<< "${previous[i]}"
    usage=$(calc_usage "$total" "$idle" "$prev_total" "$prev_idle")
    index=$((usage * 7 / 100))
    if (( usage >= CPU_CRIT )); then
        output+="${RED}${bars[index]}${RESET}"
    elif (( usage >= CPU_WARN )); then
        output+="${YELLOW}${bars[index]}${RESET}"
    else
        output+="${bars[index]}"
    fi
done

output+="] & ${mem_str}"
printf '%s\n' "$output"

# Save current CPU counters
{
    printf '%s\n' "$current_agg"
    printf '%s\n' "${current[@]}"
} > "$STATE"
