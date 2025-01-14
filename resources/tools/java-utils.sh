#!/bin/sh

# Stops script execution if a command has an error
set -e

INSTALL_ONLY=0
# Loop through arguments and process them: https://pretzelhands.com/posts/command-line-flags
for arg in "$@"; do
    case $arg in
        -i|--install) INSTALL_ONLY=1 ; shift ;;
        *) break ;;
    esac
done

echo "Installing Java Utils Collection"

apt-get update
apt-get install -y --no-install-recommends \
        scala \
        gradle

# Install vscode java extension pack
if hash code 2>/dev/null; then
    # https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack
    LD_LIBRARY_PATH="" LD_PRELOAD="" code --user-data-dir=$HOME/.config/Code/ --extensions-dir=$HOME/.vscode/extensions/ --install-extension vscjava.vscode-java-pack
else
    echo "Please install the desktop version of vscode via the vs-code-desktop.sh script to install java vscode extensions."
fi

# TODO install java kernel? https://github.com/SpencerPark/IJava