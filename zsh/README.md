# zsh

Plain zsh (no framework), split into small files. A new shell or tmux pane
starts in about 0.08 s.

## How it loads

| Order | File | When | What |
|---|---|---|---|
| 1 | `~/.zshenv` | every zsh | sets `ZDOTDIR=~/.config/zsh` (so the rest is read from there), loads cargo |
| 2 | `.zprofile` | login shells | OrbStack (macOS) |
| 3 | `.zshrc` | interactive shells | sources every `conf.d/*.zsh` in name order, then `secrets.zsh` |

`conf.d/`, in load order:

| File | What |
|---|---|
| `00-omz.zsh` | oh-my-zsh, disabled (kept commented out, see below) |
| `00-options.zsh` | starts in `~` if the current folder was deleted (e.g. a removed git worktree; brew and fnm fail there), vi mode, shell options, Home/End/Delete/Ctrl+arrow keys |
| `05-path.zsh` | Homebrew, fnm (Node), Herd/PHP, pnpm, `~/.local/bin`; old nvm setup commented out |
| `10-completion.zsh` | completion (`compinit`), completion styles |
| `20-history.zsh` | history file and options, Up/Down prefix search |
| `30-aliases.zsh` | your aliases (git, pnpm, eza, zoxide, nvim) |
| `40-tools.zsh` | zoxide, zsh-autosuggestions |
| `50-herd.zsh` | Herd's nvm hook, disabled (fnm switches Node on `cd` now) |
| `90-prompt.zsh` | zsh-syntax-highlighting, starship |

`secrets.zsh` holds tokens. It is local only (ignored by git) and mode 600.

## Why it starts fast

Measured with `time zsh -l -i -c exit`:

| Setup | New shell |
|---|---|
| oh-my-zsh + nvm loaded normally | ~0.67 s (~0.44 s measured in a tmux pane) |
| nvm with `--no-use` | ~0.16 s |
| + no oh-my-zsh | ~0.12 s |
| + fnm instead of nvm | ~0.08 s |

**fnm instead of nvm** (`05-path.zsh`). nvm is a large shell script: even
with `--no-use` it took ~40 ms, plus ~17 ms for Herd's hook on every start.
fnm is a small program that does the same in a few ms:

- puts the default Node on `PATH` (`fnm default 24`)
- switches version on `cd` into a project with `.nvmrc` or `.node-version`,
  also from its subfolders (`--version-file-strategy recursive`, like nvm),
  and back to the default when you leave
- if a project asks for a version that isn't installed, it prints an error
  and stays on the default: run `fnm install` there (Herd's nvm hook
  installed it automatically)

Commands: `fnm install 22`, `fnm use 22`, `fnm default 24`, `fnm list`.
Herd's own Node features don't use this: Herd has its own bundled nvm.
Global npm packages are per Node version; the Brewfile lists them.

**No oh-my-zsh.** Only its `git` plugin was enabled (≈180 aliases, unused)
and starship draws the prompt, so its theme did nothing. What it set that
matters now lives in `00-options.zsh`, `10-completion.zsh` and
`20-history.zsh`: the same options, key bindings, completion styles and
`hist_ignore_space`. Gone: its git aliases and `ll`, `la`, `..`, `...`, `md`,
`rd`, `1`–`9`.

**Completion check once a day** (`10-completion.zsh`). oh-my-zsh checked the
permissions of every completion directory on each start (lots of file-system
calls, which is slow right after the Mac has been idle). Now the full check
runs at most once a day, or when a completion directory changed (a new tool
was installed); otherwise the cached dump is used.

## Measuring

```sh
for i in 1 2 3 4; do time zsh -l -i -c exit; done
```

The first run after the Mac has been idle for a minute or so is 2–3× slower;
look at the later runs. To see which file costs what:

```sh
ZDOTDIR=~/.config/zsh zsh -f -i -c 'zmodload zsh/datetime; source ~/.zshenv; source $ZDOTDIR/.zprofile; for f in $ZDOTDIR/conf.d/*.zsh; do t=$EPOCHREALTIME; source $f; printf "%-18s %4.0f ms\n" ${f:t} $(( (EPOCHREALTIME-t)*1000 )); done'
```

## Going back

- **nvm instead of fnm:** in `05-path.zsh`, uncomment the nvm block and
  delete the fnm lines; uncomment the nvm completion line in
  `10-completion.zsh` and the Herd line in `50-herd.zsh`. `~/.nvm` is still
  installed.
- **oh-my-zsh:** uncomment `00-omz.zsh`, delete `00-options.zsh` (keep its
  deleted-folder check at the top, it's unrelated to oh-my-zsh) and
  `10-completion.zsh`, uncomment the nvm completion line in `05-path.zsh` and
  the two old `bindkey` lines in `20-history.zsh` (and remove the new ones).
  oh-my-zsh itself is no longer installed (`~/.oh-my-zsh` was removed), so
  first reinstall it, without letting it replace `.zshrc`:

  ```sh
  KEEP_ZSHRC=yes RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```
