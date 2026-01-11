#!/bin/bash

ROOTS=(
  "$HOME/Development"
  "$HOME/.config"
)

PINNED=(
  "$HOME/.dotfiles"
)

if [[ $# -eq 1 ]]; then
  selected=$1
else
  selected=$(
    {
      printf '%s\n' "${PINNED[@]}"
      fd . "${ROOTS[@]}" --type=dir --max-depth=1 --full-path
    } | awk '!seen[$0]++' \
      | sed "s|^$HOME/||" \
      | fzf --margin 10% --color="bw" \
      | sed "s|^|$HOME/|"
  )
fi

[[ -z $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)

if ! tmux has-session -t "$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
  tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"
