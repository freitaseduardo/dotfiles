#!/bin/bash
# Fires `cpu_update` every 2 seconds with TOTAL_LOAD (0-100), read from a
# single long-running `top` instead of polling.
INTERVAL=2

pkill -f "top -l 0 -s $INTERVAL -n 0" 2>/dev/null   # previous instance (bar reload)

top -l 0 -s $INTERVAL -n 0 | while read -r line; do
  # "CPU usage: 5.72% user, 2.90% sys, 91.36% idle"
  [[ $line == "CPU usage:"* ]] || continue
  idle="${line##*, }"; idle="${idle%%.*}"
  sketchybar --trigger cpu_update TOTAL_LOAD=$((100 - idle))
done
