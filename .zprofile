export PNPM_HOME="$HOME/Library/pnpm"
export XDG_CONFIG_HOME=$HOME/.config

export BUN_INSTALL="$HOME/.bun"

export PATH=$PATH:$BUN_INSTALL/bin
export PATH=$PATH:$PNPM_HOME
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:$HOME/.local/share/bob/nvim-bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.dotfiles/.config/scripts

export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1
export HOMEBREW_BUNDLE_DUMP_NO_CARGO=1
export HOMEBREW_NO_ENV_HINTS=1

source "$HOME/.cargo/env"
