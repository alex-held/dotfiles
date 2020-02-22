##
# Aliases
# ----------------------------

alias ls='exa -b --links --long -a --git'
alias l='exa -@ --git  -H -g -a --group-directories-first --long --modified'


# Config
alias reload!='source ~/.zshrc'
alias zshconfig="code ~/.zshrc"
alias cls='clear'

# Directories
alias cdd='cd ~/source/repos'
alias cd-settings='cd ~/source/settings'
alias cd-script='cd ~/source/script'
alias cd-ax='cd /Users/dev/source/repos/Gateway.Ax40.Services'
alias cdmock='/Users/dev/source/repos/NinjaTools.FluentMockServer'

# Git
alias gs='git status -sb'
alias gl='git log --oneline'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gf='git fetch --all'
alias gcm='git checkout master'
alias gbm='git rebase master'

alias gac='git add -A && git commit -m'
alias gco='git checkout'
alias gcb='git copy-branch-name'
alias ge='git-edit-new'
alias gcm='git checkout master'
alias gcmb='git checkout master && git checkout -b $1'

alias diff='diff --color=auto'
alias grep='grep --color=auto --exclude-dir={.bzr,VCS,.git,.hg,.svn}'
alias tree='tree -aC -I .git --dirsfirst'

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'



###
alias zshconfig="code ~/.zshrc"
alias config='/usr/bin/git --git-dir=/Users/$(whoami)/.cfg/ --work-tree=/Users/$(whoami)'
