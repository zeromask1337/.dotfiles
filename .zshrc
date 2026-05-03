# styling
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# zsh setup
fpath=(~/.zsh/completions $fpath)
plugins=(zsh-autosuggestions fast-syntax-highlighting)

# exports
export ZSH=$HOME/.oh-my-zsh
export EDITOR=nvim
export FZF_COMPLETION_OPTS="--preview 'bat --style=numbers --color=always --line-range=:200 {} 2>/dev/null || sed -n \"1,200p\" {}' --preview-window=right:60%"

# ohmyzsh setup
source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

eval "$(fnm env --use-on-cd --shell zsh)"

# completions
source <(fzf --zsh)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# aliases
alias zshconfig="nvim ~/.zshrc"
alias tmuxconfig="nvim ~/.config/tmux/tmux.conf"
alias aeroconfig="nvim ~/.config/aerospace/aerospace.toml"
alias occonfig="nvim ~/.config/opencode/AGENTS.md"
alias sshconfig="nvim ~/.ssh/config"
alias lg="lazygit"
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias fixmypackage='sudo xattr -r -c'
alias oc='opencode'

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completions setup
autoload -Uz compinit
compinit

# bindings
bindkey '^k' autosuggest-accept
