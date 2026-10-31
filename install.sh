#!/usr/bin/env bash
# Link dotfiles packages into $HOME with GNU Stow.
#
#   ./install.sh             # all packages
#   ./install.sh zsh nvim    # only these
#   ./install.sh -n [pkg..]  # dry run
#
# Existing files in the way are moved to ~/.dotfiles-backup/<timestamp>/.
# Safe to re-run.
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd -P)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Directories that must stay real so they can hold local, untracked files.
# Stow links their contents instead of the directory itself.
REAL_DIRS=".config .config/zsh .config/tmux .config/git"

DRY_RUN=0
if [ "${1:-}" = "-n" ]; then
  DRY_RUN=1
  shift
fi

run() {
  if [ "$DRY_RUN" = 1 ]; then
    echo "would run: $*"
  else
    "$@"
  fi
}

is_real_dir() {
  case " $REAL_DIRS " in
    *" $1 "*) return 0 ;;
  esac
  return 1
}

# Move ~/<rel> to the backup dir unless it's missing or already linked into this repo
backup() {
  local target="$HOME/$1"
  [ -e "$target" ] || [ -L "$target" ] || return 0
  case "$(readlink -f "$target" 2>/dev/null)" in
    "$DOTFILES"/*) return 0 ;;
  esac
  echo "backup: ~/$1 -> $BACKUP/$1"
  run mkdir -p "$(dirname "$BACKUP/$1")"
  run mv "$target" "$BACKUP/$1"
}

# Clear whatever is in the way of package item <rel>, descending into REAL_DIRS
clear_path() {
  local pkg="$1" rel="$2" child
  if is_real_dir "$rel" && [ -d "$DOTFILES/$pkg/$rel" ]; then
    if [ -L "$HOME/$rel" ]; then
      echo "error: ~/$rel is a symlink ($(readlink "$HOME/$rel")), it must be a real directory." >&2
      echo "       Unstow the package that owns it (stow -D <pkg>) and re-run." >&2
      exit 1
    fi
    [ -d "$HOME/$rel" ] || backup "$rel"
    run mkdir -p "$HOME/$rel"
    for child in "$DOTFILES/$pkg/$rel"/* "$DOTFILES/$pkg/$rel"/.[!.]*; do
      [ -e "$child" ] || continue
      clear_path "$pkg" "$rel/$(basename "$child")"
    done
  else
    case "$(basename "$rel")" in
      .gitignore | .DS_Store) return 0 ;; # not stowed
    esac
    backup "$rel"
  fi
}

if ! command -v stow >/dev/null 2>&1; then
  echo "stow not found. Install it first: brew install stow / sudo apt install stow" >&2
  exit 1
fi

cd "$DOTFILES"

# Default: every top-level directory is a package
if [ $# -eq 0 ]; then
  set -- */
  set -- "${@%/}"
fi

for pkg in "$@"; do
  if [ ! -d "$DOTFILES/$pkg" ]; then
    echo "unknown package: $pkg" >&2
    exit 1
  fi
done

for pkg in "$@"; do
  for item in "$DOTFILES/$pkg"/* "$DOTFILES/$pkg"/.[!.]*; do
    [ -e "$item" ] || continue
    clear_path "$pkg" "$(basename "$item")"
  done
done

if [ "$DRY_RUN" = 1 ]; then
  stow -n -v -d "$DOTFILES" -t "$HOME" -R "$@" || true
else
  stow -v -d "$DOTFILES" -t "$HOME" -R "$@"
fi

for pkg in "$@"; do
  [ "$pkg" = zsh ] || continue

  secrets="$HOME/.config/zsh/secrets.zsh"
  if [ ! -e "$secrets" ]; then
    run touch "$secrets"
    echo "Created empty $secrets for exports like tokens (not tracked in git)."
  fi
  run chmod 600 "$secrets"

  case "${SHELL:-}" in
    */zsh) ;;
    *) echo "Default shell is ${SHELL:-unknown}. Switch with: chsh -s \"\$(command -v zsh)\"" ;;
  esac
done

echo "Done: $*"
