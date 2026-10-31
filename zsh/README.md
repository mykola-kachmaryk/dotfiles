# zsh

Plain zsh (no framework), split into small files. A new shell or tmux pane
starts in about 0.12 s.

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
| `00-options.zsh` | vi mode, shell options, Home/End/Delete/Ctrl+arrow keys |
| `05-path.zsh` | Homebrew, nvm and the default Node, Herd/PHP, pnpm, `~/.local/bin` |
| `10-completion.zsh` | completion (`compinit`), nvm's completion, completion styles |
| `20-history.zsh` | history file and options, Up/Down prefix search |
| `30-aliases.zsh` | your aliases (git, pnpm, eza, zoxide, nvim) |
| `40-tools.zsh` | zoxide, zsh-autosuggestions |
| `50-herd.zsh` | Herd's hook: switches Node on `cd` into a project with `.nvmrc` |
| `90-prompt.zsh` | zsh-syntax-highlighting, starship |

`secrets.zsh` holds tokens. It is local only (ignored by git) and mode 600.

## Why it starts fast

Measured with `time zsh -l -i -c exit`:

| Setup | New shell |
|---|---|
| oh-my-zsh + nvm loaded normally | ~0.67 s (~0.44 s measured in a tmux pane) |
| nvm with `--no-use` | ~0.16 s |
| + no oh-my-zsh | ~0.12 s |

**nvm with `--no-use`** (`05-path.zsh`). Loading nvm normally runs
`nvm use default`, which took ~0.4 s on every new shell. Now nvm loads
without it (~40 ms) and the default Node's `bin` is put on `PATH` directly,
with the same `NVM_BIN`, `NVM_INC` and `MANPATH` that `nvm use` sets. All nvm
commands and Herd's `.nvmrc` switching work as before. A default alias like
`lts/*` can't be resolved this way, so then it falls back to `nvm use`.

**No oh-my-zsh.** Only its `git` plugin was enabled (≈180 aliases, unused)
and starship draws the prompt, so its theme did nothing. What it set that
matters now lives in `00-options.zsh`, `10-completion.zsh` and
`20-history.zsh`: the same options, key bindings, completion styles and
`hist_ignore_space`. Gone: its git aliases and `ll`, `la`, `..`, `...`, `md`,
`rd`, `1`–`9`.

**Completion check once a day** (`10-completion.zsh`). oh-my-zsh checked the
permissions of every completion directory on each start (lots of file-system
calls, which is slow right after the Mac has been idle). Now the full check
runs at most once a day; otherwise the cached dump is used.

**nvm's completion after `compinit`.** nvm's completion script runs a full
`compinit` itself if none has run yet, so it is loaded in
`10-completion.zsh`, not in `05-path.zsh`.

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

- **nvm loaded normally:** in `05-path.zsh`, uncomment the `nvm.sh` line and
  delete the `--no-use` block below it.
- **oh-my-zsh:** uncomment `00-omz.zsh`, delete `00-options.zsh` and
  `10-completion.zsh`, uncomment the nvm completion line in `05-path.zsh` and
  the two old `bindkey` lines in `20-history.zsh` (and remove the new ones).
