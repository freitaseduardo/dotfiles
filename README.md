# dotfiles

macOS setup: AeroSpace (window manager), SketchyBar (status bar),
JankyBorders (window borders), and zsh with Starship.

## Setup

The repo is checked out straight into your home folder: git data lives in
`~/.dotfiles`, the files are the real `~/.zshrc`, `~/.config/...`.
Existing files with the same names are not overwritten (checkout stops).

On a fresh Mac:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/freitaseduardo/dotfiles/main/install.sh)
```

It installs Homebrew (which brings the Xcode Command Line Tools and git),
clones the bare repo into `~/.dotfiles` and checks it out into `~`, then
installs the Brewfile, the app icon font, Oh My Zsh and nvm, and applies
the macOS settings in `macos.sh` (log out afterwards for all of them to
take effect). Anything
already present is skipped, so `~/install.sh` is safe to rerun.

Then allow AeroSpace and SketchyBar in System Settings → Privacy &
Security → Accessibility.

## Usage

`cfg` (an alias in `.zshrc`) is git for this repo. Edit configs in place,
then:

```bash
cfg status                      # only tracked files are listed
cfg commit -am "Tweak bar"
cfg add ~/.config/foo/config    # track a new file; add by name, never `cfg add .`
cfg push
```

Secrets and machine-specific shell settings go in `~/.zshrc.local`, which
is not tracked.

## Key bindings (AeroSpace)

Vim-style directions.

| Keys | Action |
|---|---|
| alt + 1–9 | Switch to workspace |
| alt + shift + 1–9 | Send window to workspace |
| alt + shift + p / n | Send window to previous / next workspace and follow |
| alt + h/j/k/l | Focus left / down / up / right (crosses monitors) |
| alt + shift + h/j/k/l | Move window |
| ctrl + shift + h/j/k/l | Join with neighbouring window |
| ctrl + shift + n / p | Focus next / previous window |
| ctrl + alt + h/j/k/l | Resize (h narrower, l wider, j taller, k shorter) |
| ctrl + alt + e | Equalize window sizes |
| alt + space | Float / tile window |
| alt + shift + f | Fullscreen |
| alt + shift + s | Toggle split orientation |
| alt + , / alt + / | Accordion / tiles layout |
| alt + shift + r | Reload AeroSpace config |
| alt + shift + space | Hide / show SketchyBar |

## Notes

- `.venv` folders are activated automatically when you `cd` into a
  project and deactivated when you leave.
- Workspaces in `~/.config/sketchybar/settings.sh` must match
  `persistent-workspaces` in `aerospace.toml`.
- Bar errors: `brew services stop sketchybar`, then run `sketchybar` in a
  terminal to see them.

## License

The SketchyBar config is a shell port of
[FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles) (GPL-3.0),
so this repository is GPL-3.0 as well — see `LICENSE`.
