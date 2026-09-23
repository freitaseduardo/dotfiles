#!/bin/bash
source "$CONFIG_DIR/settings.sh"
POPUP=widgets.volume.bracket
POPUP_WIDTH=250

collapse() {
  [ "$(sketchybar --query $POPUP | jq -r .popup.drawing)" = on ] || return
  sketchybar --set $POPUP popup.drawing=off --remove '/volume\.device\..*/'
}

# Popup with the slider and one row per output device (click to switch)
expand() {
  local current device n=0 color
  local args=(--remove '/volume\.device\..*/' --set $POPUP popup.drawing=on)
  current="$(SwitchAudioSource -t output -c)"
  while IFS= read -r device; do
    color=$GREY
    [ "$device" = "$current" ] && color=$WHITE
    args+=(--add item volume.device.$n popup.$POPUP
           --set volume.device.$n width=$POPUP_WIDTH align=center
                                  label="$device" label.color=$color
                                  click_script="SwitchAudioSource -s \"$device\" && sketchybar --set '/volume\.device\..*/' label.color=$GREY --set \$NAME label.color=$WHITE")
    n=$((n + 1))
  done < <(SwitchAudioSource -a -t output)
  sketchybar "${args[@]}"
}

case "$SENDER" in
  volume_change)
    volume=$INFO
    if   [ "$volume" -gt 60 ]; then icon=$ICON_VOLUME_100
    elif [ "$volume" -gt 30 ]; then icon=$ICON_VOLUME_66
    elif [ "$volume" -gt 10 ]; then icon=$ICON_VOLUME_33
    elif [ "$volume" -gt 0 ];  then icon=$ICON_VOLUME_10
    else icon=$ICON_VOLUME_0
    fi
    sketchybar --set widgets.volume.icon label=$icon \
               --set widgets.volume.percent label="$(printf '%02d%%' "$volume")" \
               --set widgets.volume.slider slider.percentage=$volume ;;
  mouse.clicked)
    if [ "$BUTTON" = right ]; then
      open /System/Library/PreferencePanes/Sound.prefpane
    elif [ "$(sketchybar --query $POPUP | jq -r .popup.drawing)" = off ]; then
      expand
    else
      collapse
    fi ;;
  mouse.exited.global)
    collapse ;;
  mouse.scrolled)
    delta=$SCROLL_DELTA
    [ "$MODIFIER" = ctrl ] || delta=$((delta * 10))
    osascript -e "set volume output volume (output volume of (get volume settings) + $delta)" ;;
esac
