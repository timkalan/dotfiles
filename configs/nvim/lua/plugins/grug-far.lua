return {
	"MagicDuck/grug-far.nvim",
	opts = {},
	keys = {
		{
			"<leader>rr",
			function()
				require("grug-far").open()
			end,
			desc = "[r]eplace: [r]un (project)",
		},
		{
			"<leader>rr",
			function()
				require("grug-far").with_visual_selection()
			end,
			mode = "x",
			desc = "[r]eplace: [r]un (selection)",
		},
		{
			"<leader>rw",
			function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end,
			desc = "[r]eplace [w]ord under cursor",
		},
		{
			"<leader>rf",
			function()
				require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
			end,
			desc = "[r]eplace in current [f]ile",
		},
		{
			"<leader>rb",
			function()
				require("grug-far").open({ prefills = { paths = "<buflist>" } })
			end,
			desc = "[r]eplace in open [b]uffers",
		},
		{
			"<leader>ri",
			function()
				require("grug-far").with_visual_selection({ visualSelectionUsage = "operate-within-range" })
			end,
			mode = "x",
			desc = "[r]eplace with[i]n selection",
		},
	},
}
