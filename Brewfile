# Packages for all machines.
#
#   brew bundle                     install everything (HOMEBREW_BUNDLE_FILE
#                                   points here, set in zsh conf.d/05-path.zsh)
#   brew bundle --file ~/dotfiles/Brewfile   first run, before zsh is set up
#   brew bundle add <name> [--cask] / brew bundle remove <name>
#   brew bundle cleanup             list installed packages missing from here
#
# Edit by hand or with add/remove; `brew bundle dump --force` would drop the
# grouping and the macOS-only block below.

# Shell
brew "eza"
brew "fzf"
brew "starship"
brew "stow"
brew "tmux"
brew "zoxide"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# Git
brew "gh"
brew "git"
brew "gitleaks"
brew "lazygit"

# Neovim and LazyVim dependencies
brew "neovim"
brew "fd"
brew "ghostscript"
brew "luarocks"
brew "ripgrep"
brew "tectonic"
brew "tree-sitter"
brew "tree-sitter-cli"

# Dev tools
brew "composer"
brew "deno"
brew "fnm"
brew "lazydocker"

# Global npm packages. Need Node from fnm, so on a new machine these only
# install on a second `brew bundle`, after `fnm install` (see README)
npm "@typescript/native-preview"
npm "corepack"

if OS.mac?
  tap "fif7y/tap", trusted: { casks: ["dimble"] }

  # Apps
  cask "1password"
  cask "aldente"
  cask "beekeeper-studio"
  cask "betterdisplay"
  cask "caffeine"
  cask "claude"
  cask "claude-code"
  cask "dbeaver-community"
  cask "dimble"
  cask "fork"
  cask "ghostty"
  cask "herd"
  cask "orbstack"
  cask "slack"
  cask "stats"
  cask "vscodium"
  cask "zed"
  # Tiling window manager, not used for now (its dotfiles package is skipped
  # by install.sh by default)
  # cask "nikitabobko/tap/aerospace"

  # Fonts
  cask "font-jetbrains-mono"
  cask "font-meslo-lg-nerd-font"

  # VSCodium extensions
  vscode "bmewburn.vscode-intelephense-client"
  vscode "bradlc.vscode-tailwindcss"
  vscode "eamodio.gitlens"
  vscode "esbenp.prettier-vscode"
  vscode "laravel.vscode-laravel"
  vscode "sanderronde.phpstan-vscode"
  vscode "vscodevim.vim"
  vscode "xavier-castro.vague-windsurf"
end
