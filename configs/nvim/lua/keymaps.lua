-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- centering
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "half page up (centered)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "next search match (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "prev search match (centered)" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "jumplist forward (centered)" })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "jumplist back (centered)" })

-- quickfix bindings
vim.keymap.set("n", "<leader>co", "<cmd>copen<CR>", { desc = "qui[c]kfix [o]pen" })
vim.keymap.set("n", "<leader>cc", "<cmd>ccl<CR>", { desc = "qui[c]kfix [c]lose" })
vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz", { desc = "qui[c]kfix [n]ext" })
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz", { desc = "qui[c]kfix [p]rev" })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "clear search highlight" })

-- open splits with leader
vim.keymap.set("n", "<leader>/", "<C-w>v", { desc = "split vertical" })
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "split horizontal" })

-- option + backspace deletes word
vim.keymap.set("i", "<M-BS>", "<C-w>", { desc = "delete word back" })

-- tmux sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer.sh<CR>", { desc = "tmux sessionizer" })

-- move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selection up" })

-- diagnostics
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "show diagnostic [e]rror float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "diagnostic [q]uickfix list" })
