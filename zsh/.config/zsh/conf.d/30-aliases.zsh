# git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'
alias gw='git switch'

# pnpm
alias pn='pnpm'
alias pni='pnpm install'
alias pnd='pnpm dev'
alias pndw='pnpm dev w'
alias pnb='pnpm build'
alias pnt='pnpm test'
alias pnpg='pnpm prisma:generate'
alias pnpr='pnpm prisma:reset'
alias pnpt='pnpm truncate'

# eza (better ls)
(( $+commands[eza] )) && alias ls="eza --icons=always"

# zoxide (better cd)
(( $+commands[zoxide] )) && alias cd="z"

# nvim
(( $+commands[nvim] )) && alias vim="nvim"
