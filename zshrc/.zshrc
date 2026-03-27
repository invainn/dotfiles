# zsh stuff
if [ -d "$HOME/.oh-my-zsh" ]; then
  export ZSH="$HOME/.oh-my-zsh"
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
    pnpm
  )
  source $ZSH/oh-my-zsh.sh
fi

# Functions
fn_exists() {
  type $1 | grep -q 'shell function'
}

# Conditional sourcing
[[ -f ~/.other ]] && source ~/.other
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
[[ -f ~/.path ]] && source ~/.path

# Aliases 
alias vim="nvim"
alias pip="pip3"
alias fv='vim $(fzf)'
alias ll='ls -lah'
alias tfmt='terraform fmt -recursive'
alias shit='git reset --soft HEAD~1'
alias lg='lazygit'
alias oc='opencode'

# Environment variables
export EDITOR=nvim

# Other stuff
if [ -e /Users/anthony.bennett/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/anthony.bennett/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
unset LESS
compinit

# starship
eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# mise
eval "$(/opt/homebrew/bin/mise  activate zsh)"
