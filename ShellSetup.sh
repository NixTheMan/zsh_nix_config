#!/usr/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

#####################
# Oh-my-zsh Install #
#####################

if command zsh --version &> /dev/null
then
    echo && echo "${bold}INFO:${normal}"
    echo "Beginning installation process for 'oh-my-zsh'."
    read -p "Install 'oh-my-zsh'? ([${bold}y${normal}]/n): " OH_MY_ZSH_OPTION
    OH_MY_ZSH_OPTION=${OH_MY_ZSH_OPTION:-y}

    case $OH_MY_ZSH_OPTION in

        y | Y)
            if [ -z "$(ls -A ${ZSH_CUSTOM:-~/.oh-my-zsh/})" ]
            then
                echo && echo "${bold}INFO:${normal}"
                echo "After installing 'oh-my-zsh' type exit to finish configuration process."
                read -p "Press ${bold}ENTER${normal} to continue: "
                
                echo && echo "${bold}INFO:${normal}"
                echo "Installing 'oh-my-zsh'..."
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || return

                ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

                ###########################
                # PowerLevel10K ZSH theme #
                ###########################

                echo && echo "${bold}INFO:${normal}"
                echo "Downloading 'powerlevel10k' zsh theme..."
                git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
                export ZSH_THEME="powerlevel10k/powerlevel10k"
                sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
                
                echo && echo "${bold}INFO:${normal}"
                echo 'Remember to set ZSH_THEME="powerlevel10k/powerlevel10k" within the ~/.zshrc file for this to be a persistent setting...'

                # Install Font
                # For the font to properly show up, it may require manually updating what the terminal font is
                # from either VS Code, or CMD prompt settings. The glyphs should then render properly.
                echo && echo "${bold}INFO:${normal}"
                echo "Downloading MesloLGS NF into ~/.local/share/fonts/..."
                if [ -z "$(ls $HOME/.local/share/fonts/)" ]
                then
                    mkdir $HOME/.local/share/fonts
                    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -O ~/.local/share/fonts/MesloLGS_NF_Regular.ttf
                    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -O ~/.local/share/fonts/MesloLGS_NF_Bold.ttf
                    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -O ~/.local/share/fonts/MesloLGS_NF_Italic.ttf
                    wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -O ~/.local/share/fonts/MesloLGS_NF_Bold_Italic.ttf
                    
                    echo && echo "${bold}INFO:${normal}"
                    echo "Updating fonts..."
                    sudo fc-cache -vf ~/.local/share/fonts
                    
                    echo && echo "${bold}INFO:${normal}"
                    echo "Remember to change your font to 'MesloLGS NF'"
                else
                    echo && echo "${bold}INFO:${normal}"
                    echo "MesloLGS NF already downloaded..."
                fi

                #####################
                # OH-MY-ZSH Plugins #
                #####################

                echo && echo "${bold}INFO:${normal}"
                echo "Downloading external 'oh-my-zsh' plugins..."

                sed -iH 's/\nplugins=(git)/plugins=(\n\tgit\n)/g' ~/.zshrc

                # Installing autosuggestions plugin
                if [ -d -A ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]
                then
                    echo && echo "${bold}INFO:${normal}"
                    echo "Downloading zsh-autosuggestions plugin..."
                    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
                    echo ""
                    echo "${bold}INFO:${normal}"
                    echo "Installing zsh-autosuggestions plugin..."
                    sed -i 's/\nplugins=(/a\\tzsh-autosuggestions/g' ~/.zshrc
                else
                    echo && echo "${bold}INFO:${normal}"
                    echo "Zsh autosuggestions seems to have already been downloaded..."
                fi

                # Installing zsh-syntax-highlighting
                if [ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]
                then
                    echo && echo "${bold}INFO:${normal}"
                    echo "Downloading zsh-syntax-highlighting plugin..."
                    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
                    
                    echo && echo "${bold}INFO:${normal}"
                    echo "Installing zsh-syntax-highlighting plugin..."
                    sed -i 's/\nplugins=(/a\\tzsh-syntax-highlighting/g'  ~/.zshrc
                else
                    echo && echo "${bold}INFO:${normal}"
                    echo "Zsh zsh-syntax-highlighting seems to have already been downloaded..."
                fi

                if command zsh --version &> /dev/null
                then
                    # Adding websearch plugin for Oh-my-zsh
                    echo && echo "${bold}INFO:${normal}"
                    echo "Adding web-search plugin..."
                    sed -i 's/\nplugins=(/a\\tweb-search/g' ~/.zshrc

                    # Adding PATH to zshrc
                    sed -i 's/\# export PATH=$HOME\/bin:\/usr\/local\/bin:$PATH/export PATH=$HOME\/bin:\/usr\/local\/bin:$HOME\/.local\/bin:$PATH/g' ~/.zshrc
                else
                    echo && echo "${bold}WARNING:${normal}"
                    echo "ZSH not properly installed. Exiting..."
                    exit 1
                fi
            else
                echo && echo "${bold}INFO:${normal}"
                echo "'oh-my-zsh' seems to already exist. Skipping..."
            fi
            ;;
        
        n | N)
            echo && echo "${bold}INFO:${normal}"
            echo "Skipping installation of 'oh-my-zsh'"
            ;;
        *)
            echo && echo "${bold}INFO:${normal}"
            echo "Unknown option detected. Skipping..."
            ;;
    esac
else
    echo && echo "${bold}INFO:${normal}"
    echo "'zsh' not detected. Skipping..."
fi



##################
# Poetry Install #
##################

source ./poetry/installPoetry.sh


###################
# Kubectl Install #
###################

source ./kubernetes/installKubectl.sh

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

echo ""
echo "${bold}!!IMPORTANT!!${normal}"
echo ""
echo "Remember to run 'p10k configure' for configuration of the zsh prompt..."
echo "Exiting shell configuration..."

echo ""
echo "${bold}INFO:${normal}"
