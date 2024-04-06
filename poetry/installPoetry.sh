#!/usr/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

########################
# Poetry Configuration #
########################

PoetryConfig () {
    if command poetry --version &> /dev/null
    then
        echo && echo "${bold}INFO:${normal}"
        echo "'Poetry' detected..."
        read -p "Would you like to configure 'Poetry'? ([${bold}y${normal}]/n): " POETRY_CONFIG_OPTION
        POETRY_CONFIG_OPTION=${POETRY_CONFIG_OPTION:-"y"}

        case POETRY_CONFIG_OPTION in

            y | Y)
                echo && echo "${bold}INFO:${normal}"
                echo "Configuring Poetry..."
                if [ -z "$(ls $ZSH_CUSTOM/plugins/poetry)" ]
                then
                    echo "Adding Oh-my-zsh poetry plugin..."
                    mkdir $ZSH_CUSTOM/plugins/poetry
                    poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
                    sed -i '/plugins=(/a\\tpoetry' ~/.zshrc
                    poetry config virtualenvs.in-project true
                else
                    echo && echo "${bold}INFO:${normal}"
                    echo "Poetry already configured..."
                fi
                ;;
            
            n | N)
                echo && echo "${bold}INFO:${normal}"
                echo "Skipping 'Poetry' configuration..."
                ;;
            
            *)
                echo && echo "${bold}INFO:${normal}"
                echo "Unknown option detected. Skipping..."
                ;;
        esac
    
    else
        echo && echo "${bold}INFO:${normal}"
        echo "'Poetry' not detected. Skipping..."
    fi    
}

##################
# Poetry Install #
##################

if ! command poetry --version &> /dev/null
then
    echo && echo "${bold}INFO:${normal}"
    echo "Beginning installation process for 'Poetry'..."
    read -p "Install 'Poetry'? [y/n]: " POETRY_OPTION
    POETRY_OPTION=${POETRY_OPTION:-"y"}

    case $POETRY_OPTION in
    
        y | Y)
            echo && echo "${bold}INFO:${normal}"
            echo "Installing poetry..."
            curl -sSL https://install.python-poetry.org | python3 -

            echo && echo "${bold}INFO:${normal}"
            echo "Adding to PATH..."
            export PATH="$HOME/.local/bin:$PATH"

            echo && echo "${bold}INFO:${normal}"
            echo "Checking installation of Poetry..."
            poetry --version

            echo && echo "${bold}INFO:${normal}"
            echo "Updating 'Poetry'..."
            poetry self update
            
            echo && echo "${bold}INFO:${normal}"
            echo "Entering 'Poetry' configuration..."
            PoetryConfig
            ;;
        
        n | N)
            echo && echo "${bold}INFO:${normal}"
            echo "Skipping installation of 'Poetry'"
            ;;
        *)
            echo && echo "${bold}INFO:${normal}"
            echo "Unknown option detected. Skipping..."
            ;;
    esac
else
    PoetryConfig
fi


