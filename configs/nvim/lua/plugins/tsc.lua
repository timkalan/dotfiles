return {
	"dmmulroy/tsc.nvim",
	keys = {
		{ "<leader>tc", "<cmd>TSC<cr>", desc = "Type Check (Full Project)" },
	},
	config = function()
		require("tsc").setup({
			use_trouble_qflist = true,
			run_as_monorepo = true,
		})
	end,
}
