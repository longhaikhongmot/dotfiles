#!/bin/sh

DOTFILES_REPO="https://github.com/tatsupro/dotfiles.git"
PACKAGES_LIST="https://raw.githubusercontent.com/tatsupro/dotfiles/main/packages.csv"
DOTFILES_DIR="$HOME/.dotfiles"

# Installing packages
if type pacman >/dev/null; then
    curl -s $PACKAGES_LIST | tail -n +2 | cut -d ',' -f1 | xargs sudo pacman -Syu
fi

# Change the default shell
chsh -s $(which zsh)

# Setup the dotfiles
git init --bare $DOTFILES_DIR
DOT="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"
$DOT config --local status.showUntrackedFiles no
cat > "$DOTFILES_DIR/info/sparse-checkout" << EOM
/*
!README.md
!LICENSE
!setup.sh
!packages.csv
EOM
$DOT config core.sparsecheckout true
$DOT branch -M main
$DOT remote add origin $DOTFILES_REPO 
$DOT pull origin main
