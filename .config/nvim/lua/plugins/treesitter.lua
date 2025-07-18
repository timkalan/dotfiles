return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-context", opts = { enable = true } },
	},
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = {
				enable = true,
			},
		})
		vim.api.nvim_set_hl(0, "TreesitterContext", { link = "ColorColumn" })
	end,
}
