#!/usr/bin/env bash
set -e

switch_to() {
    if [[ -z $TMUX ]]; then
        tmux attach-session -t $1
    else
        tmux switch-client -t $1
    fi
}

has_session() {
    tmux has-session -t "$1" 2>/dev/null
}

hydrate() {
    if [ -f "$2/.tmux-sessionizer" ]; then
        tmux send-keys -t "$1" "source '$2/.tmux-sessionizer'" C-m
    elif [ -f "$HOME/.tmux-sessionizer" ]; then
        tmux send-keys -t "$1" "source '$HOME/.tmux-sessionizer'" C-m
    fi
}

setup_new_session_windows() {
    local session_name="$1"
    local session_path="$2"
    local editor_window_target="$session_name:1"

    tmux send-keys -t "$editor_window_target" 'nvim .' C-m
    tmux new-window -t "$session_name" -c "$session_path" -n commands # Creates next available window
    tmux select-window -t "$editor_window_target" # Ensure focus is on the editor window
    hydrate "$session_name" "$session_path"
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd --hidden --no-ignore --min-depth 1 --max-depth 2 --type d . ~ ~/projects/work ~/projects/personal ~/.config 2>/dev/null | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    # tmux new-session starts server, creates session, and attaches
    tmux new-session -s "$selected_name" -c "$selected" -n editor
    setup_new_session_windows "$selected_name" "$selected"
    # No need to explicitly attach here, new-session does it.
    exit 0
fi

if ! has_session "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected" -n editor
    setup_new_session_windows "$selected_name" "$selected"
fi

switch_to $selected_name
