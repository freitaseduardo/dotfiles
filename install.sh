#!/usr/bin/env bash
# Set up a Mac from this repo. Safe to run again (overwrites the configs in ~).
set -euo pipefail
cd "$(dirname "$0")"

brew bundle --file Brewfile

# App icon font for the workspace pills (version must match helpers/icon_map.sh)
curl -fsSL -o ~/Library/Fonts/sketchybar-app-font.ttf \
  https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf

[ -d ~/.oh-my-zsh ] || RUNZSH=no KEEP_ZSHRC=yes sh -c \
  "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cp -R home/. ~

brew services restart sketchybar
open -a AeroSpace
