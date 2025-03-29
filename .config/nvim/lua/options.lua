-- tab is four spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- some file types prefer two spaces
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "javascript", "javascriptreact", "typescriptreact", "json", "yaml", "html", "css" },
	callback = function()
		vim.bo.shiftwidth = 2
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
	end,
})

-- indentation
vim.opt.autoindent = true
vim.opt.smartindent = true

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- save undo history
vim.opt.undofile = true

-- no swap
vim.swapfile = false

-- clipboard
vim.o.clipboard = "unnamedplus"

-- persistent gutter
vim.opt.signcolumn = "yes"

-- smarter searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- opening splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- better colors
vim.opt.termguicolors = true

-- faster updatetime (default 4000)
vim.opt.updatetime = 50

-- scrolloff
-- vim.opt.scrolloff = 8

-- line at 100 characters
vim.opt.colorcolumn = "100"

-- more file names
vim.opt.isfname:append("@-@")

-- no line wrapping
vim.opt.wrap = false

-- highlight cursor line
vim.opt.cursorline = true

-- show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "▎ ", trail = "·", nbsp = "␣" }

-- mouse support
vim.opt.mouse = "a"

-- rounded window borders
vim.o.winborder = "rounded"
