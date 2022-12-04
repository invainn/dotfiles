# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh stuff
export ZSH="/Users/anthony.bennett/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  brew
)
source $ZSH/oh-my-zsh.sh

# Functions
fn_exists() {
  type $1 | grep -q 'shell function'
}

# Conditional sourcing
if [ -f "/Users/anthony.bennett/.rlrc" ]; then
  source ~/.rlrc
fi

# Aliases 
alias vim="nvim"
alias pip="pip3"

# Other stuff
if [ -n "fn_exists nodenv" ]; then
  eval "$(nodenv init -)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
