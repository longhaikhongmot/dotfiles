dotpac_manual() {
    echo "
Dotpac is a helper shell function for managing pacman or homebrew packages in this dotfiles.

Usage:
    dotpac <command> [arguments]

The comands are:
    add     register package to remote and install
    install fetching the packages list from remote and install
    help    display this manual

add command usage:
    dotpac add [package manager name] [package name]
"
}

dotpac() {
    local -r pacman_list="https://raw.githubusercontent.com/tatsupro/dotfiles/main/.local/packages/pacman.csv"
    local -r homebrew_list="https://raw.githubusercontent.com/tatsupro/dotfiles/main/.local/packages/homebrew.csv"

    local -r powerlevel10k_remote="https://github.com/romkatv/powerlevel10k.git"
    local -r fast_syntax_highlighting_remote="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
    local -r autosuggestions_remote="https://github.com/zsh-users/zsh-autosuggestions"
    local -r powerlevel10k_path="$HOME/.local/share/powerlevel10k"
    local -r fast_syntax_highlighting_path="$HOME/.local/share/zsh/plugins/fast-syntax-highlighting"
    local -r autosuggestions_path="$HOME/.local/share/zsh/plugins/zsh-autosuggestions"

    if [ -z "$1" ]; then
        dotpac_manual
        return 1
    fi

    if [[ "$1" == "help" ]]; then
        dotpac_manual
        return 0
    fi

    if [[ "$1" == "install" ]]; then
        if type pacman >/dev/null; then
            curl -s $pacman_list | tail -n +2 | cut -d ',' -f1 | xargs sudo pacman -Syu --noconfirm
        fi

        if type brew >/dev/null; then
            brew update && brew upgrade
            curl -s $homebrew_list | tail -n +2 | cut -d ',' -f1 | xargs brew install
        fi

        rm -fr $powerlevel10k_path $fast-syntax-highlighting_path $autosuggestions_path
        git clone --depth=1 $powerlevel10k_remote $powerlevel10k_path
        git clone --depth=1 $fast_syntax_highlighting_remote $fast_syntax_highlighting_path
        git clone --depth=1 $autosuggestions_remote $autosuggestions_path

        return 0
    fi

    if [[ "$1" == "add" ]]; then
        if [[ -z "$2" || -z "$3" ]]; then
            echo "Invalid arguments"
            return 1
        fi

        if [[ "$2" != "pacman" && "$2" != "homebrew" ]]; then
            echo "Unknown package manager"
            return 1
        fi

        read -p "Package description: " description
        echo "$3, $description" >> "$HOME/.local/packages/$2.csv"
        dot add "$HOME/.local/packages/$2.csv"
        dot commit -m "add $3"
        dot push origin main
        dotpac install
        return 0
    fi
}
