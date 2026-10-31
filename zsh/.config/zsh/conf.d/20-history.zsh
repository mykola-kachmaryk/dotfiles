HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}
SAVEHIST=100000
HISTSIZE=100000
setopt extended_history
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt hist_ignore_space   # commands starting with a space aren't saved (was set by oh-my-zsh)

# Up/Down: search history for lines starting with what's typed so far
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
for keymap in viins vicmd; do
  bindkey -M $keymap '^[[A' up-line-or-beginning-search   '^[OA' up-line-or-beginning-search
  bindkey -M $keymap '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search
done
unset keymap
