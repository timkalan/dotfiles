#!/usr/bin/env bash
# Fuzzy-find your way to a place to work.
#   places mode   open herdr workspaces + project directories
#   branches mode branches of the repo you are in, checked out as worktrees
# Enter resolves whatever state the target is in; ctrl-n creates a new branch.
set -euo pipefail

herdr=${HERDR_BIN_PATH:-herdr}
# Roots are scanned one level deep; extras are offered as themselves. Both are
# filtered against what exists, so a root you have not created yet is inert.
roots=("$HOME/dev")
extras=("$HOME/dotfiles" "$HOME/obsidian")

label_of() { basename "$1" | tr . _ | tr : _; }

# read splits on runs of IFS whitespace, so a tab-separated row with an empty
# field in it arrives one field short and every later one lands in the wrong
# variable. @tsv has already escaped any tab inside the data, so swapping the
# delimiter for one that is not whitespace makes the empties hold their place.
FS=$'\037'
jq_rows() { jq -r "$@" | tr '\t' "$FS"; }

is_root() {
    local dir
    for dir in "${roots[@]}"; do [[ $dir == "$1" ]] && return 0; done
    return 1
}

# fd aborts on a missing search path, which would take the whole listing with it.
scan_roots() {
    local dir present=()
    for dir in "${roots[@]}"; do
        if [[ -d $dir ]]; then present+=("$dir"); fi
    done
    ((${#present[@]})) || return 0
    fd --min-depth 1 --max-depth 1 --type d --exclude worktrees . "${present[@]}"
}

repo_of_focus() { "$herdr" worktree list 2>/dev/null | jq -r '.result.source.repo_root // empty'; }

# origin/HEAD is only written by clone, so a remote added by hand has none.
# set-head asks the remote once and caches the answer in the ref.
default_branch() {
    local ref
    ref=$(git -C "$1" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null) || {
        git -C "$1" remote set-head origin --auto >/dev/null 2>&1 || true
        ref=$(git -C "$1" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null) || true
    }
    [[ -n $ref ]] || return 1
    printf '%s' "$ref"
}

# A branch cut from HEAD rather than a remote ref arrives untracked, so checking
# one out is the moment to point it at its origin counterpart. This only ever
# fills a blank: a branch aimed somewhere else on purpose, at a fork's upstream,
# keeps what it has.
track_origin() {
    git -C "$1" rev-parse --verify -q "$2@{upstream}" >/dev/null 2>&1 && return 0
    git -C "$1" rev-parse --verify -q "origin/$2" >/dev/null || return 0
    git -C "$1" branch --set-upstream-to="origin/$2" "$2" >/dev/null
}

# The path a row carries wins, so a project lists its branches and takes new
# ones without being opened first; the focused workspace is the fallback.
# herdr rejects worktree create and open from inside a linked worktree, so the
# answer is the parent checkout, not whichever one you started from.
repo_of() {
    local dir=${1:-} repo="" listing
    [[ -z $dir ]] || repo=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || true)
    [[ -n $repo ]] || repo=$(repo_of_focus)
    [[ -n $repo ]] || return 1
    listing=$("$herdr" worktree list --cwd "$repo" 2>/dev/null || printf '{}')
    printf '%s' "$listing" | jq -r --arg repo "$repo" \
        '.result.source.source_checkout_path // $repo'
}

# Hints are right-aligned against the list pane. COLUMNS is often inherited
# stale and tput honours it, so read the tty; fzf halves the width for the
# preview and spends a few columns on its pointer and scrollbar.
pane_width() {
    local cols width
    cols=$({ { stty size </dev/tty; } 2>/dev/null || echo "0 0"; } | cut -d' ' -f2)
    ((cols > 20)) || cols=120
    width=$((cols - cols / 2 - 4))
    ((width < 32)) && width=32
    printf '%s' "$width"
}

# mark name hint kind value path
emit() {
    local gap
    if [[ -n $3 ]]; then
        gap=$((WIDTH - 2 - ${#2} - ${#3}))
        ((gap < 2)) && gap=2
        printf '%s %s%*s\033[2m%s\033[0m\t%s\t%s\t%s\n' "$1" "$2" "$gap" "" "$3" "$4" "$5" "$6"
    else
        printf '%s %s\t%s\t%s\t%s\n' "$1" "$2" "$4" "$5" "$6"
    fi
}

list_places() {
    local id label repo checkout path linked name hint panes
    local -A open_path=() open_name=()
    # A plain workspace has no worktree record, so its first pane's cwd is the
    # only path it has. Rows without one strand ctrl-b and the preview. Naming
    # still goes by the checkout, which is the workspace's own idea of where it
    # is rather than wherever a shell in it has wandered off to.
    panes=$("$herdr" pane list)
    while IFS=$FS read -r id label repo checkout path linked; do
        if [[ $linked == true ]]; then
            name=$label
            hint="$repo worktree"
        elif [[ -n $checkout ]]; then
            name=$(basename "$checkout")
            hint="workspace"
        else
            name=$label
            hint="workspace"
        fi
        emit "●" "$name" "$hint" ws "$id" "$path"
        open_name[$name]=1
        open_name[$label]=1
        [[ -z $path ]] || open_path[$path]=1
    done < <("$herdr" workspace list | jq_rows --argjson panes "$panes" '
        ($panes.result.panes | group_by(.workspace_id)
         | map({key: .[0].workspace_id, value: .[0].cwd}) | from_entries) as $cwd
        | .result.workspaces[]
        | [.workspace_id, .label, (.worktree.repo_name // ""),
           (.worktree.checkout_path // ""),
           (.worktree.checkout_path // $cwd[.workspace_id] // ""),
           ((.worktree.is_linked_worktree // false) | tostring)] | @tsv')

    local dir parent
    while read -r dir; do
        dir=${dir%/}
        [[ -d $dir ]] || continue
        name=$(label_of "$dir")
        # A project already open as a workspace is offered there, not twice.
        [[ -v open_path[$dir] || -v open_name[$name] ]] && continue
        parent=$(dirname "$dir")
        # bash 5.2+ tilde-expands an unescaped ~ in the replacement, which would
        # put $HOME straight back and leave the hint unshortened.
        if is_root "$parent"; then hint=""; else hint="${parent/#$HOME/\~}"; fi
        emit " " "$name" "$hint" dir "$dir" "$dir"
    done < <(
        scan_roots
        printf '%s\n' "${extras[@]}"
    )
}

list_branches() {
    local repo default worktrees mark branch hint
    if ! repo=$(repo_of "${1:-}"); then
        emit " " "not a git repo" "pick a repo or focus one first" none "" ""
        return 0
    fi
    # ctrl-n branches off this same repo, and a list filtered down to no rows
    # has none left to carry it, so leave it somewhere the keybind can read.
    [[ -z ${REPO_HINT:-} ]] || printf '%s' "$repo" >"$REPO_HINT"
    git -C "$repo" fetch -q --prune 2>/dev/null || true
    # Not knowing the default only costs us one redundant row, so listing goes on.
    default=$(default_branch "$repo") || default=""
    worktrees=$("$herdr" worktree list --cwd "$repo" 2>/dev/null || printf '{}')

    # A local branch and its origin counterpart are one row, and for-each-ref is
    # sorted newest first, so the first sighting of a name is the one to keep.
    # ● already open as a workspace, ◦ checkout on disk, blank not checked out.
    while IFS=$FS read -r mark branch hint; do
        emit "$mark" "$branch" "$hint" br "$branch" "$repo"
    done < <(git -C "$repo" for-each-ref --sort=-committerdate \
        --format='%(refname:short)|%(committerdate:relative)|%(authorname)' \
        refs/remotes/origin refs/heads |
        jq_rows -R -s --argjson wt "$worktrees" --arg default "${default#origin/}" '
        (($wt.result.worktrees // []) | INDEX(.branch)) as $checkouts
        | [ split("\n")[] | select(length > 0) | split("|")
            | {ref: .[0], branch: (.[0] | ltrimstr("origin/")),
               when: (.[1] // ""), who: (.[2] // "")} ]
        # refs/remotes/origin/HEAD shortens to a bare "origin", not "origin/HEAD".
        | map(select(.ref != "origin" and .branch != "HEAD" and .branch != $default))
        | reduce .[] as $r ({seen: {}, out: []};
            if .seen[$r.branch] then . else (.seen[$r.branch] = true | .out += [$r]) end)
        | .out[]
        | [ ($checkouts[.branch]
             | if . == null then " " elif .open_workspace_id then "●" else "◦" end),
            .branch,
            "\(.when) · \(.who | split(" ")[0] // "")" ] | @tsv')
}

# Urgency order: blocked wants you now, done finished while you looked away,
# idle is parked, working is busy. Ties go to whichever moved last, and the
# agent you are already sitting in sinks to the end of its group.
# Marks follow herdr's sidebar: filled is hot, hollow is parked. The workspace
# always holds the left column so it never trades places with the context on
# the right, which is the agent's title, or its kind when the title is stock.
list_agents() {
    local workspaces pane status name hint dir mark
    workspaces=$("$herdr" workspace list)
    while IFS=$FS read -r pane status name hint dir; do
        case $status in
        blocked) mark="!" ;;
        done) mark="✓" ;;
        working) mark="●" ;;
        idle) mark="◦" ;;
        *) mark=" " ;;
        esac
        emit "$mark" "$name" "$hint" agent "$pane" "$dir"
    done < <("$herdr" agent list | jq_rows --argjson ws "$workspaces" '
        ($ws.result.workspaces | INDEX(.workspace_id)) as $labels
        | .result.agents
        | sort_by({blocked:0, done:1, idle:2, working:3}[.agent_status] // 4,
                  .focused, -.state_change_seq)
        | .[]
        | ($labels[.workspace_id].label // (.cwd | split("/") | last)) as $place
        | (.terminal_title_stripped // "") as $title
        | ($title | ascii_downcase) as $lower
        | (if $lower == "" or $lower == .agent or $lower == (.agent + " code")
           then .agent else $title end) as $context
        | [.pane_id, .agent_status, $place, $context, .cwd] | @tsv')
}

case ${1:-} in
--preview)
    IFS=$'\t' read -r _ kind value path <<<"$2"
    case $kind in
    br) exec git -C "$path" log --oneline --decorate -20 \
        "$(git -C "$path" rev-parse --verify -q "$value" >/dev/null &&
            printf '%s' "$value" || printf 'origin/%s' "$value")" ;;
    # read tails the pane, whose last lines are the agent's own input
    # chrome, so ask for a screenful past it and drop the rules. Lines
    # come padded to that pane's width, way past this window.
    agent) "$herdr" agent read "$value" --source visible \
        --lines $((${FZF_PREVIEW_LINES:-24} + 8)) --format text |
        awk 'index($0, "───") == 1 { next }
                          { sub(/[ \t]+$/, "")
                            # Text the pane right-aligned sits out past this
                            # window, so close interior gaps but keep indents.
                            match($0, /^ */); pad = substr($0, 1, RLENGTH)
                            # Past six, an indent is alignment, not structure.
                            if (RLENGTH > 6) pad = "  "
                            rest = substr($0, RLENGTH + 1)
                            gsub(/ {8,}/, "  ", rest); $0 = pad rest }
                          $0 == "" { if (blank++) next } $0 != "" { blank = 0 } 1' ;;
    none) exit 0 ;;
    *) [[ -n $path ]] && exec "$HOME/.scripts/fzf-preview.sh" "$path" ;;
    esac
    exit 0
    ;;
--list)
    WIDTH=$(pane_width)
    # Only a branch listing pins a repo; after any other one ctrl-n is back
    # to the selected row and then the focused workspace.
    [[ -z ${REPO_HINT:-} ]] || : >"$REPO_HINT"
    case $2 in
    places) list_places ;;
    branches) list_branches "${3:-}" ;;
    agents) list_agents ;;
    esac
    exit 0
    ;;
esac

# A directory argument skips the picker entirely.
if [[ $# -eq 1 ]]; then
    "$herdr" workspace create --cwd "$1" --label "$(label_of "$1")" --focus >/dev/null
    exit 0
fi

# Listings are read from the top and are tabular, so they neither wrap nor
# scroll. An agent's tail is prose whose newest line is the point of looking.
LIST_WINDOW=right,50%
PROSE_WINDOW=right,50%,wrap-word,follow

# Where each listing leaves the repo it resolved, for ctrl-n to pick up. herdr
# hands a plugin its own state dir; a run straight from the CLI has none.
REPO_HINT=${HERDR_PLUGIN_STATE_DIR:-${TMPDIR:-/tmp}}/sessionizer-repo
mkdir -p "${REPO_HINT%/*}" && export REPO_HINT

WIDTH=$(pane_width)
out=$(list_places | fzf --ansi --layout=reverse --delimiter=$'\t' --with-nth=1 --nth=1 \
    --prompt='> ' --print-query --expect=ctrl-n \
    --header='places · ctrl-b branches of selection · ctrl-a agents' \
    --bind "ctrl-b:reload($0 --list branches {4})+change-header(branches · ctrl-p places · ctrl-n new branch)+change-preview-window($LIST_WINDOW)" \
    --bind "ctrl-a:reload($0 --list agents)+change-header(agents · ctrl-p places · ctrl-b branches)+change-preview-window($PROSE_WINDOW)" \
    --bind "ctrl-p:reload($0 --list places)+change-header(places · ctrl-b branches · ctrl-a agents)+change-preview-window($LIST_WINDOW)" \
    --preview "$0 --preview {}" --preview-window="$LIST_WINDOW") || true

query=$(sed -n 1p <<<"$out")
key=$(sed -n 2p <<<"$out")
selected=$(sed -n 3p <<<"$out")

# ctrl-n: branch the typed name off the default branch of whichever repo the
# list is showing, which is the one ctrl-b resolved. Typing a name nobody has
# yet leaves no row selected, so the listing's own answer is the fallback.
if [[ $key == ctrl-n ]]; then
    [[ -n $query ]] || exit 0
    IFS=$'\t' read -r _ _ _ path _ <<<"$selected"
    if ! repo=$(repo_of "${path:-$(cat "$REPO_HINT")}"); then
        "$herdr" notification show "No repo" \
            --body "pick a repo or focus one first" --sound request
        exit 1
    fi
    # Here the default branch is the branch point, so guessing it would be wrong
    # in a way you only notice after the diff is built on the wrong base.
    if ! base=$(default_branch "$repo"); then
        "$herdr" notification show "No default branch" \
            --body "origin/HEAD is unset in $repo" --sound request
        exit 1
    fi
    "$herdr" worktree create --cwd "$repo" --branch "$query" \
        --base "$base" --focus >/dev/null
    # git tracks the base it was given, which would make pull merge the base in
    # and push refuse the name mismatch. Untracked, the first push wires it up.
    if git -C "$repo" rev-parse -q --verify "$query@{upstream}" >/dev/null 2>&1; then
        git -C "$repo" branch --unset-upstream "$query"
    fi
    "$herdr" notification show "Branch created" --body "$query off $base" --sound done
    exit 0
fi

[[ -n $selected ]] || exit 0
IFS=$'\t' read -r _ kind value path _ <<<"$selected"

case $kind in
ws) "$herdr" workspace focus "$value" >/dev/null ;;
agent) "$herdr" agent focus "$value" >/dev/null ;;
dir) "$herdr" workspace create --cwd "$value" --label "$(label_of "$value")" --focus >/dev/null ;;
br)
    # Four states, resolved from herdr's own worktree registry.
    IFS=$FS read -r workspace checkout < <("$herdr" worktree list --cwd "$path" |
        jq_rows --arg b "$value" '(.result.worktrees // []) | map(select(.branch == $b))
            | .[0] // {} | [.open_workspace_id // "", .path // ""] | @tsv')
    if [[ -n $workspace ]]; then
        "$herdr" workspace focus "$workspace" >/dev/null
    elif [[ -n $checkout ]]; then
        "$herdr" worktree open --cwd "$path" --branch "$value" --focus >/dev/null
    else
        # A branch that exists locally is checked out as it stands; one that only
        # exists on the remote is cut from there. Either way the checkout is new,
        # so it is the moment to give the branch an upstream.
        if git -C "$path" rev-parse --verify -q "$value" >/dev/null; then
            "$herdr" worktree create --cwd "$path" --branch "$value" --focus >/dev/null
        else
            "$herdr" worktree create --cwd "$path" --branch "$value" \
                --base "origin/$value" --focus >/dev/null
        fi
        track_origin "$path" "$value"
    fi
    ;;
esac
