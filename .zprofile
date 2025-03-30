# --- Homebrew setup (Apple Silicon) ---
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- Node Version Manager (nvm) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# --- OCaml Package Manager (opam) ---
if [ -r "$HOME/.opam/opam-init/init.zsh" ]; then
  source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2>&1
fi

# --- Optional: SSH agent setup (if needed) ---
# if [ -z "$SSH_AUTH_SOCK" ]; then
#   eval "$(ssh-agent -s)"
# fi

