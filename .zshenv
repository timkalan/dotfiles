. "$HOME/.cargo/env"

# --- Set XDG Base Directory ---
export XDG_CONFIG_HOME="$HOME/.config"

# --- General environment variables ---
export GOPATH="$HOME/go"
export GOPRIVATE="github.com/zerodays,github.com/llamajet"
export EDITOR=nvim

# --- Clean PATH setup ---
# Define a helper to append to PATH only if the directory exists
path_prepend() {
  [ -d "$1" ] && PATH="$1:$PATH"
}

path_append() {
  [ -d "$1" ] && PATH="$PATH:$1"
}

# Reset PATH to something minimal
PATH="/usr/bin:/bin:/usr/sbin:/sbin"

# Prepend/append custom paths
path_prepend "$HOME/.cargo/bin"
path_prepend "/opt/homebrew/bin"
path_prepend "/opt/homebrew/sbin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/go/bin"
path_prepend "$HOME/.scripts"
path_prepend "/usr/local/opt/llvm/bin"
path_prepend "/usr/local/smlnj/bin"
path_prepend "/usr/local/opt/node@20/bin"
path_prepend "/opt/homebrew/opt/libpq/bin"
path_append "$GOPATH/bin"
path_append "/opt/local/bin"

export PATH
