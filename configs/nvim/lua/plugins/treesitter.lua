return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
				enable = true,
				max_lines = 10,
				trim_scope = "outer",
			},
		},
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
	},
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			sync_install = false,
			ensure_installed = { "go", "typescript", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
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
			textobjects = { enable = true },
		})
		vim.api.nvim_set_hl(0, "TreesitterContext", { link = "ColorColumn" })
	end,
}
