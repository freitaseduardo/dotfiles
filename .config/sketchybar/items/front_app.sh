# Name of the focused app; click swaps workspaces for its menus
sketchybar --add item front_app left \
           --set front_app display=active \
                           icon.drawing=off \
                           label.font="$FONT:Black:12.0" \
                           updates=on \
                           script="$PLUGINS/front_app.sh" \
           --subscribe front_app front_app_switched mouse.clicked
