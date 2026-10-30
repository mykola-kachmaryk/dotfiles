# must be sourced after other widgets are defined
# zsh-syntax-highlighting: Homebrew, Debian/Fedora, Arch
for plugin in {$HOMEBREW_PREFIX/share,/usr/share,/usr/share/zsh/plugins}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh(N); do
  source $plugin
  break
done
unset plugin

(( $+commands[starship] )) && eval "$(starship init zsh)"
