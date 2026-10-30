### Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a package whose contents mirror `$HOME`:

```
~/dotfiles/
├── ghostty/.config/ghostty/         → ~/.config/ghostty
├── nvim/.config/nvim/               → ~/.config/nvim
├── starship/.config/starship.toml   → ~/.config/starship.toml
├── zsh/.zshenv                      → ~/.zshenv
├── zsh/.config/zsh/...              → ~/.config/zsh/...
├── install.sh                       # set up a new machine
└── .stowrc                          # stow defaults: target ~, ignore .DS_Store
```

Works on macOS and Linux.

#### Packages

- `ghostty` – terminal config (`~/.config/ghostty`). `auto/theme.ghostty`
  holds the theme picked in Ghostty; commit it when it changes. Keep
  `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`
  empty, since it overrides this config on macOS.
- `nvim` – LazyVim config (`~/.config/nvim`). Plugins are installed by
  lazy.nvim from `lazy-lock.json`, not stored here.
- `zsh` – `~/.zshenv` (sets `ZDOTDIR`) and `~/.config/zsh`. Secrets go in
  `~/.config/zsh/secrets.zsh`, a local untracked file sourced by `.zshrc`.
- `starship` – prompt config (`~/.config/starship.toml`). Needs a Nerd Font
  in the terminal.

#### New machine

```sh
# macOS: brew install stow    Linux: sudo apt install zsh git stow
git clone <repo> ~/dotfiles && cd ~/dotfiles
./install.sh -n   # dry run: shows what would be backed up and linked
./install.sh      # all packages, or e.g. ./install.sh zsh starship
```

`install.sh`:

- moves conflicting files to `~/.dotfiles-backup/<timestamp>/`
- keeps `~/.config` and `~/.config/zsh` as real directories, so stow
  doesn't link all of `~/.config` into this repo (`REAL_DIRS` in the script)
- creates `~/.config/zsh/secrets.zsh` with mode 600
- is safe to re-run

Then add your tokens to `~/.config/zsh/secrets.zsh`, and on Linux switch
the default shell with `chsh -s "$(command -v zsh)"`.

Optional tools. Anything missing is skipped by the zsh config:

```sh
# macOS
brew install starship zoxide eza neovim zsh-autosuggestions zsh-syntax-highlighting
brew install --cask font-jetbrains-mono-nerd-font
# Ubuntu/Debian
sudo apt install zoxide eza neovim zsh-autosuggestions zsh-syntax-highlighting
curl -sS https://starship.rs/install.sh | sh
# oh-my-zsh, without replacing .zshrc
KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

<details>
<summary>Without install.sh</summary>

Move conflicting files away and create the real directories yourself, e.g.
for zsh:

```sh
cd ~/dotfiles
mv ~/.zshenv ~/.zshenv.bak 2>/dev/null        # stow won't replace real files
mv ~/.config/zsh ~/.config/zsh.bak 2>/dev/null
mkdir -p ~/.config/zsh                        # must exist first, see above
stow -n -v zsh && stow -v zsh
touch ~/.config/zsh/secrets.zsh && chmod 600 ~/.config/zsh/secrets.zsh
```

If you had a `secrets.zsh` before, copy it back from `~/.config/zsh.bak/`.

</details>

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
- add the package to the list above

`install.sh` picks up new packages automatically.
