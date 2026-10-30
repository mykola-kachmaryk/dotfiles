
# Homebrew is set up in conf.d/05-path.zsh so non-login shells get it too

if [[ $OSTYPE == darwin* ]]; then
  # Added by OrbStack: command-line tools and integration
  # Comment this line if you don't want it to be added again.
  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi
