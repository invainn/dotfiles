# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh stuff
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME="powerlevel10k/powerlevel10k"
  plugins=(
    z
    aws
    alias-tips
    zsh-autosuggestions
    zsh-syntax-highlighting
    colorize
    git
    colored-man-pages
    docker-compose
    yarn
    history-substring-search
    kubectl
    node
    docker
    npm
    asdf
  )
  source $ZSH/oh-my-zsh.sh
fi

# Functions
fn_exists() {
  type $1 | grep -q 'shell function'
}

# Conditional sourcing
[[ -f ~/.rlrc ]] && source ~/.rlrc
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.path ]] && source ~/.path

# Aliases 
alias vim="nvim"
alias pip="pip3"
alias fv='vim $(fzf)'
alias ll='ls -lah'
alias tfmt='terraform fmt -recursive'

# Environment variables
export EDITOR=nvim

# Other stuff
# [[ -n "$(fn_exists nodenv)" ]] && eval "$(nodenv init -)"
if [ -e /Users/anthony.bennett/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/anthony.bennett/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
# . /usr/local/opt/asdf/libexec/asdf.sh
# eval "$(nodenv init -)"
unset LESS
compinit
