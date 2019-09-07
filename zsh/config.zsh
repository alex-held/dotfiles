# Color Schema
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# Load functions
fpath=($ZSH/functions $fpath)
autoload -U $ZSH/functions/*(:t)

# Zsh_History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Options
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
etopt EXTENDED_HISTORY # add timestamps to history
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt PROMPT_SUBST

setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases