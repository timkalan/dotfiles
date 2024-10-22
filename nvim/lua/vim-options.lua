-- tab is four spaces
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- column line
-- vim.opt.colorcolumn = "120"

-- save undo history
vim.opt.undofile = true

-- indentation
vim.opt.autoindent = true
vim.opt.smartindent = true

-- clipboard
vim.o.clipboard = "unnamedplus"

-- persistent gutter
vim.opt.signcolumn = "yes"

-- smarter searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

-- opening splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- leader
vim.g.mapleader = " "

-- centering
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- quickfix bindings
vim.keymap.set("n", "<leader>co", "<cmd>copen<CR>")
vim.keymap.set("n", "<leader>cc", "<cmd>ccl<CR>")
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz")
