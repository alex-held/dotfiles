#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)

source $HOME/.dotfiles/script/prompt


installTaps () {  
    info 'Setting up Taps'
    while read in; do brew tap "$in"; done < $1
    success 'Tapped into all 3rd party taps!'
}

installBrews () {
    info 'Installing formulea'
    brew install $(cat $1 | grep -v "#")
    success 'Installed all formulea!'
}

installCasks () {
    info 'Installing Casks'
    brew cask install $(cat $1 | grep -v "#")
    success 'Installed all casks!'
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


brew update
success 'brew updated'

brew install git
success 'git installed'

installTaps "Taps"
installBrews "Brewfile"
installCasks "Caskfile"

exit


