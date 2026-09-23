#!/bin/bash
source "$CONFIG_DIR/settings.sh"

case "$SENDER" in
  mouse.clicked)
    sketchybar --set media.cover popup.drawing=toggle; exit ;;
  mouse.exited.global)
    sketchybar --set media.cover popup.drawing=off; exit ;;
esac

# media_update: APP TITLE ARTIST STATE ARTWORK (see helpers/media_stream.sh)
allowed=false
if [ -z "$MEDIA_PLAYERS" ]; then allowed=true
else for player in $MEDIA_PLAYERS; do [ "$player" = "$APP" ] && allowed=true; done
fi

drawing=off
if [ "$allowed" = true ]; then
  [ "$STATE" = playing ] && drawing=on
  [ "$STATE" = paused ] && [ "$MEDIA_SHOW_WHEN_PAUSED" = true ] && drawing=on
fi

args=(--set media.artist drawing=$drawing label="$ARTIST"
      --set media.title drawing=$drawing label="$TITLE"
      --set media.cover drawing=$drawing)
# Cover art, or the player's app icon until the artwork arrives
if [ -n "$ARTWORK" ]; then
  args+=(background.image="$ARTWORK" background.image.scale=0.5)
elif [ -n "$APP" ]; then
  args+=(background.image="app.$APP" background.image.scale=0.85)
fi
[ "$drawing" = off ] && args+=(popup.drawing=off)
sketchybar "${args[@]}"
