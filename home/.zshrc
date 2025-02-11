PS1="%n %1~ λ "

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

# bun completions
[ -s "/Users/elee/.bun/_bun" ] && source "/Users/elee/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fzf
source <(fzf --zsh)

alias vim='nvim'

# starship
eval "$(starship init zsh)"
