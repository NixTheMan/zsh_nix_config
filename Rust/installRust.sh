#!/usr/bin/bash

################
# Rust Install #
################

if ! command -v hx --version &> /dev/null
then
    echo "Beginning installation process for 'Rust'."
    read -p "Install 'Rust'? [y/n]: " RUST_OPTION
    RUST_OPTION=${RUST_OPTION:-"y"}

    case $HELIX_OPTION in
        y | Y)
            echo "Installing Rust..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
            echo "Rust installed..."
            rustup
            ;;
        
        n | N)
            echo "Skipping installation of 'Rust'"
            ;;
        
        *)
            echo "Unknown option detected. Skipping installation..."
            ;;
    esac
else
    echo "Rust installation found. Skipping installation..."
fi