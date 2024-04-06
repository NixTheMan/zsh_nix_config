#!/usr/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

########################
# Helix Editor Install #
########################

if ! command -v hx --version &> /dev/null
then
    echo && echo "${bold}INFO:${normal}"
    echo "Beginning installation process for 'helix'."
    read -p "Install 'helix'? ([${bold}y${normal}]/n): " HELIX_OPTION
    HELIX_OPTION=${HELIX_OPTION:-"y"}

    case $HELIX_OPTION in

        y | Y)
            echo && echo "${bold}INFO:${normal}"
            echo "Adding apt-repository ppa:maveonair/helix-editor..."
            sudo add-apt-repository ppa:maveonair/helix-editor

            echo && echo "${bold}INFO:${normal}"
            echo "Updating apt..."
            sudo apt update

            echo && echo "${bold}INFO:${normal}"
            echo "Running 'sudo apt install helix'..."
            sudo apt install helix


            echo "Helix installed..."

            echo && echo "${bold}INFO:${normal}"
            echo "Configuring Helix for Rust..."
            cd $HOME
            # Add if statement to check for codelldb
            sudo curl -L "https://github.com/vadimcn/vscode-lldb/releases/download/v1.7.0/codelldb-x86_64-linux.vsix" \
            -o "codelldb-x86_64-linux.zip"

            echo && echo "${bold}INFO:${normal}"
            echo "Unzipping codelldb.zip..."
            unzip "codelldb-x86_64-linux.zip" "extension/adapter/*" "extension/lldb/*"
            mv extension/ codelldb_adapter
            
            echo && echo "${bold}INFO:${normal}"
            echo "Linking codelldb for 'helix' editor..."
            sudo ln -s $(pwd)/codelldb_adapter/adapter/codelldb /usr/bin/codelldb
            
            echo && echo "${bold}INFO:${normal}"
            "Checking 'helix' editor health..."
            hx --health rust

            echo && echo "${bold}INFO:${normal}"
            echo "Cleaning downloads..."
            sudo rm "codelldb-x86_64-linux.zip" "codelldb-x86_64-linux.vsix"
            ;;

        n | N)
            echo && echo "${bold}INFO:${normal}"
            echo "Skipping installation of 'helix'"
            ;;

        *)
            echo && echo "${bold}INFO:${normal}"
            echo "Unknown option detected. Skipping installation..."
            ;;
    esac
else
    echo && echo "${bold}INFO:${normal}"
    echo "Helix installation found. Skipping installation..."
fi
