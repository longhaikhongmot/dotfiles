# APPEARANCE
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
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

# SOURCING
# Add custom run commands that wouldn't push to public repo
POWERLEVEL10K_PATH="$HOME/.local/share/powerlevel10k/powerlevel10k.zsh-theme"
ZSH_SYNTAX_HIGHLIGHTING_PATH="$HOME/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
ZSH_AUTOSUGGESTIONS_PATH="$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
ALIASRC_PATH="$HOME/.config/zsh/alias"
CUSTOMRC_PATH="$HOME/.config/zsh/custom"


[ -f $POWERLEVEL10K_PATH ] && source $POWERLEVEL10K_PATH
[ -f $ZSH_SYNTAX_HIGHLIGHTING_PATH ] && source $ZSH_SYNTAX_HIGHLIGHTING_PATH
[ -f $ZSH_AUTOSUGGESTIONS_PATH ] && source $ZSH_AUTOSUGGESTIONS_PATH
[ -f $CUSTOMRC_PATH ] && source $CUSTOMRC_PATH
[ -f $ALIASRC_PATH ] && source $ALIASRC_PATH
[ -f $HOME/.p10k.zsh ] && source $HOME/.p10k.zsh
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
source $HOME/.local/scripts/*.sh
