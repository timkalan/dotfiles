-- tab is two spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- indentation
vim.opt.autoindent = true
vim.opt.smartindent = true

-- clipboard
vim.o.clipboard = "unnamedplus"

-- persistent gutter
vim.opt.signcolumn = "yes"

-- leader
vim.g.mapleader = " "

-- smarter searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

-- centering
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- save undo history
vim.opt.undofile = true
