#!/usr/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

###################
# Kubectl Install #
###################

if ! command kubectl version &> /dev/null
then
    echo && echo "${bold}INFO:${normal}"
    echo "Beginning installation process for 'kubectl'."
    read -p "Install 'kubectl'? ([${bold}y${normal}]/n): " KUBECTL_OPTION
    KUBECTL_OPTION=${KUBECTL_OPTION:-"y"}

    case $KUBECTL_OPTION in

        y | Y)
            read -p "Enter 'x86_64' or 'arm64' for kubectl install type [x86_64]: " installtype
            installtype=${installtype:-x86_64}
            read -p "Enter version of kubectl to install [latest-stable]: " version
            version=${version:-latest}
            
            echo && echo "${bold}INFO:${normal}"
            echo "Attempting download of kubectl binary at version $version..."
            if [ $version = "latest" ]
            then
                if [ $installtype = "x86_64" ]
                then
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                elif [ $installtype = "arm64" ]
                then
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
                else
                    echo && echo "${bold}WARNING:${normal}"
                    echo $installtype " not recognized..."
                fi
            else

                if [ $installtype = "x86-64" ]
                then
                    curl -LO https://dl.k8s.io/release/$(echo $version)/bin/linux/amd64/kubectl
                elif [ $installtype = "arm64" ]
                then
                    curl -LO https://dl.k8s.io/release/$(echo $version)/bin/linux/arm64/kubectl
                else
                    echo && echo "${bold}WARNING:${normal}"
                    echo $installtype " not recognized..."
                fi
            fi

            # Checking kubectl checksum
            echo && echo "${bold}INFO:${normal}"
            echo "Downloading checksum for kubectl..."
            if [ $version = latest ]
            then
                if [ $installtype = "x86-64" ]
                then
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
                elif [ $installtype = "arm64" ]
                then
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256"
                else
                    echo && echo "${bold}WARNING:${normal}"
                    echo $installtype " not recognized..."
                fi
            else
                if [ $installtype = "x86-64" ]
                then
                    curl -LO "https://dl.k8s.io/release/$(echo $version)/bin/linux/amd64/kubectl.sha256"
                elif [ $installtype = "arm64" ]
                then
                    curl -LO "https://dl.k8s.io/release/$(echo $version)/bin/linux/arm64/kubectl.sha256"
                else
                    echo && echo "${bold}WARNING:${normal}"
                    echo $installtype " not recognized..."
                fi
            fi

            echo && echo "${bold}INFO:${normal}"
            echo "Checking checksum..."
            checksum=$(echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check)
            if [[ $checksum == *"OK"* ]]
            then
                echo && echo "${bold}INFO:${normal}"
                echo "Checksum passed..."

                echo && echo "${bold}INFO:${normal}"
                echo "Cleaning downloads..."                
                rm kubectl.sha256

                # Making kubectl executable
                echo && echo "${bold}INFO:${normal}"
                echo "Making 'kubectl' executable..."
                chmod +x kubectl

                echo && echo "${bold}INFO:${normal}"
                echo "Adding 'kubectl' to PATH..."
                mkdir -p ~/.local/bin
                mv ./kubectl ~/.local/bin/kubectl
                # and then append (or prepend) ~/.local/bin to $PATH
                echo && echo "${bold}INFO:${normal}"
                echo "Kubectl installed..."
                
                if command zsh --version &> /dev/null
                then
                    echo && echo "${bold}INFO:${normal}"
                    echo "'zsh' detected..."
                    echo "Adding 'oh-my-zsh' plugin for 'kubectl'..."
                    sed -i '/plugins=(/a\\tkubectl' ~/.zshrc
                fi

            else
                echo && echo "${bold}WARNING:${normal}"
                echo "Checksum check failed"
            fi
            ;;

        n | N)
            echo && echo "${bold}INFO:${normal}"
            echo "Skipping installation of 'kubectl'"
            ;;
        
        *)
            echo && echo "${bold}INFO:${normal}"
            echo "Unknown option detected. Skipping..."
            ;;
    esac
else
    echo && echo "${bold}INFO:${normal}"
    echo "'kubectl' detected. Skipping installation..."
fi