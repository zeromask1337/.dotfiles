export XDG_CONFIG_HOME=$HOME/.config

export BUN_INSTALL="$HOME/.bun"

export PATH=$PATH:$BUN_INSTALL/bin
export PATH=$PATH:$HOME/Library/pnpm
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:$HOME/.local/share/bob/nvim-bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.dotfiles/.config/scripts

export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1
export HOMEBREW_BUNDLE_DUMP_NO_CARGO=1
export HOMEBREW_NO_ENV_HINTS=1

export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

# agent-browser: real Chrome profile (cookies/logins) for every session.
# Drop AGENT_BROWSER_PROFILE/AGENT_BROWSER_CONFIG per command to use an isolated browser.
export AGENT_BROWSER_CONFIG=$HOME/.config/agent-browser/real-profile.json

source "$HOME/.cargo/env"

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
