# oh-my-zsh, disabled for testing. What it provided (options, key bindings,
# completion setup) now lives in 00-options.zsh, 10-completion.zsh and
# 20-history.zsh; only its git plugin aliases and ll/la/../md are gone.
# To go back: uncomment this file, delete 00-options.zsh and 10-completion.zsh,
# and undo the commented lines in 05-path.zsh and 20-history.zsh.

# set -o vi
#
# # Path to my Oh My Zsh installation.
# export ZSH="$HOME/.oh-my-zsh"
#
# # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
#
# plugins=(git)
#
# # Keep the completion dump out of $ZDOTDIR
# ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
# mkdir -p "${ZSH_COMPDUMP:h}"
#
# [[ -r $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh
