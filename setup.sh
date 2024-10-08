#!/bin/sh

OS=$(uname -s)
XDG_DATA_HOME="$HOME/.local/share"
BASE_PACKAGES_URL="https://raw.githubusercontent.com/tatsupro/dotfiles/main/.local/share/dotfiles/packages"

DOTFILES_REPO="https://github.com/tatsupro/dotfiles.git"
PACMAN_LIST="$BASE_PACKAGES_URL/pacman.csv"
HOMEBREW_LIST="$BASE_PACKAGES_URL/homebrew.csv"
DOTFILES_DIR="$HOME/.dotfiles"

# Hello message
echo "Tatsu bootstraping script is running, it will ask for root permission for some process..."

# Installing packages
nixos_install_command="sh <(curl -L https://nixos.org/nix/install)"
if [ "$OS" = "Linux" ]; then
  nixos_install_command="$nixos_install_command --daemon"
fi
$nixos_install_command

# Setup new shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$XDG_DATA_HOME/zsh/plugins/p10k"
git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$XDG_DATA_HOME/zsh/plugins/highlight"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$XDG_DATA_HOME/zsh/plugins/autosuggest"
sudo chsh -s $(which zsh) $(whoami)

# Setup the dotfiles
git init --bare $DOTFILES_DIR
DOT="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"
$DOT config --local status.showUntrackedFiles no
cat > "$DOTFILES_DIR/info/sparse-checkout" << EOM
/*
!README.md
!LICENSE
!setup.sh
EOM
$DOT config core.sparsecheckout true
$DOT branch -M main
$DOT remote add origin $DOTFILES_REPO 
$DOT pull origin main

# Completed message
echo """
The script completely executed, you'll need to enter new shell to use it
by running: exec zsh
"""
