#!/bin/bash

###############################################################################
#       Post installation WSL configuration utility script for Ubuntu         #
#       Author: Asmit De                                                      #
#       Date: 09/16/2017                                                      #
###############################################################################

echo "===== Running post setup configuration ====="


# Get usernames
echo "Obtaining usernames..."

user_linux=$USER
if [ ! -n "$user_linux" ]; then
    echo "Linux username not found. Enter linux username (RETURN to abort):"
    read get_user_linux
    if [ ! -n "$get_user_linux" ]; then
        exit 1
    fi
    user_linux=$get_user_linux
fi

user_windows=$( cmd.exe /c 'echo %username%' | sed 's/\r//' )
if [ ! -n "$user_windows" ]; then
    echo "Windows username not found. Enter Windows username (RETURN to abort):"
    read get_user_windows
    if [ ! -n "$get_user_windows" ]; then
        exit 1
    fi
    user_windows=$get_user_windows
fi

echo "Linux username: $user_linux"
echo "Windows username: $user_windows"


# Check if HOME is set
if [ ! -n "$HOME" ]; then
    echo "Environment variable HOME not set; setting it to /home/${user_linux}"
    export HOME=/home/${user_linux}
fi


# Set WINHOME
if [ ! -n "$WINHOME" ]; then
    echo "Setting WINHOME to /mnt/c/Users/${user_windows}"
    export WINHOME=/mnt/c/Users/${user_windows}
fi


# Update installation
echo "Updating system..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y


# Create Symbolic Links to Windows folders for easy access
echo "Setting up links to Windows folders..."

echo "Creating symbolic links to windows partitions:"
for dir in /mnt/*; do
    [ -d $dir ] && ln -sv ${dir} ${HOME}/${dir#/mnt/}
done

windirs=( Desktop Documents Pictures Downloads)
echo "Linking home folders:"
for dir in "${windirs[@]}"; do
    ln -sv ${WINHOME}/${dir} ${HOME}/${dir}
done

echo "Checking if OneDrive is present:"
if [ -e ${WINHOME}/OneDrive ]; then
    echo "OneDrive folder found, have you set up Known Folder Migrate for OneDrive? (y/N)"
    read kfm
    if [[ "${kfm,,}" == "y" || "$kfm" == "yes" ]]; then
        echo "Linking OneDrive folders:"
        for (( i=0; i<3; i++ )); do
            ln -sv ${WINHOME}/OneDrive/${windir[$i]} ${HOME}/${windir[$i]}
        done
    fi
fi


# Add environment variables to bashrc
echo "Setting environment variables in bashrc..."
cp ~/.bashrc ~/.bashrc.bak
if [ ! -n "$DISPLAY" ]; then
cat >> ~/.bashrc << DELIM


# Set DISPLAY for XServer in Windows
export DISPLAY=localhost:0.0

DELIM
fi
source ~/.bashrc

# Disable annoying Tab-completion beep in bash
echo "Disabling tab-completion beep..."
sudo sed -i.bak '/# set bell-style none/s/^# //' /etc/inputrc


# Install build-essential packages
echo "Installing developer packages..."
sudo apt install build-essential -y


# Ask for shell option
echo "Do you want to change your default shell to fish? (y/N)"
read shop
if [[ "${shop,,}" == "y" || "${shop,,}" == "yes" ]]; then
    sudo apt install fish -y
    sudo chsh -s $(which fish)
fi


# Copy config files
echo "Do you want to install the config files? WARNING: This will overwrite all existing config files! (y/N)"
read cfg
if [[ "${cfg,,}" == "y" || "${cfg,,}" == "yes" ]]; then
    cp -v .tmux.conf $HOME
    cp -rv .gnupg $HOME
    cp -rv .config $HOME
fi


echo "===== Configuration complete! Enjoy WSL! ====="