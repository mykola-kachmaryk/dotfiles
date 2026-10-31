# Herd's shell hook, disabled while testing fnm: it switched the Node version
# on cd through nvm, which fnm now does itself (--use-on-cd in 05-path.zsh).
# Herd's app and sites are not affected: they use Herd's own bundled nvm.
# To go back to nvm, uncomment this line (see 05-path.zsh).
#
# Herd: auto-switch node version on cd (needs nvm, loaded in 05-path.zsh)
# [[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"
