# Volume: scroll to change (ctrl for fine steps), left click for a slider
# and output devices, right click for Sound settings
POPUP_WIDTH=250

sketchybar --add item widgets.volume.percent right \
           --set widgets.volume.percent icon.drawing=off \
                                        label="??%" \
                                        label.padding_left=-1 \
                                        label.font="$NUMBER_FONT:Semibold:13.0" \
                                        script="$PLUGINS/volume.sh" \
           --subscribe widgets.volume.percent volume_change mouse.clicked mouse.scrolled mouse.exited.global \
           --add item widgets.volume.icon right \
           --set widgets.volume.icon padding_right=-1 \
                                     icon=$ICON_VOLUME_100 \
                                     icon.width=0 icon.align=left \
                                     icon.color=$GREY \
                                     icon.font="$FONT:Regular:14.0" \
                                     label.width=25 label.align=left \
                                     label.font="$FONT:Regular:14.0" \
                                     script="$PLUGINS/volume.sh" \
           --subscribe widgets.volume.icon mouse.clicked mouse.scrolled \
           --add bracket widgets.volume.bracket widgets.volume.icon widgets.volume.percent \
           --set widgets.volume.bracket background.color=$BG1 popup.align=center \
           --add item widgets.volume.padding right \
           --set widgets.volume.padding width=$GROUP_PADDINGS \
           --add slider widgets.volume.slider popup.widgets.volume.bracket $POPUP_WIDTH \
           --set widgets.volume.slider slider.highlight_color=$BLUE \
                                       slider.background.height=6 \
                                       slider.background.corner_radius=3 \
                                       slider.background.color=$BG2 \
                                       slider.knob=$ICON_VOLUME_KNOB \
                                       slider.knob.drawing=on \
                                       background.color=$BG1 \
                                       background.height=2 \
                                       background.y_offset=-20 \
                                       click_script='osascript -e "set volume output volume $PERCENTAGE"'
