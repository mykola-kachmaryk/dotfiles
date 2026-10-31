### Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a package whose contents mirror `$HOME`:

```
~/dotfiles/
├── aerospace/.config/aerospace/     → ~/.config/aerospace     (macOS only)
├── ghostty/.config/ghostty/         → ~/.config/ghostty
├── git/.config/git/{config,ignore,template} → ~/.config/git/...
├── karabiner/.config/karabiner/     → ~/.config/karabiner     (macOS only)
├── nvim/.config/nvim/               → ~/.config/nvim
├── starship/.config/starship/       → ~/.config/starship
├── tmux/.config/tmux/tmux.conf      → ~/.config/tmux/tmux.conf
├── zed/.config/zed/                 → ~/.config/zed
├── zsh/.zshenv                      → ~/.zshenv
├── zsh/.config/zsh/...              → ~/.config/zsh/...
├── install.sh                       # set up a new machine
└── .stowrc                          # stow defaults: target ~, ignore .DS_Store
```

Works on macOS and Linux.

#### New machine

```sh
brew install stow git gitleaks        # macOS
sudo apt install stow git gitleaks    # Ubuntu/Debian (24.04+)

git clone <repo> ~/dotfiles && cd ~/dotfiles
./install.sh -n                       # dry run: what would be backed up and linked
./install.sh                          # all packages, or e.g. ./install.sh zsh tmux
```

Then install each package's tools and do its "after" steps below.

`install.sh`:

- moves conflicting files to `~/.dotfiles-backup/<timestamp>/`
- keeps `~/.config`, `~/.config/zsh`, `~/.config/tmux` and `~/.config/git`
  as real directories, so stow doesn't link them into this repo and local
  files (secrets, tmux plugins, git identity) stay out of it (`REAL_DIRS` in
  the script)
- creates `~/.config/zsh/secrets.zsh` with mode 600 and a
  `~/.config/git/config.local` template
- enables the secret-scanning pre-commit hook (see Daily use)
- skips macOS-only packages (`MACOS_ONLY` in the script) on other systems
- is safe to re-run

To link a package with plain stow instead, use the "stow" commands in its
section. Run them from `~/dotfiles`, and keep the `mkdir -p` line: if the
directory doesn't exist, stow links the whole directory into this repo.

#### Packages

##### aerospace (macOS only)

Tiling window manager config (`~/.config/aerospace/aerospace.toml`).
Archived: not installed right now, linked so it works on reinstall.

```sh
# install
brew install --cask nikitabobko/tap/aerospace

# link
./install.sh aerospace
# or stow:
mkdir -p ~/.config
mv ~/.config/aerospace ~/.config/aerospace.bak 2>/dev/null
stow -v aerospace
```

After: start AeroSpace and grant it Accessibility access (System Settings →
Privacy & Security → Accessibility). Reload with `aerospace reload-config`.

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

##### git

Global git config (`~/.config/git`): aliases, global ignore, commit message
template. Name and email are **not** in the repo: `config` includes
`~/.config/git/config.local`, a local file per machine, and sets
`user.useConfigOnly` so git refuses to commit until that file sets an
identity.

```sh
# install
brew install git                      # macOS
sudo apt install git                  # Ubuntu/Debian

# link
./install.sh git                      # also creates a config.local template
# or stow:
mkdir -p ~/.config/git                # stays a real dir for config.local
for f in config ignore template; do mv ~/.config/git/$f ~/.config/git/$f.bak 2>/dev/null; done
stow -v git
```

After: set your identity in `~/.config/git/config.local`:

```ini
[user]
	name = Your Name
	email = you@work.example                        # default (work)

# repos cloned via the github.com-personal SSH alias get the personal email
[includeIf "hasconfig:remote.*.url:git@github.com-personal:*/**"]
	path = config.personal
```

and in `~/.config/git/config.personal`:

```ini
[user]
	email = 17613536+mykola-kachmaryk@users.noreply.github.com
```

Check with `git config user.email` inside a repo. The URL pattern needs
`:*/**`: a bare `:**` doesn't match the `/` in `owner/repo.git`.

##### karabiner (macOS only)

Keyboard remapping (`~/.config/karabiner`): Caps Lock → Hyper when held /
Escape when tapped, Caps+hjkl and Cmd+Shift+hjkl → arrow keys. Archived: not
installed right now. The whole directory is linked because Karabiner
rewrites `karabiner.json` itself; its `.gitignore` tracks only
`karabiner.json` and `assets/`, so `automatic_backups/` stays out of git.

```sh
# install
brew install --cask karabiner-elements

# link (quit Karabiner-Elements first)
./install.sh karabiner
# or stow:
mkdir -p ~/.config
mv ~/.config/karabiner ~/.config/karabiner.bak 2>/dev/null
stow -v karabiner
```

After: open Karabiner-Elements and allow its driver and input monitoring
when macOS asks. The rules load from `karabiner.json` automatically.

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

Prompt config (`~/.config/starship/starship.toml`), loaded by the zsh
config. Starship's default location is `~/.config/starship.toml`; the zsh
config points it here with `STARSHIP_CONFIG` (in `conf.d/90-prompt.zsh`), so
it only applies in shells that load that config.

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
mv ~/.config/starship ~/.config/starship.bak 2>/dev/null
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

##### zed

Editor config (`~/.config/zed`). The whole directory is linked because Zed
rewrites `settings.json` when you change things in the UI; its `.gitignore`
tracks only `settings.json`, `keymap.json`, `tasks.json`, `snippets/` and
`themes/`, so app data (prompt library, conversations) stays out of git.

```sh
# install
brew install --cask zed                       # macOS
curl -f https://zed.dev/install.sh | sh       # Linux

# link (quit Zed first)
./install.sh zed
# or stow:
mkdir -p ~/.config
mv ~/.config/zed ~/.config/zed.bak 2>/dev/null
stow -v zed
```

After: open Zed. Extensions listed in `auto_install_extensions` (Vague
theme, PHP/intelephense, …) install on first start. When you install a new
extension, add it there too. `buffer_font_family` is Menlo, which only
exists on macOS; Linux falls back to another font.

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

**Secret scan.** `.githooks/pre-commit` runs
[gitleaks](https://github.com/gitleaks/gitleaks) on staged changes and
blocks the commit if it finds keys, tokens or passwords, printing the file
and line (secret redacted). `install.sh` turns it on with
`git config core.hooksPath .githooks`. Without gitleaks installed the hook
only warns. For a false positive, commit once with `git commit --no-verify`.
Scan the whole history with `gitleaks git --log-opts="--all" --redact`.

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
