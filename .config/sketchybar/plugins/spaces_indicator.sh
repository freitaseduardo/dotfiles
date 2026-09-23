#!/bin/bash
source "$CONFIG_DIR/settings.sh"

case "$SENDER" in
  swap_menus_and_spaces)
    if [ "$(sketchybar --query "$NAME" | jq -r .icon.value)" = "$ICON_SWITCH_ON" ]; then
      sketchybar --set "$NAME" icon=$ICON_SWITCH_OFF
    else
      sketchybar --set "$NAME" icon=$ICON_SWITCH_ON
    fi ;;
  mouse.entered)
    sketchybar --animate tanh 30 --set "$NAME" background.color=$GREY \
                                               background.border_color=$BG1 \
                                               icon.color=$BG1 \
                                               label.width=dynamic ;;
  mouse.exited)
    sketchybar --animate tanh 30 --set "$NAME" background.color=0x00${GREY:4} \
                                               background.border_color=0x00${BG1:4} \
                                               icon.color=$GREY \
                                               label.width=0 ;;
  mouse.clicked)
    sketchybar --trigger swap_menus_and_spaces ;;
esac
