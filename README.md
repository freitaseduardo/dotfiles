# dotfiles

macOS setup: AeroSpace (window manager), SketchyBar (status bar) and zsh
with Starship.

## Setup

Install [Homebrew](https://brew.sh), then:

```bash
git clone <repo-url> dotfiles && dotfiles/install.sh
```

Then allow AeroSpace and SketchyBar in System Settings → Privacy &
Security → Accessibility. Optional: `./macos.sh` (auto-hides the menu bar).

## Usage

`home/` mirrors your home folder and is copied into it. The copies are
independent of the repo:

- Repo → machine: `cp -R home/. ~` (or rerun `install.sh`)
- Machine → repo: copy the file back, e.g. `cp ~/.zshrc home/`

Secrets and machine-specific shell settings go in `~/.zshrc.local`, which
is not in the repo.

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
- Workspaces in `home/.config/sketchybar/settings.sh` must match
  `persistent-workspaces` in `aerospace.toml`.
- Bar errors: `brew services stop sketchybar`, then run `sketchybar` in a
  terminal to see them.

## License

The SketchyBar config is a shell port of
[FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles) (GPL-3.0),
so this repository is GPL-3.0 as well — see `LICENSE`.
