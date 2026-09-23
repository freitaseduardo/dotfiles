#!/usr/bin/env bash
# macOS settings that AeroSpace + SketchyBar expect. Safe to run again.
set -euo pipefail

# Auto-hide the menu bar so SketchyBar sits at the top of the screen
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Mission Control: group windows by app (AeroSpace hides windows off-screen,
# this keeps Mission Control readable)
defaults write com.apple.dock expose-group-apps -bool true

# "Displays have separate Spaces" OFF (recommended by AeroSpace for
# multi-monitor setups). Takes effect after logging out.
defaults write com.apple.spaces spans-displays -bool true

killall Dock SystemUIServer 2>/dev/null || true

echo "macOS settings applied. Log out and back in for the Spaces change."
