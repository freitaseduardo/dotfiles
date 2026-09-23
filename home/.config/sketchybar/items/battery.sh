# Battery level; click shows the time remaining
sketchybar --add item widgets.battery right \
           --set widgets.battery icon.font="$FONT:Regular:19.0" \
                                 label.font="$NUMBER_FONT:Semibold:13.0" \
                                 update_freq=180 \
                                 popup.align=center \
                                 script="$PLUGINS/battery.sh" \
           --subscribe widgets.battery power_source_change system_woke mouse.clicked \
           --add item widgets.battery.remaining popup.widgets.battery \
           --set widgets.battery.remaining icon="Time remaining:" \
                                           icon.width=100 icon.align=left \
                                           label="??:??h" \
                                           label.width=100 label.align=right \
           --add bracket widgets.battery.bracket widgets.battery \
           --set widgets.battery.bracket background.color=$BG1 \
           --add item widgets.battery.padding right \
           --set widgets.battery.padding width=$GROUP_PADDINGS
