# dotfiles

macOS setup: **AeroSpace** (tiling window manager, no SIP changes),
**SketchyBar** (status bar, plain shell config), and **zsh** with Starship.

## Install on a new Mac

```bash
git clone <repo-url> ~/Code/dotfiles
~/Code/dotfiles/install.sh
```

The script installs Homebrew packages from the `Brewfile`, the app icon
font and Oh My Zsh, backs up existing configs to `~/.dotfiles-backup/`,
links everything into `$HOME` with GNU Stow, starts SketchyBar and
AeroSpace, and optionally applies `macos.sh`.

Manual steps afterwards:

- Allow **AeroSpace** and **SketchyBar** in System Settings → Privacy &
  Security → Accessibility (SketchyBar needs it for the app-menu swap).
- Machine-specific shell settings and secrets go in `~/.zshrc.local`
  (not in the repo).
- **PC keyboard?** Swap Option ↔ Command for that keyboard in
  System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys,
  otherwise the `alt` bindings arrive as `cmd`.

## How it works

The repo can live anywhere (these docs assume `~/Code/dotfiles`).
`.stowrc` sets Stow's target to `$HOME`, so `stow <package>` run inside
the repo always links into your home folder.

Each top-level folder is a Stow *package* that mirrors `$HOME`:

```
aerospace/.config/aerospace/aerospace.toml  ->  ~/.config/aerospace/aerospace.toml
sketchybar/.config/sketchybar/              ->  ~/.config/sketchybar/
starship/.config/starship.toml              ->  ~/.config/starship.toml
zsh/.zshrc                                  ->  ~/.zshrc
```

Files in `$HOME` are symlinks into this repo, so editing
`~/.config/...` edits the repo. Commit and push as usual:

```bash
cd ~/Code/dotfiles
git add -A && git commit -m "Tweak bar" && git push
```

On another machine: `git pull` (and `sketchybar --reload`;
AeroSpace reloads its config automatically).

## Adding a new config

Example for git:

```bash
cd ~/Code/dotfiles
mkdir git
mv ~/.gitconfig git/.gitconfig
stow git           # ~/.gitconfig -> ~/Code/dotfiles/git/.gitconfig
```

Then add `git` to `PACKAGES` in `install.sh` (and a `backup` line for
the file it replaces). For anything under `~/.config/<app>`, use
`<app>/.config/<app>/...` as the layout.

New Homebrew packages go in the `Brewfile`
(`brew bundle dump --force --describe` writes one from what's installed).

**Never commit secrets** (tokens, SSH keys, `.env` files). Keep them in
a password manager or a local file that the config sources, e.g.
`[ -f ~/.zshrc.local ] && source ~/.zshrc.local`.

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

## zsh

`zsh/.zshrc` loads Oh My Zsh (git plugin), pyenv, nvm, Starship, and the
Homebrew autosuggestions/syntax-highlighting plugins.

**Auto-activating venvs:** entering a directory that has a `.venv/`
(or any subdirectory of one) activates it; leaving deactivates it. A venv
you activated by hand is left alone. New shells opened inside an active
venv (VS Code terminals, tmux, `zsh`) get a working `deactivate` too.

## SketchyBar

Plain shell, no Lua or compiled helpers:

```
sketchybarrc     bar + defaults, sources items/ in bar order
settings.sh      colors, fonts, icons, workspace list, now-playing players
items/*.sh       add and style each item
plugins/*.sh     run on events and clicks
helpers/         background streams (cpu, network, now playing) + app icon map
```

- **Workspaces** (`items/spaces.sh`) — AeroSpace workspaces; empty ones are
  hidden; left-click switches, right-click sends the focused window there.
  `WORKSPACES` in `settings.sh` must match `persistent-workspaces` in
  `aerospace.toml`.
- **App menus** — click the app name or the switch icon to swap the
  workspaces for the focused app's menus (via System Events).
- **Now playing** (`helpers/media_stream.sh`) — uses `media-control`
  (SketchyBar's `media_change` broke in macOS 15.4). Choose players with
  `MEDIA_PLAYERS` in `settings.sh`.
- **CPU / network** — fed by a long-running `top` and `netstat`.
- **App icons** — `helpers/icon_map.sh`; add a line for apps showing the
  default icon.

## Troubleshooting

- Bar errors: stop the service (`brew services stop sketchybar`) and run
  `sketchybar` in a terminal to see script errors.
- AeroSpace config errors: `aerospace reload-config`.
- Now playing empty: `media-control get` while music plays.

## License

The SketchyBar config is a shell port of
[FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles) (GPL-3.0),
so this repository is distributed under GPL-3.0 as well — see `LICENSE`.
