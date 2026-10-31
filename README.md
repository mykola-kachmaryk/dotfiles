### Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
directory is a package whose contents mirror `$HOME`. Works on macOS and
Linux.

```
~/dotfiles/
├── aerospace/.config/aerospace/     → ~/.config/aerospace     (macOS only, skipped by default)
├── ghostty/.config/ghostty/         → ~/.config/ghostty
├── git/.config/git/{config,ignore,template} → ~/.config/git/...
├── karabiner/.config/karabiner/     → ~/.config/karabiner     (macOS only)
├── nvim/.config/nvim/               → ~/.config/nvim
├── starship/.config/starship/       → ~/.config/starship
├── tmux/.config/tmux/tmux.conf      → ~/.config/tmux/tmux.conf
├── vscode/Library/Application Support/Code/User/settings.json
│                                    → same path under ~       (macOS only, links to vscodium's file)
├── vscodium/Library/Application Support/VSCodium/User/settings.json
│                                    → same path under ~       (macOS only)
├── zed/.config/zed/                 → ~/.config/zed
├── zsh/.zshenv, zsh/.config/zsh/    → ~/.zshenv, ~/.config/zsh/
├── Brewfile                         # Homebrew packages and apps (not linked)
├── install.sh                       # set up a new machine
└── .stowrc                          # stow defaults: target ~, ignore .DS_Store
```

#### New machine

First give the machine access to GitHub; SSH keys aren't in this repo:

```sh
ssh-keygen -t ed25519 -C "<machine name>"
cat ~/.ssh/id_ed25519.pub        # add at GitHub → Settings → SSH and GPG keys
ssh -T git@github.com            # should greet you by your GitHub username
```

Then (`<repo>` = `git@github.com:mykola-kachmaryk/dotfiles.git`):

```sh
# macOS: install Homebrew (https://brew.sh), then
git clone <repo> ~/dotfiles && cd ~/dotfiles
brew bundle --file ~/dotfiles/Brewfile   # tools and apps (npm packages fail until Node is in)

# Ubuntu/Debian (24.04+): see each package's Linux line below
sudo apt install stow git gitleaks
git clone <repo> ~/dotfiles && cd ~/dotfiles

# Arch: everything is in the repos, including fnm, Ghostty, Zed and Neovim
sudo pacman -S stow git gitleaks zsh zoxide eza zsh-autosuggestions zsh-syntax-highlighting \
  tmux python fnm starship neovim ripgrep fd ghostty zed ttf-jetbrains-mono-nerd
git clone <repo> ~/dotfiles && cd ~/dotfiles

./install.sh                          # dry run: what would be backed up and linked
./install.sh --apply                  # all packages, or e.g. ./install.sh --apply zsh tmux

# Node via fnm (macOS: Brewfile, Arch: pacman)
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir ~/.local/bin --skip-shell   # Ubuntu/Debian only
exec zsh
fnm install 24 && fnm default 24
brew bundle                           # macOS: now also the global npm packages
npm install -g corepack @typescript/native-preview   # Linux: the same packages
```

Then do the "after" steps under Packages.

`install.sh` only shows what it would do unless you pass `--apply` (`-h` for
help). It moves conflicting files to `~/.dotfiles-backup/<timestamp>/`,
creates `~/.config/zsh/secrets.zsh` (mode 600) and
`~/.config/git/config.local`, moves a `~/.gitconfig` aside (keeping its
identity), enables the secret-scanning hook, skips macOS-only packages
elsewhere (`MACOS_ONLY`) and is safe to re-run. `~/.config`, `~/.config/zsh`,
`~/.config/tmux` and `~/.config/git` stay real directories (`REAL_DIRS`), so
local files (secrets, tmux plugins, git identity) stay out of this repo.

**Without install.sh**, from `~/dotfiles`: move the existing config out of the
way, create the target directory, then `stow -v <pkg>`. Create it with
`mkdir -p ~/.config/zsh` (or `tmux`, `git`) for those three packages and
`mkdir -p ~/.config` for the rest: if it doesn't exist, stow links the whole
directory into this repo.

**Brewfile.** Everything installed with Homebrew; apps and editor
extensions are in a macOS-only block. The zsh config sets
`HOMEBREW_BUNDLE_FILE`, so plain `brew bundle` works from any directory:
`brew bundle` (install what's missing), `brew bundle add <name> [--cask]`,
`brew bundle remove <name>`, `brew bundle cleanup` (list what's installed but
not listed). Don't use `brew bundle dump --force`: it drops the grouping and
the macOS-only block.

#### Packages

| Package | What | Ubuntu/Debian install (macOS: Brewfile, Arch: pacman line above) |
|---|---|---|
| aerospace | tiling window manager (macOS, archived; not installed by default) | — |
| ghostty | terminal | https://ghostty.org/docs/install |
| git | defaults, aliases, global ignore, commit template | `apt install git` |
| karabiner | Caps Lock → Hyper/Escape, hjkl arrows (macOS, archived) | — |
| nvim | LazyVim; plugins from `lazy-lock.json` | `apt install git ripgrep fd-find build-essential` + [Neovim release](https://github.com/neovim/neovim/releases) (apt's is too old) |
| starship | prompt, via `STARSHIP_CONFIG` | `curl -sS https://starship.rs/install.sh \| sh` |
| tmux | prefix `C-a`; TPM plugins install on first start | `apt install tmux git python3 python3-venv` |
| zed | editor; extensions auto-install | `curl -f https://zed.dev/install.sh \| sh` |
| zsh | plain zsh, fnm, starts in ~0.08 s ([zsh/README.md](zsh/README.md)) | `apt install zsh zoxide eza zsh-autosuggestions zsh-syntax-highlighting` |

**After installing:**

- **aerospace:** skipped by `./install.sh` unless named:
  `./install.sh --apply aerospace`. Then `brew install --cask nikitabobko/tap/aerospace`,
  grant it Accessibility access, `aerospace reload-config`.
- **karabiner:** `brew install --cask karabiner-elements` (quit it before
  linking), then allow its driver and input monitoring when macOS asks. The
  whole directory is linked because Karabiner rewrites `karabiner.json`;
  `automatic_backups/` stays out of git.
- **ghostty:** reload with `Cmd+Shift+,` / `Ctrl+Shift+,`. Commit
  `auto/theme.ghostty` when you change the theme in Ghostty. Keep
  `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` empty:
  it overrides this config on macOS.
- **nvim:** run `nvim`, then `:Lazy restore` for the exact plugin versions.
- **starship:** non-Ghostty terminals need a Nerd Font
  (`brew install --cask font-jetbrains-mono-nerd-font`).
- **tmux:** run `tmux`; the plugins install in the background. `prefix r`
  reloads, `prefix I` installs new plugins, `prefix Alt-u` removes unused.
- **vscode, vscodium:** quit the editor before linking. Only `settings.json` is
  linked; extensions (and the Vague theme) come from the Brewfile.
  VS Code shares VSCodium's `settings.json` (the `vscode` package links to
  it), so install its extensions in VS Code yourself.
- **zed:** quit Zed before linking. The whole directory is linked because Zed
  rewrites `settings.json`; only config files are tracked (allow-list
  `.gitignore`). Add new extensions to `auto_install_extensions`. On Arch
  the command is `zeditor`.
- **zsh:** put tokens in `~/.config/zsh/secrets.zsh` (not tracked). On Linux:
  `chsh -s "$(command -v zsh)"` and log in again.
- **git:** set your identity in `~/.config/git/config.local`. It's included
  last, so it can also override any setting for this machine.
  `user.useConfigOnly` makes git refuse to commit until it's set.

  ```ini
  [user]
  	name = Your Name
  	email = you@work.example                        # default (work)

  # repos cloned via the github.com-personal SSH alias get the personal email
  [includeIf "hasconfig:remote.*.url:git@github.com-personal:*/**"]
  	path = config.personal
  ```

  and in `~/.config/git/config.personal`:
  `[user] email = 17613536+mykola-kachmaryk@users.noreply.github.com`.
  Check with `git config user.email` in a repo. The pattern needs `:*/**`: a
  bare `:**` doesn't match the `/` in `owner/repo.git`.

  On a **personal-only machine**, skip the split: one SSH key on your
  personal GitHub account, normal `git@github.com:` URLs, and the noreply
  email straight in `config.local`'s `[user]`.

  On a machine with **work and personal** GitHub accounts, the split needs
  the `github.com-personal` SSH alias. GitHub tells accounts apart by SSH
  key, and the alias makes SSH use the personal key. Add it to
  `~/.ssh/config` (not in this repo), add that key to your personal account,
  and clone personal repos as `git@github.com-personal:mykola-kachmaryk/<repo>.git`:

  ```
  Host github.com-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
    IdentitiesOnly yes
    # macOS only: keep the key's passphrase in the Keychain
    # UseKeychain yes
    # AddKeysToAgent yes
  ```

  `ssh -T git@github.com` should greet your work account,
  `ssh -T git@github.com-personal` your personal one.

#### Daily use

Edit files through their usual paths (`~/.config/nvim/...`); the changes land
in this repo, so commit them here. After `git pull`, run
`./install.sh --apply` again: it links new files and removes links to files
that moved.

Stow by hand, from `~/dotfiles` (that's where `.stowrc` is read; elsewhere
use `stow -d ~/dotfiles -t ~ <pkg>`):

| Command | Meaning |
|---|---|
| `stow -n -v nvim` | dry run, show what would happen |
| `stow nvim` | link a package |
| `stow -R nvim` | restow: unlink and link again, after adding files |
| `stow -D nvim` | remove the package's links (do this before deleting a package) |

`-v` prints each link; repeat it (`-vv`) for why something was skipped.
Options can go before or after the package name.

**Secret scan.** `.githooks/pre-commit` runs
[gitleaks](https://github.com/gitleaks/gitleaks) on staged changes and blocks
commits with keys, tokens or passwords (file and line shown, secret
redacted). Without gitleaks it only warns. False positive: commit once with
`git commit --no-verify`. Whole history: `gitleaks git --log-opts="--all" --redact`.

#### Adding a new app

One app per directory, never all of `~/.config`: it holds tokens and app
state too.

```sh
cd ~/dotfiles
mkdir -p <app>/.config
cp -Rp ~/.config/<app> ~/.config/<app>.bak   # backup
mv ~/.config/<app> <app>/.config/            # a directory, or a single file
stow -n -v <app> && stow -v <app>
```

Before committing: check for secrets
(`grep -rniE 'token|secret|api[_-]?key|password' <app>`), leave out caches,
logs and nested `.git` directories, add the directory to `REAL_DIRS` in
`install.sh` if it must also hold local untracked files, add a row under
Packages, and add Homebrew apps to the Brewfile (`brew bundle add <name>`).
`install.sh` picks up new packages automatically.
