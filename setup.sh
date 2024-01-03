#!/bin/sh

OS="uname -s"
DOTFILES_REPO="https://github.com/tatsupro/dotfiles.git"
PACKAGES_LIST="https://raw.githubusercontent.com/tatsupro/dotfiles/main/packages.csv"
DOTFILES_DIR="$HOME/.dotfiles"

# Hello message
echo "Tatsu bootstraping script is running, it will ask for root permission for some process..."

# Installing packages
if type pacman >/dev/null; then
    curl -s $PACKAGES_LIST | tail -n +2 | cut -d ',' -f1 | xargs sudo pacman --noconfirm -Syu
fi

# Setup new shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.local/share/powerlevel10k"
mkdir -p /home/tatsu/.local/share/zsh/plugins/zsh-syntax-highlighting
mkdir -p /home/tatsu/.local/share/zsh/plugins/zsh-autosuggestions
if [[ $OS == "Linux" ]]; then
   ln -sf /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh $HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
   ln -sf /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh $HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-autosuggestions.plugin.zsh
fi
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
!packages.csv
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