#!/bin/bash
# Fires `network_update` every 2 seconds with UPLOAD and DOWNLOAD for an
# interface (default en0), formatted like "000 Bps", "012KBps", "003MBps".
IFACE="${1:-en0}"
INTERVAL=2

pkill -f "netstat -I $IFACE -b -w $INTERVAL" 2>/dev/null   # previous instance (bar reload)

format() {
  local rate=$(($1 / INTERVAL))
  if   [ $rate -lt 1000 ];    then printf '%03d Bps' $rate
  elif [ $rate -lt 1000000 ]; then printf '%03dKBps' $((rate / 1000))
  else                             printf '%03dMBps' $((rate / 1000000))
  fi
}

# Columns: packets errs bytes (in) | packets errs bytes (out) | colls
netstat -I "$IFACE" -b -w $INTERVAL | while read -r _ _ in_bytes _ _ out_bytes _; do
  [[ $in_bytes =~ ^[0-9]+$ ]] || continue   # skip the repeated headers
  sketchybar --trigger network_update UPLOAD="$(format "$out_bytes")" DOWNLOAD="$(format "$in_bytes")"
done
