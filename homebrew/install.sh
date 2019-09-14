#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)

source $HOME/.dotfiles/script/prompt


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

brewdir="$DOTFILES/homebrew"

brew update
success 'brew updated'

info 'Setting up Taps'
tapsfile="$brewdir/Taps"
while read in; do brew tap "$in"; done < $tapsfile
success 'Tapped into all 3rd party taps!'

info 'Installing formulea'
brewfile="$brewdir/Brewfile"
brew install $(cat Brewfile|grep -v "#")
success 'Installed all formulea!'

info 'Installing Casks'
caskfile="$brewdir/Caskfile"
brew cask install $(cat Caskfile|grep -v "#")
success 'Installed all casks!'


