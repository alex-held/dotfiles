# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

zstyle ':completion:*' menu select


#
# Kube
source ~/.dotfiles/zsh/minikube-completion.zsh
source <(kubectl completion zsh) 
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1
#source ~/.dotfiles/zsh/kops-completions.zsh


#
# BREW CLI
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

#
# DOTNET CLI
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")
  reply=( "${(ps:\n:)completions}" )
}
compctl -K _dotnet_zsh_complete dotnet

#source ~/.dotfiles/zsh/dotnet-suggest-completions.zsh

autoload bashcompinit && bashcompinit
source /usr/local/etc/bash_completion.d/az

#source "$DOTFILES/zsh/az.completion.zsh"

# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
completion='$(brew --prefix)/share/zsh/site-functions/_git'

if test -f $completion
then
  source $completion
fi



autoload -U +X bashcompinit && bashcompinit
