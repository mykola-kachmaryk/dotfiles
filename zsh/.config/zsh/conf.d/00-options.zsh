# Shell options and keys that oh-my-zsh used to set (see 00-omz.zsh)

set -o vi

setopt auto_cd               # type a directory name to cd into it
setopt auto_pushd            # cd pushes onto the directory stack (cd -<tab>)
setopt pushd_ignore_dups
setopt pushd_minus
setopt interactive_comments  # allow # comments in pasted commands
setopt long_list_jobs
setopt no_flow_control       # Ctrl+S / Ctrl+Q don't freeze the terminal
setopt complete_in_word
setopt always_to_end

# Keys, in both vi insert and command mode. Both escape sequences for each key,
# since terminals send either one depending on their cursor key mode
for keymap in viins vicmd; do
  bindkey -M $keymap '^[[H' beginning-of-line  '^[OH' beginning-of-line   # Home
  bindkey -M $keymap '^[[F' end-of-line        '^[OF' end-of-line         # End
  bindkey -M $keymap '^[[3~' delete-char                                  # Delete
  bindkey -M $keymap '^[[3;5~' kill-word                                  # Ctrl+Delete
  bindkey -M $keymap '^[[1;5C' forward-word    '^[[1;5D' backward-word    # Ctrl+arrows
  bindkey -M $keymap '^[[5~' up-line-or-history '^[[6~' down-line-or-history  # PageUp/Down
  bindkey -M $keymap '^[[Z' reverse-menu-complete                         # Shift+Tab
  bindkey -M $keymap '^?' backward-delete-char                            # Backspace
done
unset keymap
