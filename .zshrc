# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fpath=(~/.zsh/completions $fpath)
plugins=(zsh-autosuggestions fast-syntax-highlighting)

export ZSH=$HOME/.oh-my-zsh
export EDITOR=nvim
export FZF_COMPLETION_OPTS="--preview 'bat --style=numbers --color=always --line-range=:200 {} 2>/dev/null || sed -n \"1,200p\" {}' --preview-window=right:60%"

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh) # Set up fzf key bindings and fuzzy completion

alias zshconfig="nvim ~/.zshrc"
alias tmuxconfig="nvim ~/.config/tmux/tmux.conf"
alias aeroconfig="nvim ~/.config/aerospace/aerospace.toml"
alias occonfig="nvim ~/.config/opencode/AGENTS.md"
alias sshconfig="nvim ~/.ssh/config"
alias lg="lazygit"
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias fixmypackage='sudo xattr -r -c'
alias oc='opencode'

ZSH_THEME="powerlevel10k/powerlevel10k"

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

autoload -Uz compinit
compinit

bindkey '^k' autosuggest-accept
