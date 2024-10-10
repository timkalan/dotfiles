autoload -Uz compinit

compinit

# aliases
alias vim="nvim"
alias vmi="nvim"
alias vi="nvim"
alias nvmi="nvim"
alias nivm="nvim"
alias nvmi="nvim"
alias py="python3"
alias python="python3"
alias sd="cd ~/Documents && cd \$(find * -type d | fzf)"
alias sdp="cd ~/Documents/20-projects && cd \$(find * -type d | fzf)"
alias sdw="cd ~/Documents/50-work/53-abelium && cd \$(find * -type d | fzf)"
alias ls="ls --color"
alias tree="tree -C"
alias ta="tmux a -t"
alias tk="tmux kill-session -t"
alias tl="tmux ls"
alias tn="tmux new -s"

# shell integration
eval "$(fzf --zsh)"

# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH=/usr/local/smlnj/bin:"$PATH"

export PATH="/usr/local/opt/node@20/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2024-03-29 09:26:21
export PATH="$PATH:/Users/timkalan/.local/bin"
