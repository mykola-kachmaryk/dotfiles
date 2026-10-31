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

# nvm (loaded before the PATH prepends below, as originally)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if [[ $OSTYPE == darwin* ]]; then
  # Herd injected PHP binary.
  export PATH="$HOME/Library/Application Support/Herd/bin/":$PATH

  path=($HOME/Library/Python/3.*/bin(N) $path)

  # Herd injected PHP configuration.
  export HERD_PHP_74_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/74/"
  export HERD_PHP_82_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/82/"
  export HERD_PHP_83_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/83/"
  export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"
  export HERD_PHP_85_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/85/"
fi

# deno
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

# user-installed tools (pipx, uv, ...)
export PATH="$HOME/.local/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

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
