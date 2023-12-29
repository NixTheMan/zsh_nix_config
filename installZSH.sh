#!/usr/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

###################
# ZSH apt Install #
###################

# Offer optional install of ZSH

echo "Beginning installation process for 'zsh'."
read "ZSH_OPTION?Install 'zsh'? [${bold}y${normal}/n]: "
ZSH_OPTION=${ZSH_OPTION:-"y"}

case $ZSH_OPTION in

    y | Y)
        if command zsh --version &> /dev/null
        then
            echo "ZSH is already installed. Skipping..."
        else
            # Update and prepare for apt installation of packages
            echo "Will begin environment creation..."
            echo "Updating apt..."
            sudo apt update

            # Install prereqs for oh-my-zsh
            echo "Installing 'oh-my-zsh' pre-requisites..."
            sudo apt install zsh -yy
        fi
        ;;
    n | N)
        echo "Skipping installation of zsh"
        ;;
    *)
        echo "Unknown option detected. Skipping..."
        ;;
esac