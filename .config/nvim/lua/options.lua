-- tab is four spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- indentation
vim.o.autoindent = true
vim.o.smartindent = true

-- line numbers
vim.o.number = true
vim.o.relativenumber = true

-- save undo history
vim.o.undofile = true

-- no swap
vim.swapfile = false

-- clipboard
vim.o.clipboard = "unnamedplus"

-- persistent gutter
vim.o.signcolumn = "yes"

-- smarter searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- opening splits
vim.o.splitright = true
vim.o.splitbelow = true

-- better colors
vim.o.termguicolors = true

-- faster updatetime (default 4000)
vim.o.updatetime = 50

-- scrolloff
-- vim.o.scrolloff = 8

-- line at 100 characters
vim.o.colorcolumn = "100"

-- no line wrapping
vim.o.wrap = false

-- highlight cursor line
vim.o.cursorline = true

-- mouse support
vim.o.mouse = "a"

-- rounded window borders
vim.o.winborder = "rounded"

-- show some extra whitespace
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- word wrap
vim.o.wrap = true
vim.o.linebreak = true
vim.opt.showbreak = "↪ "
vim.o.breakindent = true
