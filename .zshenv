#!/bin/zsh

typeset -U PATH path

export EDITOR="nvim"
export BROWSER="firefox"

export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

export GOPATH="$XDG_DATA_HOME/go"
export PATH=$PATH:$GOPATH/bin
export PYENV_ROOT="$XDG_DATA_HOME/.local/share/pyenv"

export CLOUDSDK_PYTHON="$PYENV_ROOT/shims/python"

export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export PF_INFO="ascii title os host cpu wm de kernel editor shell uptime memory pkgs palette"

