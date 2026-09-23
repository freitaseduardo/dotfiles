#!/bin/bash
# Highlights the focused workspace and shows each workspace's app icons.
source "$CONFIG_DIR/settings.sh"
source "$CONFIG_DIR/helpers/icon_map.sh"

if [ "$1" = click ]; then
  if [ "$BUTTON" = right ]; then
    aerospace move-node-to-workspace "$2"
  else
    aerospace workspace "$2"
    exit   # AeroSpace fires aerospace_workspace_change
  fi
fi

focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
windows="$(aerospace list-windows --all --format '%{workspace}|%{app-name}')"
# While the app menus are swapped in, keep every workspace hidden
menus_shown=false
[ "$(sketchybar --query front_app | jq -r .geometry.drawing)" = off ] && menus_shown=true

args=(--animate tanh 10)
for ws in $WORKSPACES; do
  icons=""
  while IFS= read -r app; do
    [ -n "$app" ] && icons+="$(icon_map "$app")"
  done < <(awk -F'|' -v ws="$ws" '$1 == ws { print $2 }' <<< "$windows" | sort -u)

  visible=off
  [ "$menus_shown" = false ] && { [ -n "$icons" ] || [ "$ws" = "$focused" ]; } && visible=on

  if [ "$ws" = "$focused" ]; then
    selected=on border=$BLACK bracket_border=$GREY
  else
    selected=off border=$BG2 bracket_border=$BG2
  fi

  args+=(--set space.$ws drawing=$visible label="${icons:- —}"
                         icon.highlight=$selected label.highlight=$selected
                         background.border_color=$border
         --set space.bracket.$ws drawing=$visible background.border_color=$bracket_border
         --set space.padding.$ws drawing=$visible)
done
sketchybar "${args[@]}"
