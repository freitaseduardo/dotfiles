sketchybar --add item calendar.padding.right right \
           --set calendar.padding.right width=$GROUP_PADDINGS \
           --add item calendar right \
           --set calendar icon.color=$WHITE \
                          icon.padding_left=8 \
                          icon.font="$FONT:Black:12.0" \
                          label.color=$WHITE \
                          label.padding_right=8 \
                          label.width=49 \
                          label.align=right \
                          label.font="$NUMBER_FONT:Semibold:13.0" \
                          update_freq=30 \
                          padding_left=1 padding_right=1 \
                          background.color=$BG2 \
                          background.border_color=$BLACK \
                          background.border_width=1 \
                          click_script="open -a Calendar" \
                          script="$PLUGINS/calendar.sh" \
           --subscribe calendar system_woke \
           --add bracket calendar.bracket calendar \
           --set calendar.bracket background.color=$TRANSPARENT \
                                  background.height=30 \
                                  background.border_color=$GREY \
           --add item calendar.padding.left right \
           --set calendar.padding.left width=$GROUP_PADDINGS
