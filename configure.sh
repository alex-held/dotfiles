#!/bin/bash
set -eou pipefail

# script/prompt
info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

clone() {

  if test ! $(which git); then
      info 'git is not installed. -> installing git'
      brew install git
      success 'installed git'
  else
      info 'git is already installed.'
  fi

  info "Cloning alex-held dotfiles repository into $dotfiles"
  if ! (git clone --quiet https://github.com/alex-held/dotfiles.git $dotfiles) then
      echo "Sorry i could not clone https://github.com/alex-held/dotfiles.git into $dotfiles." 
      exit 1
  fi
}


# Check for Homebrew
if test ! $(which brew)
  then

    info "Installing Homebrew for you. "

    # Install the correct homebrew for each OS type
    if test "$(uname)" = "Darwin"
    then
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      success 'brew installed'

    elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
    then
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
      success 'brew installed'
    fi
  else
    info 'brew is already installed'
fi



info "Bootstrapping alexheld's dotfiles (https://github.com/alex-held/dotfiles)."
dotfiles="$HOME/.dotfiles"

if [ -d $dotfiles ]; then
  $dotfiles/script/bootstrap $dotfiles
else
  clone
  $dotfiles/script/bootstrap $dotfiles
fi

