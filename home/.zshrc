# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

# fzf
source <(fzf --zsh)

alias vim='nvim'

# starship
eval "$(starship init zsh)"
