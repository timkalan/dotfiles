# --- Homebrew setup (Apple Silicon) ---
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- OCaml Package Manager (opam) ---
if [ -r "$HOME/.opam/opam-init/init.zsh" ]; then
  source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2>&1
fi

