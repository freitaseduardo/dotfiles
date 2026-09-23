#!/usr/bin/env bash
# ~/.config/sketchybar/helpers/media_stream.sh
# Streams now-playing info from media-control and forwards it to SketchyBar
# as the custom `media_update` event. Replaces SketchyBar's built-in
# `media_change` event, which stopped working in macOS 15.4.
#
# Requires: brew install media-control jq

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

ART_DIR="${TMPDIR:-/tmp}/sketchybar_media"
mkdir -p "$ART_DIR"

# Only one instance: stop the previous one (SketchyBar reloads start a new one)
PIDFILE="$ART_DIR/pids"
if [ -f "$PIDFILE" ]; then
  read -r old_sh old_mc < "$PIDFILE"
  for pid in $old_mc $old_sh; do
    # only kill if the PID still belongs to us (PIDs get reused)
    ps -p "$pid" -o command= 2>/dev/null | grep -q "media" && kill "$pid" 2>/dev/null
  done
fi

FIFO="$ART_DIR/stream"
rm -f "$FIFO" && mkfifo "$FIFO"
media-control stream --no-diff --debounce=200 > "$FIFO" &
echo "$$ $!" > "$PIDFILE"

last_track=""
art_path=""

while IFS= read -r line; do
  fields=$(jq -r 'select(has("payload")) | .payload
    | [(.bundleIdentifier // ""), (.title // ""), (.artist // ""), ((.playing // false) | tostring)]
    | join("\u001f")' <<< "$line" 2>/dev/null) || continue
  [ -z "$fields" ] && continue   # not a now-playing message
  # \x1f separator (not tabs): empty fields would collapse with whitespace IFS
  IFS=$'\x1f' read -r app title artist playing <<< "$fields"

  # New track: forget the old cover
  track="$app|$title|$artist"
  if [ "$track" != "$last_track" ]; then
    last_track="$track"
    rm -f "$ART_DIR"/cover_*
    art_path=""
  fi

  # Artwork often arrives a moment after the title, so keep trying until we have it.
  # A new file name per track makes SketchyBar reload the image.
  if [ -z "$art_path" ]; then
    candidate="$ART_DIR/cover_$(printf '%s' "$track" | cksum | cut -d' ' -f1)"
    if jq -r '.payload.artworkData // empty' <<< "$line" | base64 -d > "$candidate" 2>/dev/null \
       && [ -s "$candidate" ]; then
      # Players send full-size covers (often 640px+); shrink to a bar-sized
      # thumbnail. 52px shown at scale 0.5 = 26pt, sharp on Retina.
      sips -z 52 52 "$candidate" >/dev/null 2>&1
      art_path="$candidate"
    else
      rm -f "$candidate"
    fi
  fi

  state="paused"
  [ "$playing" = "true" ] && state="playing"
  [ -z "$title" ] && state="stopped"

  sketchybar --trigger media_update \
    APP="$app" TITLE="$title" ARTIST="$artist" STATE="$state" ARTWORK="$art_path"
done < "$FIFO"
