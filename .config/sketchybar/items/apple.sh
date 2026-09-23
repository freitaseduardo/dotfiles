# Apple logo: opens the Apple menu of the focused app
sketchybar --add item apple.padding.left left \
           --set apple.padding.left width=5 \
           --add item apple left \
           --set apple icon=$ICON_APPLE \
                       icon.font="$FONT:Bold:16.0" \
                       icon.padding_left=8 icon.padding_right=8 \
                       label.drawing=off \
                       background.color=$BG2 \
                       background.border_color=$BLACK \
                       background.border_width=1 \
                       padding_left=1 padding_right=1 \
                       click_script="$PLUGINS/menus.sh click 0" \
           --add bracket apple.bracket apple \
           --set apple.bracket background.color=$TRANSPARENT \
                               background.height=30 \
                               background.border_color=$GREY \
           --add item apple.padding.right left \
           --set apple.padding.right width=7
