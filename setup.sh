#!/bin/sh

DOTFILES_REPO="${1:-"https://github.com/tatsupro/dotfiles.git"}"
DOTFILES_DIR="$HOME/.dotfiles"

git init --bare $DOTFILES_DIR --quiet
alias dot="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"
exec $SHELL
dot config --local status.showUntrackedFiles no
cat > "$DOTFILES_DIR/info/sparse-checkout" << EOM
!README.md
!LICENSE
!setup.sh
EOM

dot branch -M main
dot pull origin main
