#!/usr/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

#####################
# Oh-my-zsh Install #
#####################

if command zsh --version &> /dev/null
then
    echo "Beginning installation process for 'oh-my-zsh'."
    read -p "Install 'oh-my-zsh'? [${bold}y${normal}/n]: " OH_MY_ZSH_OPTION
    OH_MY_ZSH_OPTION=${OH_MY_ZSH_OPTION:-y}

    case $OH_MY_ZSH_OPTION in

        y | Y)
            if [ -z "$(ls -A ${ZSH_CUSTOM:-~/.oh-my-zsh/})" ]
            then
                echo "Installing 'oh-my-zsh'..."
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

                ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

                ###########################
                # PowerLevel10K ZSH theme #
                ###########################

                echo "Downloading 'powerlevel10k' zsh theme..."
                git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
                export ZSH_THEME="powerlevel10k/powerlevel10k"
                echo 'Remember to set ZSH_THEME="powerlevel10k/powerlevel10k" within the ~/.zshrc file for this to be a persistent setting...'

                # Install Font
                # For the font to properly show up, it may require manually updating what the terminal font is
                # from either VS Code, or CMD prompt settings. The glyphs should then render properly.
                echo "Downloading MesloLGS NF into ~/.local/share/fonts/..."
                if [ -z "$(ls $HOME/.local/share/fonts/)" ]
                then
                    curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf > ~/.local/share/fonts/MesloLGS_NF_Regular.ttf
                    curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf > ~/.local/share/fonts/MesloLGS_NF_Bold.ttf
                    curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf > ~/.local/share/fonts/MesloLGS_NF_Italic.ttf
                    curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf > ~/.local/share/fonts/MesloLGS_NF_Bold_Italic.ttf
                else
                    echo "MesloLGS NF already downloaded..."
                fi

                #####################
                # OH-MY-ZSH Plugins #
                #####################

                echo "Downloading external 'oh-my-zsh' plugins..."

                sed -iH 's/plugins=(git)/plugins=(\n\tgit\n)/g' ~/.zshrc

                # Installing autosuggestions plugin
                if [ -z "$(ls -A ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions)" ]
                then
                    echo "Downloading zsh-autosuggestions plugin..."
                    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
                    echo "Installing zsh-autosuggestions plugin..."
                    sed -i '/plugins=(/a\\tzsh-autosuggestions' ~/.zshrc
                else
                    echo "Zsh autosuggestions seems to have already been downloaded..."
                fi

                # Installing zsh-syntax-highlighting
                if [ -z "$(ls -A ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting)" ]
                then
                    echo "Downloading zsh-syntax-highlighting plugin..."
                    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
                    echo "Installing zsh-syntax-highlighting plugin..."
                    sed -i '/plugins=(/a\\tzsh-syntax-highlighting'  ~/.zshrc
                else
                    echo "Zsh zsh-syntax-highlighting seems to have already been downloaded..."
                fi

                if command zsh --version &> /dev/null
                then
                    # Adding websearch plugin for Oh-my-zsh
                    echo "Adding web-search plugin..."
                    sed -i '/plugins=(/a\\tweb-search' ~/.zshrc

                    # Adding PATH to zshrc
                    sed -i 's/\# export PATH=$HOME\/bin:\/usr\/local\/bin:$PATH/export PATH=$HOME\/bin:\/usr\/local\/bin:$HOME\/.local\/bin:$PATH/g' ~/.zshrc
                else
                    echo "ZSH not properly installed. Exiting..."
                    exit 1
                fi
            else
                echo "'oh-my-zsh' seems to already exist. Skipping..."
            fi
            ;;
        
        n | N)
            echo "Skipping installation of 'oh-my-zsh'"
            ;;
        *)
            echo "Unknown option detected. Skipping..."
            ;;
    esac
else
    echo "'zsh' not detected. Skipping..."
fi



##################
# Poetry Install #
##################

source ./poetry/installPoetry.sh


###################
# Kubectl Install #
###################

source ./kubectl/installKubectl.sh

################
# Rust Install #
################

source ./Rust/installRust.sh

########################
# Helix Editor Install #
########################

source ./helix/installHelix.sh

###########
# Exiting #
###########

echo "Remember to run 'p10k configure' for configuration of the zsh prompt..."
echo "Exiting shell configuration..."

