#!/bin/sh

DOTFILES_REPO="${1:-"https://github.com/tatsupro/dotfiles.git"}"
DOTFILES_DIR="$HOME/.dotfiles"

# Installing packages
if type pacman >/dev/null; then
    tail -n +2 packages.csv | cut -d ',' -f1 | xargs sudo pacman -Syu
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
