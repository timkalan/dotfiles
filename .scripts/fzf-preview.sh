#!/bin/bash

# $1 is the item fzf has passed to the script
INPUT="$1"

# Helper to check if a command exists
has() {
    command -v "$1" >/dev/null 2>&1
}

# Check if the input is a file
if [ -f "$INPUT" ]; then
    # Use bat for file previews if available
    if has bat; then
        bat --color=always --style=numbers --line-range=:500 "$INPUT"
    else
        # Fallback to cat
        cat "$INPUT" | head -n 500
    fi
# Check if the input is a directory
elif [ -d "$INPUT" ]; then
    # Use 'eza' for directory listing if available
    if has eza; then
        eza -lahF --git --icons --color=always "$INPUT"
    else
        # Fallback to standard ls
        ls -lahF "$INPUT"
    fi
else
    # It's not a file or directory (e.g., history, session name)
    if has bat; then
        echo "$INPUT" | bat -p --color=always --language=sh
    else
        echo "$INPUT"
    fi
fi
