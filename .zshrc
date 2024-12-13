# Enable completion system
autoload -Uz compinit && compinit

# Version Control System (VCS) Info
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b '

# Timing and Prompt Configuration
function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  # Load VCS branch info
  vcs_info
  
  # Show command execution time
  if [ $timer ]; then
    local timer_show=$((SECONDS - timer))
    export RPROMPT="%F{cyan}${timer_show}s%{$reset_color%}"
    unset timer
  fi
}

# Set prompt: directory_path branch ➜
setopt PROMPT_SUBST
PS1='%B%F{blue}%c %F{magenta}${vcs_info_msg_0_}%f%(?.%F{green}.%F{red})➜%f%b '

# Aliases
alias vim="nvim"
alias vi="nvim"
alias py="python3"
alias python="python3"
alias cl="clear"
alias ls="ls --color"
alias tree="tree -C"

# Git
alias lg="lazygit"
alias gst="git status"
alias gf="git fetch"
alias gp="git pull"

# Tmux shortcuts
alias ta="tmux a -t"
alias tk="tmux kill-session -t"
alias tl="tmux ls"
alias tn="tmux new -s"

# Directory navigation with fzf
alias sd="cd \$(find * -type d | fzf)"
alias sdp="cd ~/projects && cd \$(find * -type d | fzf)"
alias sdw="cd ~/projects/work && cd \$(find * -type d | fzf)"

# fzf shell integration
eval "$(fzf --zsh)"

# fzf open windows
ff() {
    aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

# PATH Configuration
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/usr/local/smlnj/bin:$PATH"
export PATH="/usr/local/opt/node@20/bin:$PATH"
export PATH="$PATH:/Users/timkalan/.local/bin"  # pipx
export PATH="$PATH:~/go/bin"
export PATH="$PATH":"$HOME/.scripts/"

# set default config location
export XDG_CONFIG_HOME="$HOME/.config"

# tmux-sessionizer
bindkey -s ^f "tmux-sessionizer.sh\n"

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# opam (OCaml Package Manager) Configuration
[[ ! -r '/Users/timkalan/.opam/opam-init/init.zsh' ]] || \
  source '/Users/timkalan/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

# Extensions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
