#!/bin/sh
# HISTFILE="$XDG_DATA_HOME"/zsh/history
HISTSIZE=1000000
SAVEHIST=1000000
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="brave"
export PATH="$HOME/.local/bin":$PATH
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/share/go/bin:$PATH
export GOPATH=$HOME/.local/share/go
export PATH=$HOME/.fnm:$PATH
export PATH="$HOME/.local/share/fnm:$PATH"
export PATH="$HOME/Library/Application Support/fnm:$PATH"
export PATH="$HOME/.local/share/neovim/bin":$PATH
# export XDG_CURRENT_DESKTOP="Wayland"
#export PATH="$PATH:./node_modules/.bin"
command -v fnm &> /dev/null && eval "$(fnm env)"
eval "$(zoxide init zsh)"
# eval "`pip completion --zsh`"


# conda: lazy-load (el hook de conda arranca python y es lento;
# solo se inicializa la primera vez que se usa el comando `conda`)
if [ -x "$HOME/.miniconda/bin/conda" ]; then
    conda() {
        unfunction conda
        eval "$("$HOME/.miniconda/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)" \
            || . "$HOME/.miniconda/etc/profile.d/conda.sh" 2> /dev/null \
            || export PATH="$HOME/.miniconda/bin:$PATH"
        conda "$@"
    }
fi

