# Menu bar of the focused app, swapped in place of the workspaces when
# clicking the front app name or the switch indicator
MENU_COUNT=15

sketchybar --add event swap_menus_and_spaces

for i in $(seq 1 $MENU_COUNT); do
  style=Semibold
  [ "$i" = 1 ] && style=Heavy   # app name menu
  sketchybar --add item menu.$i left \
             --set menu.$i drawing=off \
                           icon.drawing=off \
                           padding_left=$PADDINGS padding_right=$PADDINGS \
                           label.font="$FONT:$style:13.0" \
                           label.padding_left=6 label.padding_right=6 \
                           click_script="$PLUGINS/menus.sh click $i"
done

sketchybar --add bracket menus '/menu\..*/' \
           --set menus background.color=$BG1 \
           --add item menu.padding left \
           --set menu.padding drawing=off width=5 \
           --add item menus.watcher left \
           --set menus.watcher drawing=off updates=off script="$PLUGINS/menus.sh" \
           --subscribe menus.watcher front_app_switched \
           --add item menus.swap left \
           --set menus.swap drawing=off updates=on script="$PLUGINS/menus.sh" \
           --subscribe menus.swap swap_menus_and_spaces
