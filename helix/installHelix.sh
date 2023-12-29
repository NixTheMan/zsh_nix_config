#!/usr/bin/bash


########################
# Helix Editor Install #
########################

if ! command -v hx --version &> /dev/null
then
    echo "Beginning installation process for 'helix'."
    read -p "Install 'helix'? [y/n]: " HELIX_OPTION
    HELIX_OPTION=${HELIX_OPTION:-"y"}

    case $HELIX_OPTION in

        y | Y)
            git clone https://github.com/helix-editor/helix $HOME/helix/
            cd $HOME/helix
            cargo install --path helix-term --locked
            ln -Ts $PWD/runtime ~/.config/helix/runtime

            echo "Helix installed..."

            echo "Configuring Helix for Rust..."
            cd $HOME
            # Add if statement to check for codelldb
            sudo curl -L "https://github.com/vadimcn/vscode-lldb/releases/download/v1.7.0/codelldb-x86_64-linux.vsix" \
            -o "codelldb-x86_64-linux.zip"
            unzip "codelldb-x86_64-linux.zip" "extension/adapter/*" "extension/lldb/*"
            mv extension/ codelldb_adapter
            sudo rm "codelldb-x86_64-linux.zip" "codelldb-x86_64-linux.vsix"
            ln -s $(pwd)/codelldb_adapter/adapter/codelldb /usr/bin/codelldb
            hx --health rust
            ;;

        n | N)
            echo "Skipping installation of 'helix'"
            ;;

        *)
            echo "Unknown option detected. Skipping installation..."
            ;;
    esac
else
    echo "Helix installation found. Skipping installation..."
fi