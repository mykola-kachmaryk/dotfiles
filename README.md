### Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a package whose contents mirror `$HOME`:

```
~/dotfiles/
├── ghostty/.config/ghostty/         → ~/.config/ghostty
├── nvim/.config/nvim/               → ~/.config/nvim
├── starship/.config/starship.toml   → ~/.config/starship.toml
├── tmux/.config/tmux/tmux.conf      → ~/.config/tmux/tmux.conf
├── zsh/.zshenv                      → ~/.zshenv
├── zsh/.config/zsh/...              → ~/.config/zsh/...
├── install.sh                       # set up a new machine
└── .stowrc                          # stow defaults: target ~, ignore .DS_Store
```

Works on macOS and Linux.

#### New machine

```sh
brew install stow git                 # macOS
sudo apt install stow git             # Ubuntu/Debian

git clone <repo> ~/dotfiles && cd ~/dotfiles
./install.sh -n                       # dry run: what would be backed up and linked
./install.sh                          # all packages, or e.g. ./install.sh zsh tmux
```

Then install each package's tools and do its "after" steps below.

`install.sh`:

- moves conflicting files to `~/.dotfiles-backup/<timestamp>/`
- keeps `~/.config`, `~/.config/zsh` and `~/.config/tmux` as real
  directories, so stow doesn't link them into this repo and local files
  (secrets, tmux plugins) stay out of it (`REAL_DIRS` in the script)
- creates `~/.config/zsh/secrets.zsh` with mode 600
- is safe to re-run

To link a package with plain stow instead, use the "stow" commands in its
section. Run them from `~/dotfiles`, and keep the `mkdir -p` line: if the
directory doesn't exist, stow links the whole directory into this repo.

#### Packages

##### ghostty

Terminal config (`~/.config/ghostty`). `auto/theme.ghostty` holds the theme
picked in Ghostty; commit it when it changes.

```sh
# install
brew install --cask ghostty           # macOS
                                      # Linux: https://ghostty.org/docs/install

# link
./install.sh ghostty
# or stow:
mkdir -p ~/.config
mv ~/.config/ghostty ~/.config/ghostty.bak 2>/dev/null
stow -v ghostty
```

After: reload with `Cmd+Shift+,` (macOS) / `Ctrl+Shift+,` (Linux). On macOS,
keep `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`
empty, since it overrides this config.

##### nvim

LazyVim config (`~/.config/nvim`). Plugins are installed by lazy.nvim from
`lazy-lock.json`, not stored here.

```sh
# install
brew install neovim git ripgrep fd                            # macOS
sudo apt install git ripgrep fd-find build-essential          # Ubuntu/Debian
# plus Neovim itself: apt's version is often too old for LazyVim, use
# https://github.com/neovim/neovim/releases

# link
./install.sh nvim
# or stow:
mkdir -p ~/.config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
stow -v nvim
```

After: run `nvim`. lazy.nvim installs the plugins on first start; run
`:Lazy restore` to get exactly the versions in `lazy-lock.json`.

##### starship

Prompt config (`~/.config/starship.toml`), loaded by the zsh config.

```sh
# install
brew install starship                                 # macOS
brew install --cask font-jetbrains-mono-nerd-font
curl -sS https://starship.rs/install.sh | sh          # Linux
                                                      # font: https://www.nerdfonts.com

# link
./install.sh starship
# or stow:
mkdir -p ~/.config
mv ~/.config/starship.toml ~/.config/starship.toml.bak 2>/dev/null
stow -v starship
```

After: open a new shell. The terminal needs a Nerd Font for the icons
(Ghostty has one built in).

##### tmux

`~/.config/tmux/tmux.conf`, prefix `C-a`. TPM and plugins are installed
into `~/.config/tmux/plugins` on first start, not stored here.

```sh
# install
brew install tmux                                     # macOS
sudo apt install tmux git python3 python3-venv        # Ubuntu/Debian

# link
./install.sh tmux
# or stow:
mkdir -p ~/.config/tmux                               # stays a real dir for plugins/
mv ~/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf.bak 2>/dev/null
stow -v tmux
```

After: run `tmux`. The first start clones TPM and installs the plugins in
the background (the status bar fills in when done). Reload the config with
`prefix r`, install newly added plugins with `prefix I`, remove unused ones
with `prefix Alt-u`.

##### zsh

`~/.zshenv` (sets `ZDOTDIR`) and `~/.config/zsh`. Tools that aren't
installed are skipped.

```sh
# install
brew install zoxide eza zsh-autosuggestions zsh-syntax-highlighting    # macOS
sudo apt install zsh zoxide eza zsh-autosuggestions zsh-syntax-highlighting
# oh-my-zsh, without replacing .zshrc
KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# link
./install.sh zsh
# or stow:
mkdir -p ~/.config/zsh                        # stays a real dir for secrets.zsh
mv ~/.zshenv ~/.zshenv.bak 2>/dev/null
mv ~/.config/zsh/.zshrc ~/.config/zsh/.zshrc.bak 2>/dev/null
mv ~/.config/zsh/.zprofile ~/.config/zsh/.zprofile.bak 2>/dev/null
mv ~/.config/zsh/conf.d ~/.config/zsh/conf.d.bak 2>/dev/null
stow -v zsh
touch ~/.config/zsh/secrets.zsh && chmod 600 ~/.config/zsh/secrets.zsh
```

After: put tokens in `~/.config/zsh/secrets.zsh` (local, not tracked), e.g.
`export NODE_AUTH_TOKEN=...`. On Linux make zsh the default shell with
`chsh -s "$(command -v zsh)"` and log in again. Otherwise `exec zsh`.

#### Daily use

Edit files through their usual paths (`~/.config/nvim/...`); the changes
land in this repo, so commit them here.

```sh
cd ~/dotfiles
stow -n -v nvim  # dry run
stow nvim        # link a package
stow -R nvim     # restow after adding files to a package
stow -D nvim     # unlink
```

Run stow from `~/dotfiles`: that's where `.stowrc` is read from. From
elsewhere use `stow -d ~/dotfiles -t ~ <pkg>`.

| Flag | Meaning |
|---|---|
| `-n` | Dry run, change nothing. Pair with `-v` to see what would happen |
| `-v` | Verbose: print each link created/removed. Repeat (`-vv`, `--verbose=2`) for more detail, e.g. why something was skipped |
| `-R` | Restow: unlink and link again |
| `-D` | Delete: remove the package's links |

Options can go before or after the package name, so `stow -v zsh -v` is
the same as `stow -vv zsh`.

#### Adding a new app

Package one app per directory, never all of `~/.config`: it holds tokens
and app state too.

```sh
cd ~/dotfiles
mkdir -p <app>/.config
cp -Rp ~/.config/<app> ~/.config/<app>.bak   # backup
mv ~/.config/<app> <app>/.config/            # a directory (or a single file
                                             # like ~/.config/<app>.toml)
stow -n -v <app> && stow -v <app>
```

Before committing:

- check for secrets: `grep -rniE 'token|secret|api[_-]?key|password' <app>`
- leave out caches, logs and nested `.git` directories
- if the app's directory must also hold local untracked files, add it to
  `REAL_DIRS` in `install.sh`
- add a section under Packages: install, link, after

`install.sh` picks up new packages automatically.
