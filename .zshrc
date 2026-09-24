# =============================================================================
# PATH
# =============================================================================
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export PATH=/Library/PostgreSQL/18/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.lmstudio/bin"

# =============================================================================
# Oh My Zsh
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""            # prompt comes from Starship
plugins=(git)
source $ZSH/oh-my-zsh.sh

# =============================================================================
# pyenv
# =============================================================================
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# =============================================================================
# Python virtual environment — auto activate/deactivate on directory change
# =============================================================================
autoload -U add-zsh-hook

auto_activate_venv() {
  local dir="$PWD"
  local venv_path=""

  # Walk up the directory tree looking for a .venv folder
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.venv/bin/activate" ]]; then
      venv_path="$dir/.venv"
      break
    fi
    dir="${dir:h}"
  done

  if [[ -n "$venv_path" ]]; then
    # Activate if a different venv is active, or if this shell inherited
    # VIRTUAL_ENV from a parent shell without the deactivate function
    if [[ "${VIRTUAL_ENV:A}" != "${venv_path:A}" ]] || ! typeset -f deactivate >/dev/null; then
      source "$venv_path/bin/activate"
      _AUTO_VENV="$VIRTUAL_ENV"
    fi
  elif [[ -n "$_AUTO_VENV" && "$VIRTUAL_ENV" == "$_AUTO_VENV" ]]; then
    # Left the project — deactivate, but only a venv this hook activated
    deactivate
    unset _AUTO_VENV
  fi
}

add-zsh-hook chpwd auto_activate_venv
auto_activate_venv  # Run once on shell startup

# =============================================================================
# NVM (Node Version Manager)
# =============================================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# =============================================================================
# Dotfiles: bare repo in ~/.dotfiles, working tree is ~ (see ~/README.md)
# =============================================================================
alias cfg='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# =============================================================================
# Machine-local settings and secrets (not in the repo)
# =============================================================================
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# =============================================================================
# Starship prompt
# =============================================================================
eval "$(starship init zsh)"

# =============================================================================
# Homebrew plugins (syntax highlighting must be sourced last)
# =============================================================================
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
