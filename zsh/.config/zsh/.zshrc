for f in $ZDOTDIR/conf.d/*.zsh(N); do
  source "$f"
done
unset f

[[ -r $ZDOTDIR/secrets.zsh ]] && source $ZDOTDIR/secrets.zsh

