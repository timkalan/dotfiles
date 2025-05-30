# --- Enable completion system ---
autoload -Uz compinit
# Check if the completion cache file exists and is newer than .zshrc
# or if there are more than a certain number of completion files.
# This avoids running compinit on every shell start if nothing changed.
if [ -n "$ZDOTDIR/.zcompdump" ] && [ "$ZDOTDIR/.zcompdump" -nt "$ZDOTDIR/.zshrc" ]; then
    compinit -i -C # -C to use cache, -i for insecure directories (if any)
else
    compinit -i -d "$ZDOTDIR/.zcompdump" # -d to specify dump file
fi

# --- Aliases ---
# General
alias vim="nvim"
alias vi="nvim"
alias py="python3"
alias python="python3"
alias cl="clear"
alias ls="eza -lahF --git --icons"
alias tree="tree -C"

# Git
alias lg="lazygit"
alias gst="git status"
alias gf="git fetch"
alias gp="git pull"

# Tmux
alias ta="tmux a -t"
alias tk="tmux kill-session -t"
alias tl="tmux ls"
alias tn="tmux new -s"

# Directory navigation with fzf
# If you have fd installed
alias sd='cd "$(fd . --type d | fzf)"'
alias sdp='cd ~/projects && cd "$(fd . --type d | fzf)"'
alias sdw='cd ~/projects/work && cd "$(fd . --type d | fzf)"'

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt BANG_HIST              # Treat ! as a history command
setopt EXTENDED_HISTORY       # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded.
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # When searching history, don't show duplicates.
setopt HIST_IGNORE_SPACE      # Don't record commands starting with a space.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
setopt HIST_VERIFY            # Don't execute history expansion commands immediately.

# --- Options ---
setopt AUTO_CD              # If a command is issued that is the name of a directory, cd to it.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Don’t push multiple copies of the same directory onto the stack.
setopt CORRECT              # Auto correct typos in commands.
# setopt CORRECT_ALL        # Auto correct all arguments. (Can be aggressive)
setopt GLOB_DOTS            # Include hidden files in globbing.
setopt NUMERIC_GLOB_SORT    # Sort filenames numerically when globbing.
setopt RC_EXPAND_PARAM      # Array expansion with parameters.
unsetopt BEEP               # No more beeps!
# For a safer rm, uncomment one of these, but aliases are often preferred
# setopt RM_STAR_SILENT     # Do not query before `rm *` or `rm path/*`.
# setopt RM_STAR_WAIT       # Wait 10 seconds before `rm *` or `rm path/*`.

# Better completion behavior
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt AUTO_MENU            # Automatically use menu completion.
setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.

# --- Plugins ---
# Prompt
eval "$(starship init zsh)"

# Autosuggestions
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Vi-mode
export ZVM_INIT_MODE=sourcing
[[ -f $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] && \
  source "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# Syntax highlighting
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Some things depend on the plugins to run, so they come after

# --- fzf shell integration ---
eval "$(fzf --zsh)"

# --- Tmux sessionizer keybind ---
# define a widget that runs your script
tmux_sessionizer_widget() {
  zle reset-prompt   # redraw so prompt looks right after returning
  tmux-sessionizer.sh
}
zle -N tmux_sessionizer_widget

# bind it in both modes if you like
bindkey -M viins '^F' tmux_sessionizer_widget
bindkey -M vicmd '^F' tmux_sessionizer_widget
