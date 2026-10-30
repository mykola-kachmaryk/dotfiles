# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# zoxide
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# zsh-autosuggestions: Homebrew, Debian/Fedora, Arch
for plugin in {$HOMEBREW_PREFIX/share,/usr/share,/usr/share/zsh/plugins}/zsh-autosuggestions/zsh-autosuggestions.zsh(N); do
  source $plugin
  break
done
unset plugin
