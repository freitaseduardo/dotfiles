# Install everything with: brew bundle --file ~/Code/dotfiles/Brewfile

tap "felixkratz/formulae"
tap "nikitabobko/tap"

# Dotfile management
brew "git"
brew "stow"

# Window manager + bar
cask "nikitabobko/tap/aerospace"
brew "felixkratz/formulae/sketchybar"
brew "lua"                 # SketchyBar config is written in Lua (SbarLua)

# SketchyBar widget dependencies
brew "switchaudio-osx"     # volume widget: switch output device
brew "media-control"       # now-playing widget (works on macOS 15.4+)
brew "jq"                  # parses media-control output

# Fonts used by the bar
cask "sf-symbols"
cask "font-sf-mono"
cask "font-sf-pro"
