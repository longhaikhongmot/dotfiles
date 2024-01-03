#!/bin/sh

OS="uname -s"
DOTFILES_REPO="https://github.com/tatsupro/dotfiles.git"
PACKAGES_LIST="https://raw.githubusercontent.com/tatsupro/dotfiles/main/packages.csv"
DOTFILES_DIR="$HOME/.dotfiles"

# Installing packages
if type pacman >/dev/null; then
    curl -s $PACKAGES_LIST | tail -n +2 | cut -d ',' -f1 | xargs sudo pacman --noconfirm -Syu
fi

# Setup new shell
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.local/share/powerlevel10k"
if [[ $OS == "Linux" ]]; then
   ln -sf /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh $HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
   ln -sf /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh $HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-autosuggestions.plugin.zsh
fi
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