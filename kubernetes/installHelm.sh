#!/usr/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

###################
# Kubectl Install #
###################

if ! command helm version &> /dev/null
then
    echo "Beginning installation process for 'helm'."
    read -p "Install 'helm'? ([${bold}y${normal}]/n): " HELM_OPTION
    HELM_OPTION=${HELM_OPTION:-"y"}

    case $HELM_OPTION in

        y | Y)
            echo "Attempting download of helm binary..."
            curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
            chmod 700 get_helm.sh
            source ./get_helm.sh
            ;;

        n | N)
            echo "Skipping installation of 'helm'"
            ;;
        
        *)
            echo "Unknown option detected. Skipping..."
            ;;
    esac
else
    echo "'helm' detected. Skipping installation..."
fi