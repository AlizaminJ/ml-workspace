#!/bin/sh

# Stops script execution if a command has an error
set -e

INSTALL_ONLY=0
PORT=""
# Loop through arguments and process them: https://pretzelhands.com/posts/command-line-flags
for arg in "$@"; do
    case $arg in
        -i|--install) INSTALL_ONLY=1 ; shift ;;
        -p=*|--port=*) PORT="${arg#*=}" ; shift ;; # TODO Does not allow --port 1234
        *) break ;;
    esac
done

if [ ! -f "/usr/local/bin/code-server"  ]; then
    echo "Installing VS Code Server"
    cd ${RESOURCES_PATH}
    VS_CODE_VERSION=2.preview.11-vsc1.37.0
    wget --quiet https://github.com/cdr/code-server/releases/download/$VS_CODE_VERSION/code-server$VS_CODE_VERSION-linux-x86_64.tar.gz -O ./vscode-web.tar.gz
    tar xfz ./vscode-web.tar.gz
    mv ./code-server$VS_CODE_VERSION-linux-x86_64/code-server /usr/local/bin
    chmod -R a+rwx /usr/local/bin/code-server
    rm ./vscode-web.tar.gz
    rm -rf ./code-server$VS_CODE_VERSION-linux-x86_64
else
    echo "VS Code Server is already installed"
fi

# Run
if [ $INSTALL_ONLY = 0 ] ; then
    if [ -z "$PORT" ]; then
        read -p "Please provide a port for starting VS Code Server: " PORT
    fi

    echo "Starting VS Code Server on port "$PORT
    # Create tool entry for tooling plugin
    echo '{"id": "vscode-link", "name": "VS Code", "url_path": "/tools/'$PORT'/", "description": "Visual Studio Code webapp"}' > $HOME/.workspace/tools/vscode.json
    /usr/local/bin/code-server --port=$PORT --allow-http --disable-telemetry --user-data-dir=$HOME/.config/Code/ --extensions-dir=$HOME/.vscode/extensions/ --no-auth /workspace/
    sleep 15
fi
