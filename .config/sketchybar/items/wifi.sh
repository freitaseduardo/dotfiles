# Network speed (up/down) and Wi-Fi status; click for connection details,
# click a detail to copy it
POPUP_WIDTH=250
HALF=$((POPUP_WIDTH / 2))

# Background stream that fires network_update every 2 seconds
sketchybar --add event network_update
"$HELPERS/network_stream.sh" en0 >/dev/null 2>&1 &

sketchybar --add item widgets.wifi.up right \
           --set widgets.wifi.up padding_left=-5 width=0 y_offset=4 \
                                 icon=$ICON_WIFI_UPLOAD \
                                 icon.padding_right=0 \
                                 icon.font="$FONT:Bold:9.0" \
                                 label="??? Bps" \
                                 label.font="$NUMBER_FONT:Bold:9.0" \
                                 label.color=$RED \
                                 script="$PLUGINS/wifi.sh" \
           --subscribe widgets.wifi.up network_update mouse.clicked \
           --add item widgets.wifi.down right \
           --set widgets.wifi.down padding_left=-5 y_offset=-4 \
                                   icon=$ICON_WIFI_DOWNLOAD \
                                   icon.padding_right=0 \
                                   icon.font="$FONT:Bold:9.0" \
                                   label="??? Bps" \
                                   label.font="$NUMBER_FONT:Bold:9.0" \
                                   label.color=$BLUE \
                                   script="$PLUGINS/wifi.sh" \
           --subscribe widgets.wifi.down mouse.clicked \
           --add item widgets.wifi right \
           --set widgets.wifi label.drawing=off script="$PLUGINS/wifi.sh" \
           --subscribe widgets.wifi wifi_change system_woke mouse.clicked mouse.exited.global \
           --add bracket widgets.wifi.bracket widgets.wifi widgets.wifi.up widgets.wifi.down \
           --set widgets.wifi.bracket background.color=$BG1 popup.align=center popup.height=30 \
           --add item widgets.wifi.ssid popup.widgets.wifi.bracket \
           --set widgets.wifi.ssid icon=$ICON_WIFI_ROUTER \
                                   icon.font="$FONT:Bold:14.0" \
                                   width=$POPUP_WIDTH align=center \
                                   label="????????????" \
                                   label.font="$FONT:Bold:15.0" \
                                   label.max_chars=18 \
                                   background.height=2 \
                                   background.color=$GREY \
                                   background.y_offset=-15 \
                                   click_script="$PLUGINS/wifi.sh copy"

for row in "hostname:Hostname:" "ip:IP:" "mask:Subnet mask:" "router:Router:"; do
  sketchybar --add item widgets.wifi.${row%%:*} popup.widgets.wifi.bracket \
             --set widgets.wifi.${row%%:*} icon="${row#*:}" \
                                           icon.align=left icon.width=$HALF \
                                           label="???.???.???.???" \
                                           label.max_chars=20 \
                                           label.align=right label.width=$HALF \
                                           click_script="$PLUGINS/wifi.sh copy"
done

sketchybar --add item widgets.wifi.padding right \
           --set widgets.wifi.padding width=$GROUP_PADDINGS
