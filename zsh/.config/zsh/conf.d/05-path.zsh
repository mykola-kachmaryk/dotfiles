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

# Previous setup, kept for reference. Loading nvm normally also runs
# `nvm use default`, which takes ~0.4 s on every new shell. To go back,
# uncomment the nvm.sh line and delete the "--no-use" block below.
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Load nvm without `nvm use` (~40 ms). nvm and its functions stay available
# (Herd's .nvmrc hook in 50-herd.zsh needs them); only the default Node is
# put on PATH here instead, which is all `nvm use default` did at startup.
if [[ -s $NVM_DIR/nvm.sh ]]; then
  . "$NVM_DIR/nvm.sh" --no-use
  # Default alias "24" -> highest installed v24.x (numeric sort, so v24.21 > v24.9)
  _nvm_bin=()
  [[ -r $NVM_DIR/alias/default ]] &&
    _nvm_bin=($NVM_DIR/versions/node/v${$(<$NVM_DIR/alias/default)#v}*/bin(N/nOn[1]))
  # Defaults like "lts/*" need nvm to resolve them: fall back to the slow way
  if [[ -n $_nvm_bin ]]; then
    # Same variables `nvm use` sets
    export NVM_BIN=$_nvm_bin NVM_INC=${_nvm_bin:h}/include/node
    export MANPATH="${_nvm_bin:h}/share/man:$MANPATH"
    path=($_nvm_bin $path)
  else
    nvm use --silent default
  fi
  unset _nvm_bin
fi

# nvm's completion: moved to 10-completion.zsh while testing without oh-my-zsh
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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
