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

`.stowrc` sets the target to `~`, so commands work from any directory.

#### Adding a new app

```sh
mkdir -p ~/dotfiles/<app>/.config
mv ~/.config/<app> ~/dotfiles/<app>/.config/
cd ~/dotfiles && stow <app>
```

#### Packages

- `nvim` – LazyVim config (`~/.config/nvim`)
