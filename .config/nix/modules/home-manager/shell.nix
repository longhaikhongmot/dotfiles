{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      # Source custom files
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
      fi

      # Vi mode
      bindkey -v
      bindkey -M viins 'jj' vi-cmd-mode

      # Change cursor shape for different vi modes
      function zle-keymap-select() {
        case $KEYMAP in
          vicmd) echo -ne '\e[1 q';;      # block
          viins|main) echo -ne '\e[5 q';; # beam
        esac
      }
      zle -N zle-keymap-select
      zle-line-init() {
        zle -K viins
        echo -ne "\e[5 q"
      }
      zle -N zle-line-init
      echo -ne '\e[5 q'
      preexec() { echo -ne '\e[5 q' ;}

      # Edit line in vim with ctrl-e
      autoload edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line
      bindkey -M vicmd '^[[P' vi-delete-char
      bindkey -M vicmd '^e' edit-command-line
      bindkey -M visual '^[[P' vi-delete

      # Fuzzy Finder
      ${pkgs.fzf}/bin/fzf --zsh

      # Load custom scripts
      for script in $XDG_DATA_HOME/scripts/*; do source $script; done
      # Load Powerlevel10k theme
      source "$XDG_CONFIG_HOME/zsh/.p10k.zsh"
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Load plugins
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      # Display pfetch if available
      if command -v pfetch &> /dev/null; then
        pfetch
      fi
    '';
    shellAliases = {
      dot = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
      v = "nvim";
      c = "code";
      ll = "ls -lSGh";
      tf = "terraform";
      dc = "docker-compose";

      g = "git";
      gc = "git clone";
      gf = "git fetch";
      gps = "git push";
      gpl = "git pull";
      gpso = "git push origin";
      gplo = "git pull origin";
      gpsm = "git push origin main";
      gplm = "git pull origin main";
      gb = "git branch";
      gch = "git checkout";
      gcb = "git checkout -b";
      gcm = "git checkout main";
      gl = "git log";
      gll = "git ll";
      gs = "git stash";
      gsl = "git stash list";
      gsa = "git stash apply";
      gsd = "git stash drop";

      k="kubectl";
      kg="kubectl get";
      kd="kubectl describe";
      kl="kubectl logs";
      ke="kubectl explain";
      kn="kubens";
      kc="kubectx";
      kgp="kubectl get pod";
      kgsv="kubectl get service";
      kgd="kubectl get deploy";
      kgpa="kubectl get pods -A";
      kgsa="kubectl get secrets -A";
      kgna="kubectl get nodes -A";
      kgrc="kubectl get rc";
      kgn="kubectl get node";
      kgs="kubectl get secret";
      kdp="kubectl describe pod";
      kds="kubectl describe service";
      kdd="kubectl describe deploy";
      keit="kubectl exec -it";
      ktop="kubectl top nodes";
      kevent="kubectl get events";
    };
    envExtra = ''
      export OS=$(uname -s)
      export EDITOR="nvim"

      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_STATE_HOME="$HOME/.local/state"

      [ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"
      export PATH="$PATH:$(find ~/.local/bin -type d | paste -sd ':' -)"
      unsetopt PROMPT_SP 2>/dev/null

      [ -d "$XDG_CACHE_HOME/zsh" ] || mkdir -p "$XDG_CACHE_HOME/zsh"
      export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
      export HISTFILE="$XDG_CACHE_HOME/zsh/history"
      export HISTSIZE=10000000
      export SAVEHIST=10000000
      export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
      export KEYTIMEOUT=50
      export PF_INFO="ascii title os kernel host cpu memory uptime pkgs palette"
    '';
  };
}
