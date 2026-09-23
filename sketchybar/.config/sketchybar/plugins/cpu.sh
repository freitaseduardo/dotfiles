#!/bin/bash
source "$CONFIG_DIR/settings.sh"
load=$TOTAL_LOAD   # from cpu_update

color=$BLUE
if   [ "$load" -ge 80 ]; then color=$RED
elif [ "$load" -ge 60 ]; then color=$ORANGE
elif [ "$load" -gt 30 ]; then color=$YELLOW
fi

sketchybar --push "$NAME" "$(awk -v l="$load" 'BEGIN { print l / 100 }')" \
           --set "$NAME" graph.color=$color label="cpu $(printf '%02d' "$load")%"
