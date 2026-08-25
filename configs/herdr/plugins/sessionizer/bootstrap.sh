#!/usr/bin/env bash
# Lay out a newly created workspace as three tabs: editor, agent, commands.
# Runs from the plugin's workspace.created event hook.
set -euo pipefail

herdr=$HERDR_BIN_PATH
workspace=$HERDR_WORKSPACE_ID
root_tab=$HERDR_TAB_ID
root_pane=$HERDR_PANE_ID
cwd=$(echo "$HERDR_PLUGIN_CONTEXT_JSON" | jq -r .workspace_cwd)

# Only a fresh single-tab workspace gets bootstrapped, so a restore or a
# repeated event leaves an already-laid-out workspace alone.
if [[ $("$herdr" tab list --workspace "$workspace" | jq '.result.tabs | length') -ne 1 ]]; then
    exit 0
fi

"$herdr" tab rename "$root_tab" editor >/dev/null
"$herdr" pane run "$root_pane" nvim . >/dev/null

agent_pane=$("$herdr" tab create --workspace "$workspace" --label agent --cwd "$cwd" --no-focus \
    | jq -r .result.root_pane.pane_id)
"$herdr" pane run "$agent_pane" claude >/dev/null

"$herdr" tab create --workspace "$workspace" --label commands --cwd "$cwd" --no-focus >/dev/null
