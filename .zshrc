autoload -Uz compinit
compinit

# add repo info
autoload -Uz vcs_info

# branch info
zstyle ':vcs_info:git:*' formats '%b '

# add command execution time
function preexec() {
  timer=${timer:-$SECONDS}
}

precmd() {
  # load branch info
  vcs_info

  # show time info
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    export RPROMPT="%F{cyan}${timer_show}s %{$reset_color%}"
    unset timer
  fi
}

# prompt: directory_path branch 
setopt PROMPT_SUBST
PS1='%B%F{blue}%c %F{magenta}${vcs_info_msg_0_}%f%(?.%F{green}.%F{red})➜%f%b '

# aliases
alias vim="nvim"
alias vmi="nvim"
alias vi="nvim"
alias nvmi="nvim"
alias nivm="nvim"
alias nvmi="nvim"

alias py="python3"
alias python="python3"

alias sd="cd \$(find * -type d | fzf)"
alias sdp="cd ~/projects && cd \$(find * -type d | fzf)"
alias sdw="cd ~/projects/work && cd \$(find * -type d | fzf)"

alias ls="ls --color"
alias tree="tree -C"

alias ta="tmux a -t"
alias tk="tmux kill-session -t"
alias tl="tmux ls"
alias tn="tmux new -s"

alias cl="clear"

# shell integration
eval "$(fzf --zsh)"

export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH=/usr/local/smlnj/bin:"$PATH"
export PATH="/usr/local/opt/node@20/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2024-03-29 09:26:21
export PATH="$PATH:/Users/timkalan/.local/bin"

export PATH=$PATH:~/go/bin

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/timkalan/.opam/opam-init/init.zsh' ]] || source '/Users/timkalan/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# Extensions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

