#!/bin/bash
# Lists and opens the focused app's menus through System Events.
# SketchyBar needs Accessibility access (System Settings -> Privacy & Security).
source "$CONFIG_DIR/settings.sh"
MENU_COUNT=15

# Menu names of the frontmost app, one per line, without the Apple menu
list_menus() {
  osascript 2>/dev/null <<'APPLESCRIPT' | tail -n +2
tell application "System Events"
  set names to name of every menu bar item of menu bar 1 of (first application process whose frontmost is true)
end tell
set AppleScript's text item delimiters to linefeed
return names as text
APPLESCRIPT
}

update_menus() {
  local args=(--set '/menu\..*/' drawing=off --set menu.padding drawing=on) i=1
  while IFS= read -r menu && [ $i -le $MENU_COUNT ]; do
    args+=(--set menu.$i label="$menu" drawing=on)
    i=$((i + 1))
  done < <(list_menus)
  sketchybar "${args[@]}"
}

# $1: 0 = Apple menu, n = nth app menu. Backgrounded: System Events
# blocks until the menu closes.
click_menu() {
  osascript -e "tell application \"System Events\" to click menu bar item $(($1 + 1)) of menu bar 1 of (first application process whose frontmost is true)" >/dev/null 2>&1 &
}

if [ "$1" = click ]; then
  click_menu "$2"
elif [ "$SENDER" = swap_menus_and_spaces ]; then
  if [ "$(sketchybar --query front_app | jq -r .geometry.drawing)" = off ]; then
    # Menus showing -> back to workspaces (spaces.sh re-hides empty ones)
    sketchybar --set menus.watcher updates=off \
               --set '/menu\..*/' drawing=off \
               --set '/space\..*/' drawing=on \
               --set front_app drawing=on
    "$CONFIG_DIR/plugins/spaces.sh"
  else
    sketchybar --set menus.watcher updates=on \
               --set '/space\..*/' drawing=off \
               --set front_app drawing=off
    update_menus
  fi
else
  update_menus
fi
