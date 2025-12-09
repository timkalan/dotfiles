# --- Homebrew setup (Apple Silicon) ---
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- Node Version Manager (nvm) ---

# --- OCaml Package Manager (opam) ---
if [ -r "$HOME/.opam/opam-init/init.zsh" ]; then
  source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2>&1
fi

# --- Optional: SSH agent setup (if needed) ---
# if [ -z "$SSH_AUTH_SOCK" ]; then
#   eval "$(ssh-agent -s)"
# fi

