# Completion setup (what oh-my-zsh used to do). Runs after
# 05-path.zsh so Homebrew's completions are on fpath.
# Keep the completion dump out of $ZDOTDIR
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${ZSH_COMPDUMP:h}"

autoload -Uz compinit
# Full check (slow) at most once a day, otherwise trust the dump. Also do the
# full check when a completion directory changed since the dump was written,
# so a newly installed tool's completion works right away
_comp_fresh=1
for _comp_dir in $fpath; do
  [[ $_comp_dir -nt $ZSH_COMPDUMP ]] && { _comp_fresh=0; break; }
done
if (( _comp_fresh )) && [[ -n $ZSH_COMPDUMP(#qN.mh-24) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
fi
unset _comp_fresh _comp_dir

# Case-insensitive, then partial-word matching
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' list-colors 'di=1;36' 'ln=35' 'so=32' 'pi=33' 'ex=31' 'bd=34;46' 'cd=34;43' 'su=30;41' 'sg=30;46' 'tw=30;42' 'ow=30;43'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
