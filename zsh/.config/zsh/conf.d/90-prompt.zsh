# must be sourced after other widgets are defined
# zsh-syntax-highlighting: Homebrew, Debian/Fedora, Arch
for plugin in {$HOMEBREW_PREFIX/share,/usr/share,/usr/share/zsh/plugins}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh(N); do
  source $plugin
  break
done
unset plugin

# starship themes live in ~/.config/starship/starship_<name>.toml
# (plain starship.toml is the theme "default"). The chosen theme is
# remembered in $XDG_STATE_HOME so new shells pick it up.
_starship_theme_dir="$HOME/.config/starship"
_starship_theme_state="${XDG_STATE_HOME:-$HOME/.local/state}/starship-theme"
_starship_theme_fallback=pure   # used when no theme has been chosen yet

_starship_theme_file() {
  [[ $1 == default ]] && print -r -- "$_starship_theme_dir/starship.toml" \
    || print -r -- "$_starship_theme_dir/starship_$1.toml"
}

_starship_theme_list() {
  local f
  for f in $_starship_theme_dir/starship*.toml(N); do
    f=${f:t:r}
    [[ $f == starship ]] && print default || print ${f#starship_}
  done
}

# starship-theme          list themes, * marks the active one
# starship-theme <name>   switch this shell and remember it for new shells
starship-theme() {
  local current=$([[ -r $_starship_theme_state ]] && <$_starship_theme_state) t
  current=${current:-$_starship_theme_fallback}
  if (( ! $# )); then
    for t in $(_starship_theme_list); do
      [[ $t == $current ]] && print "* $t" || print "  $t"
    done
    return
  fi
  local file=$(_starship_theme_file $1)
  if [[ ! -r $file ]]; then
    print -u2 "starship-theme: no theme '$1' (try: $(_starship_theme_list | tr '\n' ' '))"
    return 1
  fi
  mkdir -p ${_starship_theme_state:h}
  print -r -- $1 >| $_starship_theme_state
  export STARSHIP_CONFIG=$file
}

_starship_theme_complete() { compadd -- $(_starship_theme_list) }
(( $+functions[compdef] )) && compdef _starship_theme_complete starship-theme

() {
  local t=$([[ -r $_starship_theme_state ]] && <$_starship_theme_state)
  local file=$(_starship_theme_file ${t:-$_starship_theme_fallback})
  [[ -r $file ]] || file=$(_starship_theme_file $_starship_theme_fallback)
  export STARSHIP_CONFIG=$file
}
(( $+commands[starship] )) && eval "$(starship init zsh)"
