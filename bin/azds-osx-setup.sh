#!/bin/bash

info()    { echo "[INFO]    $*" ; }
fatal()   { echo "[FATAL]   $*" ; exit 1 ; }

SETUP_SRC_LOCATION="https://azuredevspacestools.blob.core.windows.net/azdssetup"
TMP_FOLDER="/tmp"
BINARIES_FILE_NAME=AzdsCliMacOSX.zip
LIB_FOLDER="$HOME/lib/azds-cli"
BIN_FOLDER="/usr/local/bin/azds"
KUBECTL_PATH="$LIB_FOLDER/kubectl/osx/kubectl"
PRODUCT_NAME="Azure Dev Spaces"

echo "Installing $PRODUCT_NAME client components..."
echo

# Check system configuration
if [ -z "$(uname -m | grep 64)" ]; then 
    fatal "$PRODUCT_NAME is only supported on x64 architectures."
fi
if ! xcode-select -p >/dev/null 2>/dev/null; then
    fatal "$PRODUCT_NAME requires the MacOS command line tools. Install using 'xcode-select --install'."
fi

if [ -t 0 ]; then
    read -p "By continuing, you agree to the Microsoft Software License Terms (https://aka.ms/azds-LicenseTerms) and Microsoft Privacy Statement (https://aka.ms/privacystatement). Do you want to continue? (Y/n): " -r
    if !([[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY =~ ^[[:space:]]*$ ]]); then
        info "Exiting the installation."
        exit 0
    fi
    echo
fi

echo "You may be prompted for your administrator password to authorize the installation process."
sudo echo 

for var in "$@"; do
  if ! [ "$var" = "-y" ] && ! [ "$var" = "-yes" ] && ! [ "$var" = "--yes" ]; then
    BuildOverride=$var
  fi
done

if [ "$BuildOverride" = "PreRelease" ]; then
    SETUP_SRC_LOCATION="$SETUP_SRC_LOCATION/PreRelease"
    info "Will install build '$BuildOverride' specific binaries."
elif [ -n "$BuildOverride" ]; then
    SETUP_SRC_LOCATION="$SETUP_SRC_LOCATION/CLI.$BuildOverride"
    info "Will install build '$BuildOverride' specific binaries."
else
    SETUP_SRC_LOCATION="$SETUP_SRC_LOCATION/LKS"
fi

if [ -e "$BIN_FOLDER" -o -e "$LIB_FOLDER" ]; then    
    info "Removing existing versions of $PRODUCT_NAME..."
    sudo rm -rf "$BIN_FOLDER"
    sudo rm -rf "$LIB_FOLDER"
fi

if [ ! -e "$BINARIES_FILE_NAME" ]; then
    {
        info "Downloading $PRODUCT_NAME Package..."
        curl -fsS $SETUP_SRC_LOCATION/$BINARIES_FILE_NAME -o "$TMP_FOLDER/.azds.zip"
    }||{
        fatal "Failed to download $PRODUCT_NAME Package."
    }
else
     cp "$BINARIES_FILE_NAME" "$TMP_FOLDER/.azds.zip"
fi

{
    sudo mkdir -p "$LIB_FOLDER" && 
    unzip -q "$TMP_FOLDER/.azds.zip" -d "$TMP_FOLDER/setup" &&
    sudo mv "$TMP_FOLDER/setup"/* "$LIB_FOLDER" &&
    rm -f "$TMP_FOLDER/.azds.zip" &&
    rm -rf "$TMP_FOLDER/setup" &&
    sudo chmod +x "$LIB_FOLDER/azds" &&
    sudo chmod +x "$KUBECTL_PATH" &&
    sudo ln -s "$LIB_FOLDER/azds" "$BIN_FOLDER"
}||{
    fatal "Failed to install $PRODUCT_NAME."
}

BASH_COMPLETION_SCRIPT=bash_completion.sh
if [ ! -e $BASH_COMPLETION_SCRIPT ]; then
    {
        info "Downloading Bash completion script..."
        curl -fsS $SETUP_SRC_LOCATION/$BASH_COMPLETION_SCRIPT -o "$TMP_FOLDER/.azds.bash_completion.sh"
    }||{
        fatal "Failed to download Bash completion script."
    }
else
    sudo cp $BASH_COMPLETION_SCRIPT "$TMP_FOLDER/.azds.bash_completion.sh"
fi
{
    sudo mkdir -p /etc/bash_completion.d &&
    sudo mv "$TMP_FOLDER/.azds.bash_completion.sh" /etc/bash_completion.d/azds &&
    sudo chmod 777 /etc/bash_completion.d/azds
}||{
    fatal "Failed to enable Bash completion script."
}
{
    grep -q '^source /etc/bash_completion.d/azds$' ~/.bash_profile ||
    echo "source /etc/bash_completion.d/azds" >> ~/.bash_profile
}||{
    fatal "Failed to register Bash completion script."
}

printf "\n\033[1;32mSuccessfully installed $PRODUCT_NAME to $BIN_FOLDER.\033[0m\n\n"

echo "Run 'source ~/.bash_profile' for enabling auto completion of commands."