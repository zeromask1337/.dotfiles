export XDG_CONFIG_HOME=$HOME/.config
export BUN_INSTALL="$HOME/.bun"
export STARSHIP_CONFIG=$HOME/.config/starship.toml

if [[ "$OSTYPE" == darwin* ]]; then
  export PATH=$PATH:/opt/homebrew/bin
  export PATH=$PATH:/Applications/Obsidian.app/Contents/MacOS
  export HOMEBREW_NO_ENV_HINTS=1

  # agent-browser: real Chrome profile (cookies/logins) for every session.
  # Drop AGENT_BROWSER_PROFILE/AGENT_BROWSER_CONFIG per command to use an isolated browser.
  export AGENT_BROWSER_CONFIG=$HOME/.config/agent-browser/real-profile.json

  [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
else
  # Linuxbrew binaries (formulae live here; brew itself is not installed)
  case ":$PATH:" in
    *":/home/linuxbrew/.linuxbrew/bin:"*) ;;
    *) export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin" ;;
  esac
fi
