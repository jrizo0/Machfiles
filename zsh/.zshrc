#!/bin/sh
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
  claude --dangerously-skip-permissions
}

export PATH="$HOME/.local/bin:$PATH"
