# APPEARANCE
autoload -U colors && colors # Load colors

# TWEAKS
# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files.
# Vi mode
bindkey -v
export KEYTIMEOUT=1
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
# Change cursor shape for different vi modes.
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
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

# Sourcing the configuration
# The alias file is public alias for whoever use this dotfiles
[ -f "$HOME/.config/zsh/alias" ] && source "$HOME/.config/zsh/alias"
# Use myrc to add custom run commands that wouldn't push to public repo
[ -f "$HOME/.config/zsh/myrc" ] && source "$HOME/.config/zsh/myrc"
# Use myenv to add custom user's variables
[ -f "$HOME/.config/zsh/myenv" ] && source "$HOME/.config/zsh/myenv"
# and myalias is custom alias file that wouldn't push to public repo
[ -f "$HOME/.config/zsh/myalias" ] && source "$HOME/.config/zsh/myalias"
