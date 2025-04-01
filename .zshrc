# --- Enable completion system ---
autoload -Uz compinit

# Set location for the compdump cache file
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

# Use cached compinit if available
if [[ -r "$ZSH_COMPDUMP" ]]; then
  compinit -C
else
  compinit
fi

# --- VCS (Git) Info ---
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b '

# --- Command timing and prompt config ---
function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  vcs_info
  if [[ -n $timer ]]; then
    local elapsed=$((SECONDS - timer))
    export RPROMPT="%F{cyan}${elapsed}s%f"
    unset timer
  fi
}

# --- Prompt ---
setopt PROMPT_SUBST
PS1='%B%F{blue}%c %F{magenta}${vcs_info_msg_0_}%f%(?.%F{green}.%F{red})➜%f%b '

# --- Aliases ---
# General
alias vim="nvim"
alias vi="nvim"
alias py="python3"
alias python="python3"
alias cl="clear"
alias ls="ls -lhF --color=auto"
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
alias sd='cd "$(find * -type d | fzf)"'
alias sdp='cd ~/projects && cd "$(find * -type d | fzf)"'
alias sdw='cd ~/projects/work && cd "$(find * -type d | fzf)"'

# --- fzf shell integration ---
eval "$(fzf --zsh)"

# --- Aerospace window picker ---
ff() {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

# --- Tmux sessionizer keybind ---
bindkey -s ^f "tmux-sessionizer.sh\n"

# --- Plugins ---
# Autosuggestions
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Vi-mode
[[ -f $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] && \
  source "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
