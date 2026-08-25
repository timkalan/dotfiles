#!/usr/bin/env bash
# Remove the focused worktree's checkout, then delete its branch.
# herdr never deletes branches itself, so the branch step is ours.
set -euo pipefail

herdr=$HERDR_BIN_PATH
workspace=$HERDR_WORKSPACE_ID

info=$("$herdr" worktree list --workspace "$workspace")
repo_root=$(echo "$info" | jq -r .result.source.repo_root)
branch=$(echo "$info" | jq -r --arg ws "$workspace" \
    '.result.worktrees[] | select(.open_workspace_id == $ws and .is_linked_worktree) | .branch')

# The main checkout also reports open_workspace_id, so without the
# is_linked_worktree filter this would offer to delete the primary branch.
if [[ -z $branch ]]; then
    "$herdr" notification show "Not a worktree" --body "workspace $workspace is the main checkout" --sound request
    exit 1
fi

"$herdr" worktree remove --workspace "$workspace" >/dev/null

if git -C "$repo_root" branch -d "$branch" 2>/dev/null; then
    "$herdr" notification show "Worktree removed" --body "checkout and branch $branch deleted" --sound done
else
    "$herdr" notification show "Branch kept" --body "checkout gone; $branch is not merged, delete it by hand" --sound request
fi
