return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	opts = {},
	keys = {
		{ "<leader>td", "<cmd>Trouble todo toggle<cr>", desc = "Todo List (Trouble)" },
	},
}
