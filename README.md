# dotfiles

This repo contains all the dotfiles to set up my development experience on a new machine.

## Installation

Clone this repository from your home folder, so you get a `~/dotfiles/` folder. `cd` into it and run

```bash
stow .
```

To create the symlinks from this folder to the home folder. I am also now using a `.env` file with
an API key for OpenRouter. You can make it in the root of this project and add a `OPENROUTER_API_KEY`,
field to it (and also stow it!).

## Tools
- `aerospace` (window manager)
- `ghostty` (terminal)
- `wezterm` (terminal)
- `zsh` (shell)
- `tmux` (terminal multiplexer)
- `neovim` (editor)
- `starship` (prompt)

## Requirements (wip)
- `homebrew` (package manager)
- `fzf` (fuzzy finder)
- `stow`

To find a lot of what requirements are missing, run `:checkhealth` in `nvim`.
