#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)

# Check for Homebrew
if test ! $(which brew)
then
  echo "I will install Homebrew for you. "

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  fi
  
  # install brew taps, needs to be fixed properly later
  while read in; do brew tap "$in"; done < Taps

  # Install brews
  brew install $(cat Brewfile|grep -v "#")

  # Install casks
  brew cask install $(cat Caskfile|grep -v "#")
  

  #brew bundle --file=~/.dotfiles/Brewfile
fi

exit 0
