return {
	"nvim-mini/mini.nvim",
	config = function()
		require("mini.icons").setup()
		-- lualine only knows nvim-web-devicons; other consumers prefer MiniIcons directly
		MiniIcons.mock_nvim_web_devicons()

		local gen_spec = require("mini.ai").gen_spec
		require("mini.ai").setup({
			n_lines = 500,
			custom_textobjects = {
				f = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				o = gen_spec.treesitter({
					a = { "@conditional.outer", "@loop.outer" },
					i = { "@conditional.inner", "@loop.inner" },
				}),
				c = gen_spec.function_call({ name_pattern = "[%w_]" }),
			},
		})
		require("mini.surround").setup()
		require("mini.splitjoin").setup({
			mappings = { toggle = "<leader>m", split = "<leader>s", join = "<leader>j" },
		})
	end,
}
