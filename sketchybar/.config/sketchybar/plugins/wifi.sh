#!/bin/bash
source "$CONFIG_DIR/settings.sh"
POPUP=widgets.wifi.bracket

# Click on a popup row: copy its value, flash a clipboard icon
if [ "$1" = copy ]; then
  value="$(sketchybar --query "$NAME" | jq -r .label.value)"
  printf '%s' "$value" | pbcopy
  sketchybar --set "$NAME" label=$ICON_CLIPBOARD label.align=center
  sleep 1
  sketchybar --set "$NAME" label="$value" label.align=right
  exit
fi

field() { awk -F "$1: " "/^$1: /"' { print $2 }'; }

case "$SENDER" in
  network_update)
    up_color=$RED down_color=$BLUE
    [ "$UPLOAD" = "000 Bps" ] && up_color=$GREY
    [ "$DOWNLOAD" = "000 Bps" ] && down_color=$GREY
    sketchybar --set widgets.wifi.up icon.color=$up_color label="$UPLOAD" label.color=$up_color \
               --set widgets.wifi.down icon.color=$down_color label="$DOWNLOAD" label.color=$down_color ;;
  mouse.clicked)
    if [ "$(sketchybar --query $POPUP | jq -r .popup.drawing)" = off ]; then
      info="$(networksetup -getinfo Wi-Fi)"
      sketchybar --set $POPUP popup.drawing=on \
                 --set widgets.wifi.ssid label="$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / { print $2 }')" \
                 --set widgets.wifi.hostname label="$(networksetup -getcomputername)" \
                 --set widgets.wifi.ip label="$(ipconfig getifaddr en0)" \
                 --set widgets.wifi.mask label="$(field "Subnet mask" <<< "$info")" \
                 --set widgets.wifi.router label="$(field Router <<< "$info")"
    else
      sketchybar --set $POPUP popup.drawing=off
    fi ;;
  mouse.exited.global)
    sketchybar --set $POPUP popup.drawing=off ;;
  *)  # wifi_change, system_woke, forced
    if [ -n "$(ipconfig getifaddr en0)" ]; then
      sketchybar --set widgets.wifi icon=$ICON_WIFI_CONNECTED icon.color=$WHITE
    else
      sketchybar --set widgets.wifi icon=$ICON_WIFI_DISCONNECTED icon.color=$RED
    fi ;;
esac
