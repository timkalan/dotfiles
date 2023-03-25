require("timkalan.plugins-setup")
require("timkalan.core.options")
require("timkalan.core.keymaps")
require("timkalan.core.colorscheme")
require("timkalan.plugins.comment")
require("timkalan.plugins.nvim-tree")
require("timkalan.plugins.lualine")
require("timkalan.plugins.telescope")
require("timkalan.plugins.nvim-cmp")
require("timkalan.plugins.lsp.mason")
require("timkalan.plugins.lsp.lspsaga")
require("timkalan.plugins.lsp.lspconfig")
require("timkalan.plugins.autopairs")
require("timkalan.plugins.treesitter")
require("timkalan.plugins.gitsigns")
require("timkalan.plugins.lsp.null-ls")

local notify = vim.notify
vim.notify = function(msg, ...)
    if msg:match("warning: multiple different client offset_encodings") then
        return
    end

    notify(msg, ...)
end
