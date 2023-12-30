#!/bin/sh

DOTFILES_REPO="${1:-"https://github.com/tatsupro/dotfiles.git"}"
DOTFILES_DIR="$HOME/.dotfiles"

git init --bare $DOTFILES_DIR
DOT="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"
$DOT config --local status.showUntrackedFiles no
cat > "$DOTFILES_DIR/info/sparse-checkout" << EOM
!README.md
!LICENSE
!setup.sh
EOM

$DOT branch -M main
$DOT remote add origin $DOTFILES_REPO 
$DOT pull origin main
