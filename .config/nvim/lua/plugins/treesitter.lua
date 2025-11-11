return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-context", opts = { enable = true } },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
	},
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			sync_install = false,
			ensure_installed = {},
			ignore_install = {},
			modules = {},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<M-Up>",
					scope_incremental = "<M-Right>",
					node_incremental = "<M-Up>",
					node_decremental = "<M-Down>",
				},
			},
		})
		vim.api.nvim_set_hl(0, "TreesitterContext", { link = "ColorColumn" })
	end,
}
