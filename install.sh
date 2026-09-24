#!/usr/bin/env bash
# Set up a Mac from scratch. Safe to run again: anything present is skipped.
#   Fresh Mac:  bash <(curl -fsSL <raw-url-of-this-file>) <repo-url>
#   Later:      ~/install.sh
set -euo pipefail

REPO_URL="${1:-}"
NVM_VERSION="v0.40.8"
APP_FONT_VERSION="v2.0.28"   # must match ~/.config/sketchybar/helpers/icon_map.sh

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }
cfg() { git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"; }

# Homebrew (its installer also installs the Xcode Command Line Tools, i.e. git)
if ! command -v brew >/dev/null; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Dotfiles: bare repo in ~/.dotfiles, checked out into ~
if [ ! -d ~/.dotfiles ]; then
  [ -n "$REPO_URL" ] || { echo "Usage: $0 <repo-url>" >&2; exit 1; }
  log "Checking out dotfiles into ~"
  git clone --bare "$REPO_URL" ~/.dotfiles
  cfg checkout   # stops without overwriting if a file already exists; move it and rerun
fi
cfg config status.showUntrackedFiles no

log "Installing Brewfile packages"
# Homebrew only loads formulae from third-party taps once they're trusted
brew trust --formula felixkratz/formulae/sketchybar
brew trust --cask nikitabobko/tap/aerospace
brew bundle --file ~/Brewfile

if [ ! -f ~/Library/Fonts/sketchybar-app-font.ttf ]; then
  log "Installing sketchybar-app-font"
  curl -fsSL -o ~/Library/Fonts/sketchybar-app-font.ttf \
    "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/$APP_FONT_VERSION/sketchybar-app-font.ttf"
fi

if [ ! -d ~/.oh-my-zsh ]; then
  log "Installing Oh My Zsh"
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d ~/.nvm ]; then
  log "Installing nvm"   # PROFILE=/dev/null: .zshrc already loads it
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | PROFILE=/dev/null bash
fi

log "Applying macOS settings"
~/macos.sh

log "Starting SketchyBar and AeroSpace"
brew services restart sketchybar
open -a AeroSpace

log "Done. Allow AeroSpace and SketchyBar in System Settings → Privacy & Security → Accessibility."
