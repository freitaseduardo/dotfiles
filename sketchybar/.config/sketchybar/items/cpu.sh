# CPU load graph; click opens Activity Monitor
sketchybar --add event cpu_update
"$HELPERS/cpu_stream.sh" >/dev/null 2>&1 &

sketchybar --add graph widgets.cpu right 42 \
           --set widgets.cpu graph.color=$BLUE \
                             background.height=22 \
                             background.color=$TRANSPARENT \
                             background.border_color=$TRANSPARENT \
                             background.drawing=on \
                             icon=$ICON_CPU \
                             label="cpu ??%" \
                             label.font="$NUMBER_FONT:Bold:9.0" \
                             label.align=right \
                             label.padding_right=0 \
                             label.width=0 \
                             label.y_offset=4 \
                             padding_right=$((PADDINGS + 6)) \
                             click_script="open -a 'Activity Monitor'" \
                             script="$PLUGINS/cpu.sh" \
           --subscribe widgets.cpu cpu_update \
           --add bracket widgets.cpu.bracket widgets.cpu \
           --set widgets.cpu.bracket background.color=$BG1 \
           --add item widgets.cpu.padding right \
           --set widgets.cpu.padding width=$GROUP_PADDINGS
