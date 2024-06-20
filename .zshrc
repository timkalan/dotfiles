autoload -Uz compinit

compinit

# aliases
alias vim="nvim"
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

# shell integration
eval "$(fzf --zsh)"

# opam configuration
[[ ! -r /Users/timkalan/.opam/opam-init/init.zsh ]] || source /Users/timkalan/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH=/usr/local/smlnj/bin:"$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/timkalan/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/timkalan/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/timkalan/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/timkalan/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/usr/local/opt/node@20/bin:$PATH"


# Load Angular CLI autocompletion.
source <(ng completion script)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Created by `pipx` on 2024-03-29 09:26:21
export PATH="$PATH:/Users/timkalan/.local/bin"
