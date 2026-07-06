export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"

# brew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1


# fzf
source <(fzf --zsh)

alias vim='nvim'
alias code='nvim'
alias ls="ls --color=auto -al"
alias lg="lazygit"

# starship
eval "$(starship init zsh)"
