#!/bin/bash

# ==============================
#   Linux System Monitor
#   Author: Adikwu
# ==============================

REFRESH=5  # seconds between updates

display_header() {
    echo "======================================================"
    echo "           LINUX SYSTEM MONITOR"
    echo "   $(date '+%Y-%m-%d %H:%M:%S')   |   Refreshes every ${REFRESH}s"
    echo "======================================================"
}

display_cpu() {
    local cpu_idle_1 cpu_total_1 cpu_idle_2 cpu_total_2
    local cpu_delta_idle cpu_delta_total
    local CPU_USAGE BAR FILLED

    echo ""
    echo "--- CPU USAGE ---"

    read -r cpu_idle_1 cpu_total_1 < <(
        awk '/^cpu / {
            idle = $5 + $6
            total = 0
            for (i = 2; i <= NF; i++) total += $i
            print idle, total
            exit
        }' /proc/stat
    )
    sleep 0.2
    read -r cpu_idle_2 cpu_total_2 < <(
        awk '/^cpu / {
            idle = $5 + $6
            total = 0
            for (i = 2; i <= NF; i++) total += $i
            print idle, total
            exit
        }' /proc/stat
    )

    cpu_delta_idle=$((cpu_idle_2 - cpu_idle_1))
    cpu_delta_total=$((cpu_total_2 - cpu_total_1))

    if (( cpu_delta_total > 0 )); then
        CPU_USAGE=$(awk -v idle="$cpu_delta_idle" -v total="$cpu_delta_total" 'BEGIN { printf "%.1f", (total - idle) * 100 / total }')
    else
        CPU_USAGE="0.0"
    fi

    echo "  Usage: ${CPU_USAGE}%"

    # Visual bar
    BAR=""
    FILLED=$(awk -v usage="$CPU_USAGE" 'BEGIN { print int(usage / 5) }')
    for ((i=0; i<FILLED; i++)); do BAR+="█"; done
    for ((i=FILLED; i<20; i++)); do BAR+="░"; done
    echo "  [${BAR}]"
}

display_memory() {
    echo ""
    echo "--- MEMORY (RAM) ---"
    TOTAL=$(free -m | awk '/Mem:/ {print $2}')
    USED=$(free -m | awk '/Mem:/ {print $3}')
    FREE=$(free -m | awk '/Mem:/ {print $4}')
    PERCENT=$(echo "scale=1; $USED * 100 / $TOTAL" | bc)

    echo "  Total:  ${TOTAL} MB"
    echo "  Used:   ${USED} MB  (${PERCENT}%)"
    echo "  Free:   ${FREE} MB"

    # Visual bar
    BAR=""
    FILLED=$(echo "$PERCENT / 5" | bc)
    for ((i=0; i<FILLED; i++)); do BAR+="█"; done
    for ((i=FILLED; i<20; i++)); do BAR+="░"; done
    echo "  [${BAR}]"
}

display_disk() {
    echo ""
    echo "--- DISK USAGE ---"
    df -h --output=source,size,used,avail,pcent,target | grep -E "^/dev/" | while read -r line; do
        echo "  $line"
    done
}

display_network() {
    echo ""
    echo "--- NETWORK INTERFACES ---"
    ip -brief addr show | awk '{
        addresses = ""
        for (i = 3; i <= NF; i++) {
            addresses = addresses (i == 3 ? "" : " ") $i
        }
        printf "  %-10s %-12s %s\n", $1, $2, addresses
    }'
}

display_top_processes() {
    echo ""
    echo "--- TOP 5 PROCESSES (by CPU) ---"
    printf "  %-8s %-20s %-8s %-8s\n" "PID" "NAME" "CPU%" "MEM%"
    echo "  ----------------------------------------"
    ps aux --sort=-%cpu | awk 'NR>1 && NR<=6 {printf "  %-8s %-20s %-8s %-8s\n", $2, $11, $3, $4}'
}

display_uptime() {
    echo ""
    echo "--- SYSTEM UPTIME ---"
    echo "  $(uptime -p)"
}

display_footer() {
    echo ""
    echo "======================================================"
    echo "  Press Ctrl+C to exit"
    echo "======================================================"
}

# ── Main Loop ──
echo "Starting System Monitor... Press Ctrl+C to stop."
sleep 1

while true; do
    clear
    display_header
    display_cpu
    display_memory
    display_disk
    display_network
    display_top_processes
    display_uptime
    display_footer
    sleep $REFRESH
done
