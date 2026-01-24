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
alias v="nvim"
alias py="python3"
alias python="python3"
alias cl="clear"
alias ls="eza -lahF --git --icons"
alias tree="tree -C"

# Git
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

alias finit='rm -rf .envrc .direnv && echo "use flake" > .envrc && direnv allow'

# Zoxide


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
if (( $+commands[brew] )); then
  BREW_PREFIX=$(brew --prefix)
else
  BREW_PREFIX="/opt/homebrew"
fi

# Autosuggestions
[[ -f $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
[[ -f $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Vi-mode
export ZVM_INIT_MODE=sourcing
[[ -f $BREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] && \
  source "$BREW_PREFIX/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"

# Some things depend on the plugins to run, so they come after

# --- direnv ---
eval "$(direnv hook zsh)"

# --- fzf shell integration ---
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS="--preview '$HOME/.scripts/fzf-preview.sh {}'"
bindkey '^g' fzf-cd-widget

gsf() {
  local branch=$(git branch -a | sed 's/^\*/ /' | fzf --preview "git log --oneline -n 10 --graph --color=always $(echo {} | sed 's/remotes\/origin\///' | sed 's/ //g')")
  if [[ -n "$branch" ]]; then
    git switch $(echo "$branch" | sed 's/remotes\/origin\///' | sed 's/ //g')
  fi
}

alias glf='git log --pretty=oneline --graph --color=always | fzf --preview "git show --color=always {+1}"'

fkill() {
  local pid=$(ps -ef | sed 1d | fzf -m --preview 'echo {}' | awk '{print $2}')
  if [[ -n "$pid" ]]; then
    echo "$pid" | xargs kill -9
  fi
}

# --- shai shell integration ---
eval "$(shai --zsh-init)"

# --- zoxide ---
eval "$(zoxide init zsh --cmd cd)"

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  nvm "$@"
}

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

# Prompt
eval "$(starship init zsh)"
