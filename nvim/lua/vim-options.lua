-- tab is two spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

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
