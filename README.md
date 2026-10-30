### Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a package whose contents mirror `$HOME`.

```sh
brew install stow
git clone <repo> ~/dotfiles && cd ~/dotfiles

stow nvim        # link a package
stow -n -v nvim  # dry run
stow -R nvim     # restow after adding files
stow -D nvim     # unlink
```

Run stow from `~/dotfiles`: that's where `.stowrc` (target `~`, ignore
`.DS_Store`) is read from. From elsewhere use `stow -d ~/dotfiles -t ~ <pkg>`.

| Flag | Meaning |
|---|---|
| `-n` | Dry run, change nothing. Pair with `-v` to see what would happen |
| `-v` | Verbose: print each link created/removed. Repeat (`-vv`, `--verbose=2`) for more detail, e.g. why something was skipped |
| `-R` | Restow: unlink and link again. Use after adding files to a package |
| `-D` | Delete: remove the package's links |

Options can go before or after the package name, so `stow -v zsh -v` is
the same as `stow -vv zsh`.

#### New machine

```sh
# macOS: brew install stow    Linux: sudo apt install zsh git stow
git clone <repo> ~/dotfiles && cd ~/dotfiles
./install.sh -n   # dry run: shows what would be backed up and linked
./install.sh      # all packages, or e.g. ./install.sh zsh
```

`install.sh` moves conflicting files to `~/.dotfiles-backup/<timestamp>/`,
keeps `~/.config` and `~/.config/zsh` as real directories (so stow doesn't
link all of `~/.config` into this repo), creates `secrets.zsh` with mode 600,
and is safe to re-run.

Without `install.sh`, the same for zsh with plain stow:

```sh
cd ~/dotfiles
mv ~/.zshenv ~/.zshenv.bak 2>/dev/null        # stow won't replace real files
mv ~/.config/zsh ~/.config/zsh.bak 2>/dev/null
mkdir -p ~/.config/zsh                        # must exist first, see above
stow -n -v zsh && stow -v zsh
touch ~/.config/zsh/secrets.zsh && chmod 600 ~/.config/zsh/secrets.zsh
```

If you had a `secrets.zsh` before, copy it back from `~/.config/zsh.bak/`.

Works on macOS and Linux. Tools missing on a machine (Homebrew, oh-my-zsh,
eza, zoxide, starship, zsh plugins) are skipped. Optional tools:

```sh
# macOS
brew install starship zoxide eza neovim zsh-autosuggestions zsh-syntax-highlighting
# Ubuntu/Debian
sudo apt install zoxide eza neovim zsh-autosuggestions zsh-syntax-highlighting
curl -sS https://starship.rs/install.sh | sh
# oh-my-zsh, without replacing .zshrc
KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### Adding a new app

```sh
mkdir -p ~/dotfiles/<app>/.config
mv ~/.config/<app> ~/dotfiles/<app>/.config/
cd ~/dotfiles && stow <app>
```

#### Packages

- `nvim` – LazyVim config (`~/.config/nvim`)
- `zsh` – `~/.zshenv` (sets `ZDOTDIR`) and `~/.config/zsh`. Secrets go in
  `~/.config/zsh/secrets.zsh`, a local untracked file sourced by `.zshrc`.
