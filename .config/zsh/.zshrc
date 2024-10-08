# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# APPEARANCE
autoload -U colors && colors # Load colors
setopt autocd # Automatically cd into typed directory.
stty stop undef > /dev/null 2>&1 # Disable ctrl-s to freeze terminal.
setopt interactive_comments

# TWEAKS
# Vi mode
bindkey -v
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

# KEYBIND
# Edit line in vim with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete
# Fuzzy Finder
eval "$(fzf --zsh)"

# SOURCING
# source "$XDG_DATA_HOME/zsh/plugins/p10k/powerlevel10k.zsh-theme" 2>/dev/null
source "$XDG_CONFIG_HOME/zsh/.p10k.zsh" 2>/dev/null
# source "$XDG_DATA_HOME/zsh/plugins/highlight/fast-syntax-highlighting.plugin.zsh" 2>/dev/null
# source "$XDG_DATA_HOME/zsh/plugins/autosuggest/zsh-autosuggestions.zsh" 2>/dev/null
source "$XDG_CONFIG_HOME/zsh/alias" 2>/dev/null
source "$XDG_CONFIG_HOME/zsh/custom" 2>/dev/null
for script in $XDG_DATA_HOME/scripts/*; do source $script; done

if command -v pfetch &> /dev/null; then
    pfetch
fi
