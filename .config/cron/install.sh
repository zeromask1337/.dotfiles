#!/bin/sh
# Install the crontab managed in the dotfiles repo.
#
# Source of truth: ~/.dotfiles/.config/cron/crontab
#
# Idempotent: compares the current crontab with the source and only replaces
# it when they differ. The previous crontab is backed up to
# ~/.local/state/dotfiles-cron/crontab.bak before being replaced.
#
# Usage:
#   ~/.dotfiles/.config/cron/install.sh
#   CRONTAB_SOURCE=/path/to/crontab ~/.dotfiles/.config/cron/install.sh

set -eu

source_file="${CRONTAB_SOURCE:-$HOME/.dotfiles/.config/cron/crontab}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-cron"

log() { echo "cron: $*"; }

if [ ! -f "$source_file" ]; then
  log "no crontab source at $source_file; nothing to do"
  exit 0
fi

if ! command -v crontab >/dev/null 2>&1; then
  log "crontab command not available; skipping"
  exit 0
fi

current="$(crontab -l 2>/dev/null || true)"
desired="$(cat "$source_file")"

if [ "$current" = "$desired" ]; then
  log "crontab already matches $source_file"
  exit 0
fi

if [ -n "$current" ]; then
  mkdir -p "$state_dir"
  printf '%s\n' "$current" >"$state_dir/crontab.bak"
  log "backed up previous crontab to $state_dir/crontab.bak"
fi

crontab "$source_file"
log "installed crontab from $source_file"

if [ "$(crontab -l 2>/dev/null || true)" != "$desired" ]; then
  echo "cron: installed crontab does not match the source" >&2
  exit 1
fi
