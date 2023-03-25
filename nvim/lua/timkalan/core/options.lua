-- line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- tabs and indents
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- line wrapping
vim.opt.wrap = false

-- scroll
vim.opt.scrolloff = 8

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- appearance
vim.opt.signcolumn = "yes"
vim.opt.background = "dark"

-- sounds
-- vim.opt.noerrorbells = true
vim.opt.belloff = "all"

-- backspace
vim.opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- keyword behaviour
vim.opt.iskeyword:append("-")
