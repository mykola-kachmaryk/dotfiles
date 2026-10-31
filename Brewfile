# Packages for all machines.
#
#   brew bundle                     install everything (HOMEBREW_BUNDLE_FILE
#                                   points here, set in zsh conf.d/05-path.zsh)
#   brew bundle --file ~/dotfiles/Brewfile   first run, before zsh is set up
#   brew bundle add <name> [--cask] / brew bundle remove <name>
#   brew bundle cleanup             list installed packages missing from here
#
# Never run `brew bundle cleanup --force`: it can't see the dependencies of
# qmk (its whole toolchain) or of the npm entries (Homebrew's node), so it
# uninstalls them and breaks those tools.
#
# Edit by hand or with add/remove; `brew bundle dump --force` would drop the
# grouping and the macOS-only block below.

# Shell
brew "eza"
brew "fzf"
brew "starship"
brew "stow"
brew "tmux"
brew "yazi"
brew "zellij"
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
brew "lua-language-server"
brew "luarocks"
brew "ripgrep"
brew "tectonic"
brew "tree-sitter"
brew "tree-sitter-cli"

# Dev tools
tap "jesseduffield/lazydocker", trusted: { formulae: ["lazydocker"] }
brew "composer"
brew "deno"
brew "dos2unix"
brew "fnm"
brew "imagemagick"
brew "lazydocker"
brew "mysql"
brew "python@3.11"
brew "python@3.14"

# Global npm packages. Need Node from fnm, so on a new machine these only
# install on a second `brew bundle`, after `fnm install` (see README)
npm "@typescript/native-preview"
npm "corepack"

if OS.mac?
  tap "fif7y/tap", trusted: { casks: ["dimble"] }
  tap "minio/stable", trusted: { formulae: ["mc"] }
  tap "mutagen-io/mutagen", trusted: { formulae: ["mutagen", "mutagen-compose"] }
  tap "shivammathur/php", trusted: { formulae: ["php@7.4"] }
  # QMK keyboard firmware and the toolchains it pulls in
  tap "qmk/qmk", trusted: { formulae: ["qmk", "hid_bootloader_cli", "mdloader"] }
  tap "osx-cross/arm", trusted: { formulae: ["arm-none-eabi-binutils", "arm-none-eabi-gcc@8"] }
  tap "osx-cross/avr", trusted: { formulae: ["avr-binutils", "avr-gcc@8", "avr-gcc@9"] }

  # Tools from the taps above
  brew "mc"
  brew "mutagen"
  brew "mutagen-compose"
  brew "php@7.4"
  brew "qmk"
  brew "avr-gcc@9"

  # Apps
  cask "1password"
  cask "beekeeper-studio"
  cask "betterdisplay"
  cask "bruno"
  cask "claude"
  cask "claude-code"
  cask "dbeaver-community"
  cask "dimble" if MacOS.version >= :golden_gate # needs macOS 27
  cask "domzilla-caffeine"
  cask "figma"
  cask "fork"
  cask "gcc-arm-embedded"
  cask "ghostty"
  cask "herd"
  cask "iina"
  cask "insomnia"
  cask "iterm2"
  cask "kitty"
  cask "orbstack"
  cask "postman"
  cask "slack"
  cask "stats"
  cask "transmission"
  cask "vscodium"
  cask "wezterm"
  cask "zed"
  cask "zoom"

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
  vscode "enkia.tokyo-night"
  vscode "esbenp.prettier-vscode"
  vscode "laravel.vscode-laravel"
  vscode "mskelton.one-dark-theme"
  vscode "nerosiar.just-black"
  vscode "nicholashsiang.vscode-vue2-snippets"
  vscode "nicholashsiang.vscode-vue3-snippets"
  vscode "orta.vscode-jest"
  vscode "prisma.prisma"
  vscode "sanderronde.phpstan-vscode"
  vscode "vitest.explorer"
  vscode "vscode-icons-team.vscode-icons"
  vscode "vscodevim.vim"
  vscode "vue.volar"
  vscode "xavier-castro.vague-windsurf"
end
