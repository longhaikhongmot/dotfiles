#!/bin/zsh

typeset -U PATH path

export EDITOR="nvim"
export BROWSER="firefox"

export GOPATH="$HOME/.local/share/go"
export PATH=$PATH:$(go env GOPATH)/bin
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export PF_INFO="ascii title os host cpu wm de kernel editor shell uptime memory pkgs palette"

