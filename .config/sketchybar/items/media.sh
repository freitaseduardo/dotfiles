# Now playing (cover, title, artist); click the cover for playback controls.
# Players and paused behavior are set in settings.sh.
sketchybar --add event media_update
"$HELPERS/media_stream.sh" >/dev/null 2>&1 &

sketchybar --add item media.cover right \
           --set media.cover drawing=off \
                             updates=on \
                             icon.drawing=off label.drawing=off \
                             background.color=$TRANSPARENT \
                             background.image.scale=0.5 \
                             popup.align=center popup.horizontal=on \
                             script="$PLUGINS/media.sh" \
           --subscribe media.cover media_update mouse.clicked \
           --add item media.artist right \
           --set media.artist drawing=off \
                              padding_left=3 padding_right=0 \
                              width=0 \
                              icon.drawing=off \
                              label.font="$FONT:Semibold:9.0" \
                              label.color=0x99${WHITE:4} \
                              label.max_chars=18 \
                              label.y_offset=6 \
           --add item media.title right \
           --set media.title drawing=off \
                             padding_left=3 padding_right=0 \
                             icon.drawing=off \
                             label.font="$FONT:Semibold:11.0" \
                             label.max_chars=16 \
                             label.y_offset=-5 \
                             script="$PLUGINS/media.sh" \
           --subscribe media.title mouse.exited.global

for control in "back:previous-track:$ICON_MEDIA_BACK" \
               "play_pause:toggle-play-pause:$ICON_MEDIA_PLAY_PAUSE" \
               "forward:next-track:$ICON_MEDIA_FORWARD"; do
  IFS=: read -r name command icon <<< "$control"
  sketchybar --add item media.$name popup.media.cover \
             --set media.$name icon="$icon" label.drawing=off \
                               click_script="media-control $command"
done
