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
#source ./script/prompt


brewInstall () {
    # Install brew
    if test ! $(which brew); then
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
}

firstInstall () {
    info "Bootstrapping alexheld's dotfiles (https://github.com/alex-held/dotfiles)."
    if [ -d $HOME/.dotfiles ];
    then
        fail "Cannot bootstrap dotfiles, because there is already a directory at $HOME/.dotfiles. Please delete it and try again."
        exit 1;
    else
        export DOTFILES="$HOME/.dotfiles"
        success "Setup DOTFILES environment variable for $DOTFILES"

        brewInstall

        if test ! $(which git); 
        then
            info 'git is not installed. -> installing git'
            brew install git
            success 'installed git'
        else
            info 'git is already installed.'
        fi

        info 'Cloning alex-held dotfiles repository into ~/.dotfiles'
        git clone https://github.com/alex-held/dotfiles $HOME/.dotfiles

        info "Changing directory into $DOTFILES"
        pwd
        cd $DOTFILES
        pwd
    fi
}


installTaps () {
    if [[ -z "$DOTBREW" ]]; then
        export DOTBREW="$DOTFILES/homebrew"
    fi
    
    info 'Setting up Taps'
    while read in; do brew tap "$in"; done < $DOTBREW/Tap
    success 'Tapped into all 3rd party taps!'
}

installBrews () {
    info 'Installing formulea'
    brewfile="$DOTBREW/Brewfile"
    cat $brewfile | grep -v "#"
    brew install $(cat $brewfile | grep -v "#")
    success 'Installed all formulea!'
}

installCasks () {
    info 'Installing Casks'
    caskfile="$DOTBREW/Caskfile"
    cat $caskfile | grep -v "#"
    brew cask install $(cat $caskfile | grep -v "#")
    success 'Installed all casks!'
}

bootstrapBrew() {
    installTaps
    installBrews
    installCasks
}


init() {
    [ -z "$DOTFILES" ] && echo "Empty" || echo "Not empty"
    if test ! -d "$HOME/.dotfiles"; then
        firstInstall
    else
        info "Changing directory into $DOTFILES"
        pwd
        cd $DOTFILES
        pwd
    fi
}

init
bootstrapBrew

exit 0;




brewBundle() {
    info "Bundling brewfile..."
    brew bundle "$(curl -fsSL https://raw.githubusercontent.com/alex-held/dotfiles/master/Brewfile)"
}

zshInstall () {
    # zsh install
    # todo add in check for macOS 10.15 since zsh is default
    if test $(which zsh); then
        info "zsh already installed..."
    else
        brew install zsh 
        success 'zsh installed'
    fi
}

zshZInstall () {
    # Install z for dir searching
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-z" ]; then
        info "zsh-z already exists..."
    else
        git clone https://github.com/agkozak/zsh-z ~/.oh-my-zsh/custom/plugins/zsh-z
        success 'zsh-z installed'
    fi
}

configureGitCompletion () {
    GIT_VERSION=`git --version | awk '{print $3}'`
    URL="https://raw.github.com/git/git/v$GIT_VERSION/contrib/completion/git-completion.bash"
    success "git-completion for $GIT_VERSION downloaded"
    if ! curl "$URL" --silent --output "$HOME/.git-completion.bash"; then
        echo "ERROR: Couldn't download completion script. Make sure you have a working internet connection." && exit 1
        fail 'git completion download failed'
    fi
}

ohmyzshInstall () {
    # oh-my-zsh install
    if [ -d ~/.oh-my-zsh/ ] ; then
    info 'oh-my-zsh is already installed...'
    read -p "Would you like to update oh-my-zsh now? y/n " -n 1 -r
    echo ''
        if [[ $REPLY =~ ^[Yy]$ ]] ; then
        cd ~/.oh-my-zsh && git pull
            if [[ $? -eq 0 ]]
            then
                success "Update complete..." && cd
            else
                fail "Update not complete..." >&2 cd
            fi
        fi
    else
    echo "oh-my-zsh not found, now installing oh-my-zsh..."
    echo ''
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
    # sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    success 'oh-my-zsh installed'
    fi
}

ohmyzshPluginInstall () {
    # oh-my-zsh plugin install
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]; then
        info 'zsh-completions already installed'
    else
        git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions && success 'zsh-completions installed'
    fi
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        info 'zsh-autosuggestions already installed'
    else
        git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && success 'zsh-autosuggestions installed'
    fi
    if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        info 'zsh-syntax-highlighting already installed'
    else
    	echo "Skipping Zsh-Syntax-Hightlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && success 'zsh-syntax-highlighting installed'
    fi
}

pl9kInstall () {
    # powerlevel9k install
    if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel9k" ]; then
        info 'powerlevel9k already installed'
    else
        echo "Now installing powerlevel9k..."
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k && success 'powerlevel9k installed'
    fi
}

pl10kInstall () {
    # powerlevel10k install
    if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
        info 'powerlevel10k already installed'
    else
        echo "Now installing powerlevel10k..."
	git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k && success 'powerlevel10k installed'
    fi
}

tmuxTpmInstall () {
    # tmux tpm install
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        info 'tmux tpm already installed'
    else
        echo "Now installing Tmux TPM manager..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && success 'tmux tpm manager installed'
    fi
}

fubectlInstall () {
    # fubectl install
    # todo - move to after ~/bin check on bootstrap
    if [ -f "$HOME/bin/fubectl.source" ]; then
        info 'fubectl.source already exists'
    else
        echo "Now installing fubectl..."
        curl -o "$HOME/bin/fubectl.source" -LO https://rawgit.com/kubermatic/fubectl/master/fubectl.source && success "fubectl placed in $HOME/bin"
    fi
}

vundleInstall () {
    if [ -d "$HOME/.vim/bundle/Vundle.vim" ]; then
        info 'vundle already exists'
    else
        # vimrc vundle install
        echo ''
        echo "Now installing vundle..."
        echo ''
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && success 'vundle installed'
    fi
}

pathogenInstall () {
    if [ -f "$HOME/.vim/autoload/pathogen.vim" ]; then
        info 'pathogen already installed'
    else
        mkdir -p ~/.vim/autoload ~/.vim/bundle && \
            curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && success 'pathogen installed'
    fi
}

nerdtreeInstall () {
    if [ -d "$HOME/.vim/bundle/nerdtree" ]; then
        info 'vim nerdtree already installed'
    else
        git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree && success 'vim nerdtree installed'
    fi
}

wombatColorSchemeInstall () {
    if [ -f "$HOME/.vim/colors/wombat.vim" ]; then
        info "wombat color scheme already installed"
    else
        # Vim color scheme install
        git clone https://github.com/sheerun/vim-wombat-scheme.git ~/.vim/colors/wombat 
        mv ~/.vim/colors/wombat/colors/* ~/.vim/colors/
        success 'vim wombat color scheme installed'
    fi
}

cloneAndExecute(){

echo '"'
echo "Cloning the tempate repository into $1"
echo '"'

if ! (git clone --quiet https://github.com/alex-held/dotfiles.git $1) 
    then
        "Sorry i could not clone https://github.com/alex-held/dotfiles.git into $DOTFILES ." >> settzing_Defaults 2&> exit 1;
    else
        export DOTFILES=$1;
        $DOTFILES/script/bootstrap
fi
        exit 0;
  #  else 
   #     info "Sorry! The dotfiles could not applied successfully ..." >> settzing_Defaults 2&> exit 1;


}

setting_Defaults() {
	echo '"'
    echo "$1 "
	echo "Setting defaults for .zshrc and .bashrc. You may need to configure your environment manually... "
	echo "source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc  2&> dev/null
	echo "source $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc 2&> dev/null
	echo '"'
    exit 0;
   # echo "[ -f ~/bin/fubectl.source ] && source ~/bin/fubectl.source" >> ${ZDOTDIR:-$HOME}/.zshrc && echo "added fubectl to .zshrc..."
}


# brew setup
#brewInstall
#brewUpdate
#brewUpgrade
#brewBundle

# zsh setup
zshInstall
configureGitCompletion

# oh my zsh setup
ohmyzshInstall
zshZInstall
ohmyzshPluginInstall
pl9kInstall
pl10kInstall
#tmuxTpmInstall
#fubectlInstall

#vim setup
vundleInstall
pathogenInstall
nerdtreeInstall
wombatColorSchemeInstall



echo '"'
read -p "Do you also want to use exactly my dotfile configartions? y/n" -n 1 -r
echo '"'

if [[ $REPLY =~ ^[Nn]$ ]]; 
    then setting_Defaults "And we are done."  && exit 0;
    else
    


    

    while read -p "In which directory, you want your dotsettings repository?" -r
    do
        if ! [ -f "$HOME/$REPLY" ] || [ -d "$HOME/$REPLY" ]; 
        then
            export DOTFILES="$HOME/$REPLY" && cloneAndExecute "$DOTFILES"
           
            exit 0;
        else
        echo "This directory is not available. Please try again. ";
        continue;  
        fi
    done

fi