#!/bin/sh

OS=$(uname -s)
DOTFILES_REPO="https://github.com/tatsupro/dotfiles.git"
PACMAN_LIST="https://raw.githubusercontent.com/tatsupro/dotfiles/main/.local/packages/pacman.csv"
HOMEBREW_LIST="https://raw.githubusercontent.com/tatsupro/dotfiles/main/.local/packages/homebrew.csv"
DOTFILES_DIR="$HOME/.dotfiles"

# Hello message
echo "Tatsu bootstraping script is running, it will ask for root permission for some process..."

# Installing packages
if type pacman >/dev/null; then
  curl -s $PACMAN_LIST | tail -n +2 | cut -d ',' -f1 | xargs sudo pacman -Syu --noconfirm
  return 0
fi
if type brew >/dev/null; then
  brew update && brew upgrade
  curl -s $HOMEBREW_LIST | tail -n +2 | cut -d ',' -f1 | xargs brew install
  return 0
fi


# Setup new shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.local/share/powerlevel10k"
git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$HOME/.local/share/zsh/plugins/fast-syntax-highlighting"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.local/share/zsh/plugins/zsh-autosuggestions"
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
