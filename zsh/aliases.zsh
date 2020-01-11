## 
# Aliases
# ----------------------------

alias ll=ls -la
alias la=ls -a

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

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'
