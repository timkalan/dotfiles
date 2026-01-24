return {
	"folke/trouble.nvim",
	opts = {},
	specs = {
		"folke/snacks.nvim",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts or {}, {
				picker = {
					actions = require("trouble.sources.snacks").actions,
					win = {
						input = {
							keys = {
								["<c-t>"] = {
									"trouble_open",
									mode = { "n", "i" },
								},
							},
						},
					},
				},
			})
		end,
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>tt",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Toggle Trouble (Project Errors)",
		},
		{
			"<leader>tf",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Toggle Trouble (Current Buffer)",
		},

		{
			"<leader>ts",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (File Outline)",
		},
		{
			"<leader>tr",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP References / Definitions",
		},

		{
			"<leader>tl",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List",
		},
		{
			"<leader>tq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List",
		},
	},
}
