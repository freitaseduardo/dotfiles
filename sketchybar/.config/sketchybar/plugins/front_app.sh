#!/bin/bash
if [ "$SENDER" = mouse.clicked ]; then
  sketchybar --trigger swap_menus_and_spaces
else
  sketchybar --set "$NAME" label="$INFO"
fi
