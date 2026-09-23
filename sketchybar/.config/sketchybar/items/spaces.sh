# AeroSpace workspaces: one pill per workspace with the icons of its apps.
# Empty workspaces are hidden unless focused. Left click switches,
# right click sends the focused window there.
sketchybar --add event aerospace_workspace_change \
           --add event aerospace_windows_change

for ws in $WORKSPACES; do
  sketchybar --add item space.$ws left \
             --set space.$ws icon=$ws \
                             icon.font="$NUMBER_FONT:Bold:14.0" \
                             icon.padding_left=15 icon.padding_right=8 \
                             icon.color=$WHITE \
                             icon.highlight_color=$RED \
                             label.font="sketchybar-app-font:Regular:16.0" \
                             label.padding_right=20 \
                             label.color=$GREY \
                             label.highlight_color=$WHITE \
                             label.y_offset=-1 \
                             padding_left=1 padding_right=1 \
                             background.color=$BG1 \
                             background.border_width=1 \
                             background.height=26 \
                             background.border_color=$BLACK \
                             click_script="$PLUGINS/spaces.sh click $ws" \
             --add bracket space.bracket.$ws space.$ws \
             --set space.bracket.$ws background.color=$TRANSPARENT \
                                     background.border_color=$BG2 \
                                     background.height=28 \
                                     background.border_width=2 \
             --add item space.padding.$ws left \
             --set space.padding.$ws width=$GROUP_PADDINGS
done

sketchybar --add item spaces.observer left \
           --set spaces.observer drawing=off updates=on script="$PLUGINS/spaces.sh" \
           --subscribe spaces.observer aerospace_workspace_change \
                                       aerospace_windows_change \
                                       space_windows_change \
                                       front_app_switched \
                                       system_woke

# Switch indicator: hover shows "Spaces", click swaps in the app menus
sketchybar --add item spaces.indicator left \
           --set spaces.indicator padding_left=-3 padding_right=0 \
                                  icon=$ICON_SWITCH_ON \
                                  icon.padding_left=8 icon.padding_right=9 \
                                  icon.color=$GREY \
                                  label=Spaces \
                                  label.width=0 \
                                  label.padding_left=0 label.padding_right=8 \
                                  label.color=$BG1 \
                                  background.color=0x00${GREY:4} \
                                  background.border_color=0x00${BG1:4} \
                                  script="$PLUGINS/spaces_indicator.sh" \
           --subscribe spaces.indicator swap_menus_and_spaces mouse.entered mouse.exited mouse.clicked
