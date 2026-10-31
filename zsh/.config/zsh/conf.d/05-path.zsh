# keep PATH entries unique
typeset -U path

# Homebrew: Apple Silicon, Intel Mac, Linux
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x $brew ]]; then
    eval "$($brew shellenv)"
    break
  fi
done
unset brew

# `brew bundle` uses ~/dotfiles/Brewfile from any directory
export HOMEBREW_BUNDLE_FILE="$HOME/dotfiles/Brewfile"

# fnm: Node version manager (loaded before the PATH prepends below). Puts the
# default Node on PATH and switches version on cd into a project with .nvmrc /
# .node-version, also from its subfolders ("recursive"). Herd's app and sites
# use their own bundled nvm, so they're not affected.
# Homebrew's fnm is on PATH already; Linux's install script puts it in
# ~/.local/bin, which is only added to PATH further down
_fnm=${commands[fnm]:-$HOME/.local/bin/fnm}
[[ -x $_fnm ]] && eval "$($_fnm env --use-on-cd --version-file-strategy recursive --shell zsh)"
unset _fnm

if [[ $OSTYPE == darwin* ]]; then
  # Herd injected PHP binary.
  export PATH="$HOME/Library/Application Support/Herd/bin/":$PATH

  path=($HOME/Library/Python/3.*/bin(N) $path)

  # Herd injected PHP configuration: one ini scan dir per PHP version that
  # Herd has installed (config/php/85 -> HERD_PHP_85_INI_SCAN_DIR)
  for _php in "$HOME/Library/Application Support/Herd/config/php"/<->(N/); do
    export "HERD_PHP_${_php:t}_INI_SCAN_DIR=$_php/"
  done
  unset _php
fi

# user-installed tools (pipx, uv, ...)
export PATH="$HOME/.local/bin:$PATH"

# bun global packages (bun add -g). Install bun itself with the Brewfile
# (`brew "bun"`); uncomment this only if you install global packages with it
# [[ -d ~/.bun/bin ]] && path=(~/.bun/bin $path)

# Typescript LSP
export NODE_OPTIONS="--max-old-space-size=4096"

# pnpm
if [[ $OSTYPE == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
fi
case ":$PATH:" in
  ":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
