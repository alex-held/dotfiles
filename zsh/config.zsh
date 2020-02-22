# Color Schema
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# Load functions
fpath=($ZSH/functions $fpath)
autoload -U $ZSH/functions/*(:t)


# Options
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt PROMPT_SUBST

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
setopt complete_aliases


