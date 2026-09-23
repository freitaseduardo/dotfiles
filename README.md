# dotfiles

macOS setup: **AeroSpace** (tiling window manager, no SIP changes) +
**SketchyBar** (status bar, based on [FelixKratz's config](https://github.com/FelixKratz/dotfiles)).

## Install on a new Mac

```bash
git clone <repo-url> ~/Code/dotfiles
~/Code/dotfiles/install.sh
```

The script installs Homebrew packages from the `Brewfile`, SbarLua and the
app icon font, backs up existing configs to `~/.dotfiles-backup/`, links
everything into `$HOME` with GNU Stow, starts SketchyBar and AeroSpace,
and optionally applies `macos.sh`.

Manual steps afterwards:

- Allow **AeroSpace** in System Settings → Privacy & Security → Accessibility.
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

Example for zsh:

```bash
cd ~/Code/dotfiles
mkdir zsh
mv ~/.zshrc zsh/.zshrc
stow zsh           # ~/.zshrc -> ~/Code/dotfiles/zsh/.zshrc
```

Then add `zsh` to `PACKAGES` in `install.sh`. For anything under
`~/.config/<app>`, use `<app>/.config/<app>/...` as the layout.

New Homebrew packages go in the `Brewfile`
(`brew bundle dump --force --describe` writes one from what's installed).

**Never commit secrets** (tokens, SSH keys, `.env` files). Keep them in
a password manager or a local file that the config sources, e.g.
`[ -f ~/.zshrc.local ] && source ~/.zshrc.local`.

## Key bindings (AeroSpace)

Based on Felix's skhd bindings, with vim-style directions.

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

## SketchyBar changes vs. Felix's config

- `items/spaces.lua` — AeroSpace workspaces instead of yabai/native Spaces;
  empty workspaces are hidden; left-click switches, right-click sends the
  focused window there. Workspace list must match `persistent-workspaces`
  in `aerospace.toml`.
- `items/media.lua` + `helpers/media_stream.sh` — now-playing via
  `media-control` (SketchyBar's `media_change` and `nowplaying-cli` broke in
  macOS 15.4); covers resized to thumbnails; title/artist always visible.
  Edit the `whitelist` table to choose which players show.

## Troubleshooting

- Bar errors: run `sketchybar --reload` in a terminal and read the output.
- AeroSpace config errors: `aerospace reload-config`.
- Now playing empty: `media-control get` while music plays.

## License

The SketchyBar config is derived from FelixKratz/dotfiles (GPL-3.0),
so this repository is distributed under GPL-3.0 as well — see `LICENSE`.
