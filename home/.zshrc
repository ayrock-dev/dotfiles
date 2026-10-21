export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"

# brew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

# volta
export PATH="$VOLTA_HOME/bin:$PATH"


# fzf
source <(fzf --zsh)

alias vim='nvim'
alias code='nvim'
alias ls="ls --color=auto -al"
alias lg="lazygit"

# starship
eval "$(starship init zsh)"

# herdr-automatic-rename: name tabs after the foreground command
for _f in ${XDG_CONFIG_HOME}/herdr/plugins/github-installations/herdr-automatic-rename-*/*/checkout/shell/hook.zsh(N) \
          ${XDG_CONFIG_HOME}/herdr/plugins/github/herdr-automatic-rename-*/shell/hook.zsh(N); do
  source $_f; break
done
unset _f
