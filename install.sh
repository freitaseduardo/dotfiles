#!/usr/bin/env bash
# Set up a Mac after checking out the dotfiles into ~ (see README.md).
set -euo pipefail
cd ~

brew bundle --file Brewfile

# App icon font for the workspace pills (version must match helpers/icon_map.sh)
curl -fsSL -o ~/Library/Fonts/sketchybar-app-font.ttf \
  https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.28/sketchybar-app-font.ttf

[ -d ~/.oh-my-zsh ] || RUNZSH=no KEEP_ZSHRC=yes sh -c \
  "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# `cfg status` lists only tracked files, not all of ~
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config status.showUntrackedFiles no

brew services restart sketchybar
open -a AeroSpace
