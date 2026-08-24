#!/usr/bin/env bash
set -e

# herdr nests session > workspace > tab > pane, so a project maps to a
# workspace (not a session, which is a whole separate server namespace).

# Every herdr CLI command prints its socket response as JSON on stdout,
# errors included, so a failed call still yields parseable output.
server_is_up() {
    herdr workspace list 2>/dev/null | jq -e '.result' >/dev/null 2>&1
}

# CLI commands talk to a server over a socket and nothing autostarts it.
ensure_server() {
    if server_is_up; then
        return 0
    fi
    herdr server >/dev/null 2>&1 &
    for _ in $(seq 1 50); do
        if server_is_up; then
            return 0
        fi
        sleep 0.1
    done
    echo "herdr server did not come up" >&2
    exit 1
}

workspace_id_for() {
    herdr workspace list 2>/dev/null \
        | jq -r --arg label "$1" \
            '.result.workspaces // [] | .[] | select(.label == $label) | .workspace_id' \
        | head -n1
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    # Interactively select a directory
    selected=$(fd --min-depth 1 --max-depth 1 --type d . ~/projects ~/projects/work ~/projects/personal ~ 2>/dev/null | fzf || true)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _ | tr : _)

ensure_server
workspace_id=$(workspace_id_for "$selected_name")

if [[ -z $workspace_id ]]; then
    created=$(herdr workspace create --cwd "$selected" --label "$selected_name" --no-focus)
    workspace_id=$(jq -r '.result.workspace.workspace_id' <<<"$created")
    editor_tab_id=$(jq -r '.result.tab.tab_id' <<<"$created")
    editor_pane_id=$(jq -r '.result.root_pane.pane_id' <<<"$created")

    herdr tab rename "$editor_tab_id" editor >/dev/null
    herdr tab create --workspace "$workspace_id" --cwd "$selected" --label commands --no-focus >/dev/null

    cmd="nvim ."

    if [ -f "$selected/.tmux-sessionizer" ]; then
        cmd="source '$selected/.tmux-sessionizer'; $cmd"
    elif [ -f "$HOME/.tmux-sessionizer" ]; then
        cmd="source '$HOME/.tmux-sessionizer'; $cmd"
    fi

    # `pane run` submits with Enter, unlike `pane send-text`.
    herdr pane run "$editor_pane_id" "$cmd" >/dev/null
    herdr tab focus "$editor_tab_id" >/dev/null
fi

herdr workspace focus "$workspace_id" >/dev/null

# Focus is a server-side operation, so outside herdr there is no attached
# client to observe it. HERDR_PANE_ID is the $TMUX equivalent.
if [[ -z $HERDR_PANE_ID ]]; then
    exec herdr
fi
