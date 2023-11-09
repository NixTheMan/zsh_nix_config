#!/usr/bin/zsh

###################
# ZSH apt Install #
###################

# Update and prepare for apt installation of packages
echo "Will begin environment creation..."
echo "Updating apt..."
sudo apt update

# Install prereqs for oh-my-zsh
echo "Installing 'oh-my-zsh' pre-requisites..."
sudo apt install curl zsh -yy


#####################
# Oh-my-zsh Install #
#####################

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
if [ -z "$(ls -A ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions)" ]
then
    echo "Downloading zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "Installing zsh-syntax-highlighting plugin..."
    sed -i '/plugins=(/a\\tzsh-syntax-highlighting'  ~/.zshrc
else
    echo "Zsh zsh-syntax-highlighting seems to have already been downloaded..."
fi

# Adding websearch plugin for Oh-my-zsh
echo "Adding web-search plugin..."
sed -i '/plugins=(/a\\tweb-search' ~/.zshrc


##################
# Poetry Install #
##################

echo "Installing poetry..."
curl -sSL https://install.python-poetry.org | python3 -

export PATH="$HOME/.local/bin:$PATH"

echo "Checking installation of poetry..."
poetry --version

poetry self update


########################
# Poetry Configuration #
########################

echo "Configuring Poetry..."
if [ -z "$(ls $ZSH_CUSTOM/plugins/poetry)" ]
then
    echo "Adding Oh-my-zsh poetry plugin..."
    mkdir $ZSH_CUSTOM/plugins/poetry
    poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
    sed -i '/plugins=(/a\\tpoetry' ~/.zshrc
else
    echo "Poetry already configured..."
fi

poetry config virtualenvs.in-project true


###################
# Kubectl Install #
###################

read "installtype?Enter x86-64 or arm64 for kubectl install type [x86-64]: "
installtype=${installtype:-"x86-64"}
read "version?Enter version of kubectl to install [latest-stable]: "
version=${version:-latest}
echo $installtype

echo "Downloading kubectl binary..."
if [ $version = latest ]
then
    echo "reached"
    if [ $installtype = "x86-64" ]
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

# Making kubectl executable
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH
echo "Kubectl installed..."

echo "Adding kubectl plugin..."
sed -i '/plugins=(/a\\tkubectl' ~/.zshrc


###########
# Exiting #
###########

echo "Remember to run 'p10k configure' for configuration of the zsh prompt..."
echo "Exiting shell configuration..."

