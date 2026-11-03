# styling
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

# zsh setup
# completions must be on fpath before oh-my-zsh runs compinit
fpath=(
  ~/.zfunc
  ~/.zsh/completions
  /opt/homebrew/share/zsh-completions
  /opt/homebrew/share/zsh/site-functions
  $fpath
)

# generate completions for tools that don't ship them (cached in ~/.zfunc)
[ -x ~/.config/scripts/gen-zsh-completions ] && ~/.config/scripts/gen-zsh-completions

# exports
export ZSH=$HOME/.oh-my-zsh
export EDITOR=nvim
export FZF_COMPLETION_OPTS="--preview 'bat --style=numbers --color=always --line-range=:200 {} 2>/dev/null || sed -n \"1,200p\" {}' --preview-window=right:60%"

# ohmyzsh setup
source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

eval "$(mise activate zsh)"

# completions (fzf-tab before plugins that wrap widgets)
source /opt/homebrew/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh
source <(fzf --zsh)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# aliases
alias zshrc="nvim ~/.zshrc"
alias tmuxrc="nvim ~/.config/tmux/tmux.conf"
alias aerorc="nvim ~/.config/aerospace/aerospace.toml"
alias ocrc="nvim ~/.config/opencode/opencode.json"
alias miserc="nvim ~/.config/mise/config.toml"
alias sshrc="nvim ~/.ssh/config"
alias hrc='hermes config edit'
alias lg="lazygit"
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias fixmypackage='sudo xattr -r -c'
alias oc='doppler run -- opencode'
alias occ='doppler run -- opencode --continue'
alias ocr='doppler run -- opencode run'

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# zsh plugins (brew)
source /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# bindings
bindkey '^k' autosuggest-accept

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"
