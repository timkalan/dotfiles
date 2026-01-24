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
		{ "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
	},
	build = ":TSUpdate",
	main = "nvim-treesitter",
	opts = {
		ensure_installed = { "go", "typescript", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<M-Up>",
				scope_incremental = "<M-Right>",
				node_incremental = "<M-Up>",
				node_decremental = "<M-Down>",
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter").setup(opts)
		vim.api.nvim_set_hl(0, "TreesitterContext", { link = "ColorColumn" })
	end,
}
