#!/usr/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

###################
# Kubectl Install #
###################

if ! command helm version &> /dev/null
then
    echo && echo "${bold}INFO:${normal}"
    echo "Beginning installation process for 'helm'."
    read -p "Install 'helm'? ([${bold}y${normal}]/n): " HELM_OPTION
    HELM_OPTION=${HELM_OPTION:-"y"}

    case $HELM_OPTION in

        y | Y)
            echo && echo "${bold}INFO:${normal}"
            echo "Attempting download of helm binary..."
            curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
            
            echo && echo "${bold}INFO:${normal}"
            echo "Adding executable permissions to 'get_helm.sh'..."
            chmod 700 get_helm.sh

            echo && echo "${bold}INFO:${normal}"
            echo "Running 'get_helm.sh'..."
            source ./get_helm.sh

            echo && echo "${bold}INFO:${normal}"
            echo "Cleaning downloads..."
            rm -rf ./get_helm.sh
            ;;

        n | N)
            echo && echo "${bold}INFO:${normal}"
            echo "Skipping installation of 'helm'"
            ;;
        
        *)
            echo && echo "${bold}INFO:${normal}"
            echo "Unknown option detected. Skipping..."
            ;;
    esac
else
    echo && echo "${bold}INFO:${normal}"
    echo "'helm' detected. Skipping installation..."
fi