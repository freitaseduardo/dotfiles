#!/bin/bash
source "$CONFIG_DIR/settings.sh"
info="$(pmset -g batt)"

if [ "$SENDER" = mouse.clicked ]; then
  if [ "$(sketchybar --query "$NAME" | jq -r .popup.drawing)" = off ]; then
    remaining="$(grep -Eo '[0-9]+:[0-9]+ remaining' <<< "$info" | cut -d' ' -f1)"
    sketchybar --set widgets.battery.remaining label="${remaining:+${remaining}h}${remaining:-No estimate}"
  fi
  sketchybar --set "$NAME" popup.drawing=toggle
  exit
fi

charge="$(grep -Eo '[0-9]+%' <<< "$info" | head -1 | tr -d %)"
color=$GREEN
if grep -q "AC Power" <<< "$info"; then
  icon=$ICON_BATTERY_CHARGING
elif [ -z "$charge" ]; then
  icon=$ICON_BATTERY_0 color=$RED
elif [ "$charge" -gt 80 ]; then icon=$ICON_BATTERY_100
elif [ "$charge" -gt 60 ]; then icon=$ICON_BATTERY_75
elif [ "$charge" -gt 40 ]; then icon=$ICON_BATTERY_50
elif [ "$charge" -gt 20 ]; then icon=$ICON_BATTERY_25 color=$ORANGE
else icon=$ICON_BATTERY_0 color=$RED
fi

sketchybar --set "$NAME" icon="$icon" icon.color=$color label="$(printf '%02d%%' "${charge:-0}")"
