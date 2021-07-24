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
    aws
    brew
    git
    zsh-syntax-highlighting
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

# Other stuff
[[ -n "$(fn_exists nodenv)" ]] && eval "$(nodenv init -)"
