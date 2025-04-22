export EDITOR="nvim"

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

# fzf
source <(fzf --zsh)

alias vim='nvim'
alias code='nvim'
alias ls="ls --color=auto -al"
alias lg="lazygit"

# starship
eval "$(starship init zsh)"
