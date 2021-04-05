# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

fpath=(/opt/homebrew/share/zsh/site-functions/  /opt/homebrew/share/zsh-completions $fpath)
autoload -Uz compinit && compinit

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

groot() {
  cd "$(git rev-parse --show-toplevel)"
}

source ~/.powerlevel10k/powerlevel10k.zsh-theme
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias ls="lsd"
alias ll="ls -l"
alias la="ls -A"
alias lal="ls -Al"
alias lla="ls -lA"

alias cat="bat"
alias man="batman"
alias vi="nvim"

eval "$(zoxide init zsh)"

