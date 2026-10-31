#!/usr/bin/env bash
# Link dotfiles packages into $HOME with GNU Stow.
#
#   ./install.sh                    # dry run: show what would change
#   ./install.sh --apply            # make the changes, all packages
#   ./install.sh --apply zsh nvim   # only these (options can go anywhere)
#   ./install.sh --apply aerospace  # a package skipped by default
#   ./install.sh -h                 # this help
#
#   -a, --apply    make the changes (default is a dry run)
#   -n, --dry-run  only show what would change (the default)
#
# Existing files in the way are moved to ~/.dotfiles-backup/<timestamp>/.
# Safe to re-run.
set -eu

# Print the comment block above
usage() {
  awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"
}

DRY_RUN=1
pkgs=""
for arg in "$@"; do
  case "$arg" in
    -h | --help)
      usage
      exit 0
      ;;
    -a | --apply) DRY_RUN=0 ;;
    -n | --dry-run) DRY_RUN=1 ;;
    -*)
      echo "unknown option: $arg" >&2
      usage >&2
      exit 1
      ;;
    *) pkgs="$pkgs $arg" ;;
  esac
done
# shellcheck disable=SC2086 # package names have no spaces
set -- $pkgs

DOTFILES="$(cd "$(dirname "$0")" && pwd -P)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Directories that must stay real so they can hold local, untracked files.
# Stow links their contents instead of the directory itself.
# One per line, since some names contain spaces.
REAL_DIRS='.config
.config/zsh
.config/tmux
.config/git
Library
Library/Application Support
Library/Application Support/VSCodium
Library/Application Support/VSCodium/User'

# Packages for macOS-only apps, skipped on other systems
MACOS_ONLY="aerospace karabiner vscodium"

# Packages kept in git but not installed by default. Name one to install it.
SKIP="aerospace"


run() {
  if [ "$DRY_RUN" = 1 ]; then
    echo "would run: $*"
  else
    "$@"
  fi
}

is_real_dir() {
  printf '%s\n' "$REAL_DIRS" | grep -qxF -- "$1"
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
      .gitignore | .DS_Store | README.* | LICENSE.*) return 0 ;; # not stowed
    esac
    backup "$rel"
  fi
}

if ! command -v stow >/dev/null 2>&1; then
  echo "stow not found. Install it first: brew install stow / sudo apt install stow" >&2
  exit 1
fi

cd "$DOTFILES"

# Default: every top-level directory is a package, except those in SKIP
if [ $# -eq 0 ]; then
  keep=""
  for pkg in */; do
    pkg="${pkg%/}"
    case " $SKIP " in
      *" $pkg "*) echo "skip: $pkg (not installed by default; run: $0 --apply $pkg)" ;;
      *) keep="$keep $pkg" ;;
    esac
  done
  # shellcheck disable=SC2086 # package names have no spaces
  set -- $keep
fi

for pkg in "$@"; do
  if [ ! -d "$DOTFILES/$pkg" ]; then
    echo "unknown package: $pkg" >&2
    exit 1
  fi
done

if [ "$(uname -s)" != Darwin ]; then
  keep=""
  for pkg in "$@"; do
    case " $MACOS_ONLY " in
      *" $pkg "*) echo "skip: $pkg (macOS only)" ;;
      *) keep="$keep $pkg" ;;
    esac
  done
  # shellcheck disable=SC2086 # package names have no spaces
  set -- $keep
  if [ $# -eq 0 ]; then
    echo "Nothing to install."
    exit 0
  fi
fi

for pkg in "$@"; do
  for item in "$DOTFILES/$pkg"/* "$DOTFILES/$pkg"/.[!.]*; do
    [ -e "$item" ] || continue
    clear_path "$pkg" "$(basename "$item")"
  done
done

if [ "$DRY_RUN" = 1 ]; then
  stow -n -v -d "$DOTFILES" -t "$HOME" -R "$@" ||
    echo "(dry run: stow sees the files above as conflicts because they haven't been backed up yet; a real run moves them first)"
else
  stow -v -d "$DOTFILES" -t "$HOME" -R "$@"
fi

for pkg in "$@"; do
  case "$pkg" in
    zsh)
      secrets="$HOME/.config/zsh/secrets.zsh"
      if [ ! -e "$secrets" ]; then
        run touch "$secrets"
        [ "$DRY_RUN" = 1 ] ||
          echo "Created empty $secrets for exports like tokens (not tracked in git)."
      fi
      [ ! -e "$secrets" ] || run chmod 600 "$secrets"

      case "${SHELL:-}" in
        */zsh) ;;
        *) echo "Default shell is ${SHELL:-unknown}. Switch with: chsh -s \"\$(command -v zsh)\"" ;;
      esac

      # The zsh config gets Node from fnm (05-path.zsh)
      if ! command -v fnm >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/fnm" ]; then
        if [ "$(uname -s)" = Darwin ]; then
          echo "Install fnm for Node: brew install fnm (or brew bundle), then: fnm install 24 && fnm default 24"
        else
          echo "Install fnm for Node: curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir ~/.local/bin --skip-shell"
          echo "  then in a new shell: fnm install 24 && fnm default 24"
        fi
      fi
      ;;
    git)
      identity="$HOME/.config/git/config.local"
      gitconfig="$HOME/.gitconfig"
      copied=""
      if [ ! -e "$identity" ]; then
        if [ "$DRY_RUN" = 1 ]; then
          echo "would create: $identity"
        else
          cat > "$identity" <<'EOF'
# Local git settings for this machine (identity, overrides). Not tracked in
# ~/dotfiles. git refuses to commit until user.name and user.email are set.
#
# [user]
# 	name = Your Name
# 	email = you@example.com
#
# Different email for repos cloned via an SSH alias, e.g. personal GitHub:
# [includeIf "hasconfig:remote.*.url:git@github.com-personal:*/**"]
# 	path = config.personal
EOF
          echo "Created $identity: set your git name and email there."
        fi

        # Keep the existing identity: from ~/.gitconfig, or from the old
        # ~/.config/git/config backed up above
        for src in "$gitconfig" "$BACKUP/.config/git/config"; do
          [ -f "$src" ] && [ ! -L "$src" ] || continue
          name=$(git config --file "$src" --get user.name || true)
          email=$(git config --file "$src" --get user.email || true)
          [ -n "$name$email" ] || continue
          [ -z "$name" ] || run git config --file "$identity" user.name "$name"
          [ -z "$email" ] || run git config --file "$identity" user.email "$email"
          verb=Copied
          [ "$DRY_RUN" = 0 ] || verb="Would copy"
          who=$name
          [ -z "$email" ] || who="${name:+$name }<$email>"
          echo "$verb git identity ($who) from ~${src#"$HOME"} to $identity"
          copied=$src
          break
        done
      fi

      # ~/.gitconfig is read after ~/.config/git/config and would override it
      if [ -f "$gitconfig" ] && [ ! -L "$gitconfig" ]; then
        others=$(git config --file "$gitconfig" --list 2>/dev/null || true)
        [ "$copied" != "$gitconfig" ] ||
          others=$(printf '%s\n' "$others" | grep -vE '^user\.(name|email)=' || true)
        backup ".gitconfig"
        if [ -n "$others" ]; then
          echo "~/.gitconfig also had these settings, not carried over."
          echo "Add any you want to $identity:"
          printf '%s\n' "$others" | sed 's/^/  /'
        fi
      fi
      ;;
  esac
done

# Secret scan before each commit in this repo (.githooks/pre-commit)
run git -C "$DOTFILES" config core.hooksPath .githooks ||
  echo "warning: could not enable the pre-commit hook (git config failed)" >&2
command -v gitleaks >/dev/null 2>&1 ||
  echo "Install gitleaks to enable the pre-commit secret scan: brew install gitleaks"

if [ "$DRY_RUN" = 1 ]; then
  echo "Dry run, nothing changed: $*"
  echo "To make these changes: $0 --apply${pkgs}"
else
  echo "Done: $*"
fi
