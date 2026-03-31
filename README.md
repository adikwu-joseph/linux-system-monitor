# Linux System Monitor — Bash

A lightweight real-time system monitoring script written in Bash. Displays CPU usage, RAM, disk usage, network interfaces, top processes, and system uptime — refreshing every 5 seconds.

---

## Features
- Real-time CPU usage measured via `/proc/stat` delta (accurate, no `top` dependency)
- RAM usage (used / free / total) with visual progress bar
- Disk usage per physical partition
- Active network interfaces and IP addresses
- Top 5 processes by CPU consumption
- System uptime
- Auto-refresh every 5 seconds

---

## Preview
```
======================================================
           LINUX SYSTEM MONITOR
   2026-03-28 14:32:01   |   Refreshes every 5s
======================================================

--- CPU USAGE ---
  Usage: 23.4%
  [████░░░░░░░░░░░░░░░░]

--- MEMORY (RAM) ---
  Total:  7856 MB
  Used:   3102 MB  (39.5%)
  Free:   4754 MB
  [████████░░░░░░░░░░░░]

--- DISK USAGE ---
  /dev/sda1   50G   18G   32G   36%   /

--- NETWORK INTERFACES ---
  eth0       UP           192.168.1.5/24

--- TOP 5 PROCESSES (by CPU) ---
  PID      NAME                 CPU%     MEM%
  ----------------------------------------
  1234     firefox              12.3     4.1
  5678     code                 8.1      3.2

--- SYSTEM UPTIME ---
  up 3 hours, 42 minutes
```

---

## Requirements
- Linux (Ubuntu / Debian / WSL)
- `bc` — for memory percentage arithmetic
- `iproute2` — for network interface display (pre-installed on most distros)

```bash
sudo apt install bc
```

> This script will not run on macOS. Commands like `free`, `ip`, and `/proc/stat` are Linux-specific.

---

## Getting Started

```bash
git clone https://github.com/YOUR_USERNAME/linux-system-monitor.git
cd linux-system-monitor
chmod +x sysmonitor.sh
./sysmonitor.sh
```

Press `Ctrl+C` to exit.

---

## Customisation
Change the refresh rate by editing line 7:
```bash
REFRESH=5  # change to any number of seconds
```

---

## Concepts Demonstrated
- Bash scripting and modular functions
- Reading system data from `/proc/stat` for accurate CPU measurement
- Linux commands: `free`, `df`, `ps`, `ip`, `uptime`
- Text processing with `awk` and `grep`
- Arithmetic with `bc` and `awk`
- Process management and sorting with `ps aux`
- Formatted terminal output with `printf`

---

## Author
Built as part of a Linux/Bash learning track alongside a Software Engineering job search.
