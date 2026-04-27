#!/bin/sh

# Initialize Homebrew PATH first (before loading any plugins)
if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"


# history
HISTFILE=~/.zsh_history

# source
plug "$HOME/.config/zsh/aliases.zsh"
plug "$HOME/.config/zsh/exports.zsh"
# plug "$HOME/.config/zsh/custom-prompt.zsh"

# plugins
plug "esc/conda-zsh-completion"
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
plug "zap-zsh/vim"
plug "zap-zsh/zap-prompt"
plug "zap-zsh/fzf"
# plug "zap-zsh/exa"
plug "zsh-users/zsh-syntax-highlighting"

# keybinds
bindkey '^ ' autosuggest-accept
bindkey -s '^f' "tmux-sessionizer\n"


export PATH="$HOME/.local/bin":$PATH

if command -v bat &> /dev/null; then
  alias cat="bat -pp --theme \"Visual Studio Dark+\"" 
  alias catt="bat --theme \"Visual Studio Dark+\"" 
fi

# vim switcher
# alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
# alias nvim-kick="NVIM_APPNAME=kickstart nvim"
# alias nvim-chad="NVIM_APPNAME=NvChad nvim"
# alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"
alias nvim-astro="NVIM_APPNAME=lvim nvim"
alias nvim-mini="NVIM_APPNAME=minvim nvim"
alias v="nvim"

function nvims() {
  # items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")
  items=("default" "minvim" "newvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# end vim switcher

# fnm
export PATH="/home/jrizo/.local/share/fnm:$PATH"
eval "`fnm env`"

# fnm
export PATH="/Users/jrizo/Library/Application Support/fnm:$PATH"
eval "`fnm env`"

# pnpm
export PNPM_HOME="/Users/jrizo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
alias pn="pnpm"
# pnpm end

# bun completions
[ -s "/Users/jrizo/.bun/_bun" ] && source "/Users/jrizo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

#python
alias py="python3"

fpath+=~/.zfunc

# Google Chrome to path
PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome":$PATH

cc(){
  CLAUDE_CODE_NO_FLICKER=1 claude --dangerously-skip-permissions
}

export PATH="$HOME/.local/bin:$PATH"


export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# opencode
export PATH=/home/jrizo/.opencode/bin:$PATH

# opencode
export PATH=/Users/jrizo/.opencode/bin:$PATH

# === CONFIG ===
REPO_PATH="/Users/jrizo/Work/pioneer"
LOG_FILE="/Users/jrizo/Desktop/pioneer-command-diary.log"

# Variables internas
typeset -g CMD_START_TIME
typeset -g CMD_START_PWD
typeset -g CMD_RUNNING

# Se ejecuta justo ANTES del comando
preexec() {
  if [[ "$PWD" == "$REPO_PATH"* ]]; then
    CMD_START_TIME=$(date +%s)
    CMD_START_PWD="$PWD"
    CMD_RUNNING="$1"
  else
    CMD_RUNNING=""
  fi
}

# Se ejecuta justo ANTES de mostrar el prompt (cuando terminó)
precmd() {
  if [[ -n "$CMD_RUNNING" ]]; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - CMD_START_TIME))

    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    {
      echo "----------------------------------------"
      echo "Date      : $TIMESTAMP"
      echo "Directory : $CMD_START_PWD"
      echo "Command   : $CMD_RUNNING"
      echo "Duration  : ${DURATION}s"
    } >> "$LOG_FILE"

    CMD_RUNNING=""
  fi
}


# send screenshot to vps
send-screenshot() {
  LATEST=$(ls -t ~/Desktop/Screenshot*.png 2>/dev/null | head -1)
  if [ -z "$LATEST" ]; then
    echo "No hay screenshots en Desktop"
    return 1
  fi
  FILENAME="screenshot-$(date +%s).png"
  scp "$LATEST" jrizo@100.107.255.126:/tmp/$FILENAME
  echo "/tmp/$FILENAME" | pbcopy
  echo "Disponible en: /tmp/$FILENAME"
}


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jrizo/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jrizo/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jrizo/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jrizo/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
