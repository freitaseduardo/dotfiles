#!/usr/bin/env bash
# Bootstrap a Mac from this repo. Safe to run again.
#   git clone <repo-url> ~/Code/dotfiles && ~/Code/dotfiles/install.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(aerospace sketchybar zsh starship)  # stow packages (folders in this repo)
APP_FONT_VERSION="v2.0.28"               # must match sketchybar/helpers/icon_map.sh
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Packages
log "Installing Brewfile packages"
brew bundle --file "$DOTFILES/Brewfile"

# 3. App icon font for the workspace pills
font="$HOME/Library/Fonts/sketchybar-app-font.ttf"
if [ ! -f "$font" ]; then
  log "Installing sketchybar-app-font $APP_FONT_VERSION"
  curl -fsSL -o "$font" \
    "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/$APP_FONT_VERSION/sketchybar-app-font.ttf"
fi

# 4. Oh My Zsh (the zsh config sources it)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "Installing Oh My Zsh"
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 5. Back up real (non-symlink) configs that would block stow
backup() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
    echo "Backed up $target -> $BACKUP_DIR/"
  fi
}
backup "$HOME/.config/sketchybar"
backup "$HOME/.config/aerospace"
backup "$HOME/.aerospace.toml"   # AeroSpace refuses to start if two configs exist
backup "$HOME/.zshrc"
backup "$HOME/.config/starship.toml"

# 6. Symlink configs into $HOME
log "Linking configs with stow"
mkdir -p "$HOME/.config"
stow --dir "$DOTFILES" --target "$HOME" --restow "${PACKAGES[@]}"

# 7. Start services
log "Starting SketchyBar and AeroSpace"
brew services restart sketchybar
open -a AeroSpace || true

# 8. macOS settings (optional)
read -r -p "Apply macOS settings from macos.sh? [y/N] " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  "$DOTFILES/macos.sh"
fi

log "Done. Grant AeroSpace Accessibility access if macOS asks."
