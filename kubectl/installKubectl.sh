#!/usr/bin/bash

###################
# Kubectl Install #
###################

if ! command kubectl version &> /dev/null
then
    echo "Beginning installation process for 'kubectl'."
    read -p "Install 'kubectl'? [y/n]: " KUBECTL_OPTION
    KUBECTL_OPTION=${KUBECTL_OPTION:-"y"}

    case $KUBECTL_OPTION in

        y | Y)
            read -p "Enter x86_64 or arm64 for kubectl install type [x86_64]: " installtype
            installtype=${installtype:-x86_64}
            read -p "Enter version of kubectl to install [latest-stable]: " version
            version=${version:-latest}

            echo "Attempting download of kubectl binary at version $version..."
            if [ $version = "latest" ]
            then
                echo "reached"
                if [ $installtype = "x86_64" ]
                then
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                elif [ $installtype = "arm64" ]
                then
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
                else
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
                    echo $installtype " not recognized..."
                fi
            fi

            # Checking kubectl checksum
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
                    echo $installtype " not recognized..."
                fi
            fi

            echo "Checking checksum..."
            echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
            rm kubectl.sha256

            # Making kubectl executable
            chmod +x kubectl
            mkdir -p ~/.local/bin
            mv ./kubectl ~/.local/bin/kubectl
            # and then append (or prepend) ~/.local/bin to $PATH
            echo "Kubectl installed..."

            echo "Adding kubectl plugin..."
            sed -i '/plugins=(/a\\tkubectl' ~/.zshrc
            ;;

        n | N)
            echo "Skipping installation of 'kubectl'"
            ;;
        
        *)
            echo "Unknown option detected. Skipping..."
            ;;
    esac
else
    echo "'kubectl' detected. Skipping installation..."
fi