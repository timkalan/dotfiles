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

# Run a setup script inside the new session if one exists.
hydrate() {
    if [ -f "$2/.tmux-sessionizer" ]; then
        tmux send-keys -t "$1" "source '$2/.tmux-sessionizer'" C-m
    elif [ -f "$HOME/.tmux-sessionizer" ]; then
        tmux send-keys -t "$1" "source '$HOME/.tmux-sessionizer'" C-m
    fi
}

# Configure the windows for a newly created session.
setup_new_session_windows() {
    local session_name="$1"
    local session_path="$2"
    local editor_window_target="$session_name:editor"

    tmux new-window -t "$session_name" -c "$session_path" -n commands

    tmux select-window -t "$editor_window_target"

    tmux send-keys -t "$editor_window_target" 'nvim .' C-m
    hydrate "$session_name" "$session_path"
}


if [[ $# -eq 1 ]]; then
    selected=$1
else
    # Interactively select a directory
    selected=$(fd --hidden --no-ignore --min-depth 1 --max-depth 2 --type d . ~ ~/projects/work ~/projects/personal ~/.config 2>/dev/null | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

# Sanitize the directory name to create a valid tmux session name.
selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# Case 1: No tmux server is running. Create one.
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected" -n editor
    setup_new_session_windows "$selected_name" "$selected"
    exit 0
fi

# Case 2: Tmux server is running, but the session doesn't exist. Create it detached.
if ! has_session "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected" -n editor
    setup_new_session_windows "$selected_name" "$selected"
fi

# Attach to the session (which now is guaranteed to exist).
switch_to "$selected_name"
