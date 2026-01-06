#!/usr/bin/env bash
set -e

# Switch to the target session. Handles being inside or outside of tmux.
switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$1"
    else
        tmux switch-client -t "$1"
    fi
}

# Check if a session exists.
has_session() {
    tmux has-session -t "$1" 2>/dev/null
}

# Configure the windows for a newly created session.
setup_new_session_windows() {
    local session_name="$1"
    local session_path="$2"
    local editor_window_target="$session_name:editor"

    tmux new-window -t "$session_name" -c "$session_path" -n commands

    tmux select-window -t "$editor_window_target"

    local cmd="nvim ."

    if [ -f "$session_path/.tmux-sessionizer" ]; then
        cmd="source '$session_path/.tmux-sessionizer'; $cmd"
    elif [ -f "$HOME/.tmux-sessionizer" ]; then
        cmd="source '$HOME/.tmux-sessionizer'; $cmd"
    fi

    tmux send-keys -t "$editor_window_target" "$cmd" C-m
}


if [[ $# -eq 1 ]]; then
    selected=$1
else
    # Interactively select a directory
    selected=$(fd --min-depth 1 --max-depth 2 --type d . ~/projects/work ~/projects/personal ~ 2>/dev/null | fzf || true)
fi

if [[ -z $selected ]]; then
    exit 0
fi

# Sanitize the directory name to create a valid tmux session name.
selected_name=$(basename "$selected" | tr . _ | tr : _)
tmux_running=$(pgrep tmux || true)

# Create the session if it doesn't exist.
if ! has_session "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected" -n editor
    setup_new_session_windows "$selected_name" "$selected"
fi

# Attach to the session.
switch_to "$selected_name"
