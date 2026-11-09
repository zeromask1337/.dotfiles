#!/bin/sh
# Install the systemd user unit managed in the dotfiles repo (Linux only).
#
# Source of truth: ~/.dotfiles/.config/systemd/user/opencode-service-restart.service
#
# Idempotent. Links the unit into the user unit dir (unless it is already there
# via the dotfiles symlink), enables it for default.target, and reloads systemd
# when a user bus is available.
#
# Usage:
#   mise bootstrap                            # full machine apply
#   ~/.dotfiles/.config/systemd/install.sh    # unit only

set -eu

unit="opencode-service-restart.service"
src="$HOME/.dotfiles/.config/systemd/user/$unit"
dst_dir="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
dst="$dst_dir/$unit"

log() { echo "systemd: $*"; }

if [ "$(uname -s)" != "Linux" ]; then
  log "not Linux; nothing to do"
  exit 0
fi

if ! command -v systemctl >/dev/null 2>&1; then
  log "systemctl not available; skipping"
  exit 0
fi

if [ ! -f "$src" ]; then
  log "missing unit source at $src"
  exit 1
fi

mkdir -p "$dst_dir"

if [ "$dst" -ef "$src" ]; then
  log "unit already in place via dotfiles link"
elif [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
  log "unit already linked"
else
  rm -f "$dst"
  ln -s "$src" "$dst"
  log "linked $dst -> $src"
fi

# Enable without requiring a live user bus: same symlink systemctl would create.
wants="$dst_dir/default.target.wants"
mkdir -p "$wants"
if [ -L "$wants/$unit" ] && [ "$(readlink "$wants/$unit")" = "$src" ]; then
  log "already enabled for default.target"
else
  rm -f "$wants/$unit"
  ln -s "$src" "$wants/$unit"
  log "enabled for default.target"
fi

if systemctl --user daemon-reload >/dev/null 2>&1; then
  log "daemon reloaded"
else
  log "no user bus right now; will load at next login"
fi
