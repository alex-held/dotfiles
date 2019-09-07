#!/bin/sh
#
# Usage: iterm_setup
# Description: copies settings from repo into iterm2
#


iterm_setup() {

    ln -s "~/.dotfiles/iterm/itermcfg.syslink" "~/.itermcfg"

    link_file ~/.dotfiles/iterm/itermcfg.syslink
    # Specify the preferences directory
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.itermcfg/"
    
    # Tell iTerm2 to use the custom preferences in the directory
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
      if [[ $? -eq 0 ]]
      then
          success "successfully configured iTerm2 to use my settings!"
      else
          fail "failed to apply my settings." >&2
      fi
}

iterm_setup
