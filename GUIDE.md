# Linux System Monitor — Step-by-Step Build Guide

## What You're Building
A Bash script that monitors your Linux system in real time — displaying CPU usage, RAM, disk, network interfaces, top processes, and uptime. Refreshes every 5 seconds in a loop.

---

## Prerequisites
- Linux terminal (Ubuntu / Debian / WSL)
- `bc` installed (for arithmetic): `sudo apt install bc`
- `iproute2` installed (for network): usually pre-installed

> This script is Linux-only. `/proc/stat`, `free`, and `ip` are not available on macOS.

---

## Step 1: Set Up Your Project Folder
```bash
mkdir linux-system-monitor
cd linux-system-monitor
touch sysmonitor.sh
chmod +x sysmonitor.sh
```

---

## Step 2: Understand the Structure

The script is built from modular functions, each responsible for one section:

| Function | What it shows |
|---|---|
| `display_header()` | Title, current date/time, refresh rate |
| `display_cpu()` | CPU usage % with visual bar |
| `display_memory()` | RAM used/free/total with visual bar |
| `display_disk()` | Disk usage per partition |
| `display_network()` | Active network interfaces and IPs |
| `display_top_processes()` | Top 5 processes by CPU usage |
| `display_uptime()` | How long the system has been running |
| `display_footer()` | Exit instructions |

The main loop calls all functions, clears the screen, then sleeps 5 seconds and repeats.

---

## Step 3: The Shebang Line
```bash
#!/bin/bash
```
Always the first line. Tells the OS to run this script with Bash.

---

## Step 4: CPU Usage (via /proc/stat delta)

Reading `/proc/stat` twice with a short gap and calculating the difference is the correct way to measure CPU usage — it measures actual work done over a time window rather than a snapshot.

```bash
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

CPU_USAGE=$(awk -v idle="$cpu_delta_idle" -v total="$cpu_delta_total" \
    'BEGIN { printf "%.1f", (total - idle) * 100 / total }')
```

**Why this approach:**
- `top -bn1` parses unreliably across distros and locales
- `/proc/stat` is a stable kernel interface — consistent everywhere
- The delta between two reads over 0.2s gives an accurate short-window average
- `$5` is idle time, `$6` is iowait — both are counted as non-busy

### Visual bar
```bash
FILLED=$(awk -v usage="$CPU_USAGE" 'BEGIN { print int(usage / 5) }')
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
for ((i=FILLED; i<20; i++)); do BAR+="░"; done
```
Divides usage by 5 to get how many of 20 blocks to fill. `int()` in awk safely truncates decimals, avoiding loop errors.

---

## Step 5: Memory Usage
```bash
TOTAL=$(free -m | awk '/Mem:/ {print $2}')
USED=$(free -m | awk '/Mem:/ {print $3}')
FREE=$(free -m | awk '/Mem:/ {print $4}')
PERCENT=$(echo "scale=1; $USED * 100 / $TOTAL" | bc)
```
- `free -m` — shows memory in megabytes
- `awk '/Mem:/'` — targets the Mem: row
- `bc` with `scale=1` — gives one decimal place for the percentage

---

## Step 6: Disk Usage
```bash
df -h --output=source,size,used,avail,pcent,target | grep -E "^/dev/"
```
- `df -h` — disk usage in human-readable format
- `--output=...` — selects specific columns
- `grep "^/dev/"` — filters out tmpfs and other virtual filesystems

---

## Step 7: Network Interfaces
```bash
ip -brief addr show | awk '{
    addresses = ""
    for (i = 3; i <= NF; i++) {
        addresses = addresses (i == 3 ? "" : " ") $i
    }
    printf "  %-10s %-12s %s\n", $1, $2, addresses
}'
```
- `ip -brief addr show` — compact interface listing
- The awk loop collects all IP addresses from field 3 onwards (an interface can have multiple)
- `printf` formats columns into aligned output

---

## Step 8: Top Processes
```bash
ps aux --sort=-%cpu | awk 'NR>1 && NR<=6 {printf "  %-8s %-20s %-8s %-8s\n", $2, $11, $3, $4}'
```
- `ps aux` — lists all running processes
- `--sort=-%cpu` — sorts by CPU descending
- `NR>1 && NR<=6` — skips the header row, takes the next 5

---

## Step 9: The Main Loop
```bash
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
```
- `while true` — runs until Ctrl+C
- `clear` — wipes the terminal before each refresh for a clean display
- `sleep $REFRESH` — waits 5 seconds between updates

---

## Step 10: Run It
```bash
chmod +x sysmonitor.sh   # only needed once
./sysmonitor.sh
```
Press `Ctrl+C` to exit.

---

## Step 11: Push to GitHub
```bash
git init
git add sysmonitor.sh README.md GUIDE.md
git commit -m "Initial commit: Linux System Monitor in Bash"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/linux-system-monitor.git
git push -u origin main
```

---

## Concepts This Project Demonstrates

| Concept | Where it appears |
|---|---|
| Bash scripting | Entire script |
| Modular functions | `display_*` functions |
| Loops | Main `while` loop, visual bar `for` loop |
| Process substitution | `read < <(...)` for capturing awk output |
| Linux kernel interfaces | `/proc/stat` for CPU data |
| Linux system commands | `free`, `df`, `ps`, `ip`, `uptime` |
| Text processing | `awk`, `grep` for parsing command output |
| Arithmetic | `bc` for memory percentage, `awk` for CPU |
| Integer handling | `int()` in awk to safely truncate decimals |
| Process management | `ps aux` sorted by CPU |
| Formatted output | `printf` for aligned columns |
