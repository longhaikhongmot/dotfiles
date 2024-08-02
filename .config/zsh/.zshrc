# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# APPEARANCE
autoload -U colors && colors # Load colors
setopt autocd # Automatically cd into typed directory.
stty stop undef > /dev/null 2>&1 # Disable ctrl-s to freeze terminal.
setopt interactive_comments

# TWEAKS
# Vi mode
bindkey -v
export KEYTIMEOUT=50
bindkey -M viins 'jj' vi-cmd-mode
# Change cursor shape for different vi modes
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # Initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt
# Edit line in vim with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete
# Fuzzy Finder
eval "$(fzf --zsh)"
# Caching folder
[ -f "$HOME/.local/cache/zsh" ] && mkdir -p "$HOME/.local/cache/zsh"

# SOURCING
# Add custom run commands that wouldn't push to public repo
source "$HOME/.local/plugin/p10k/powerlevel10k.zsh-theme" 2>/dev/null
source "$HOME/.config/zsh/.p10k.zsh" 2>/dev/null
source "$HOME/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 2>/dev/null
source "$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autocomplete.plugin.zsh" 2>/dev/null
source "$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null
source "$HOME/.config/zsh/alias" 2>/dev/null
source "$HOME/.config/zsh/custom" 2>/dev/null
for custom_scripts in $HOME/.local/scripts/*.sh; do
    source "$custom_scripts"
done

# pfetch cuz it looks cool
if command -v pfetch &> /dev/null; then
    pfetch
fi
