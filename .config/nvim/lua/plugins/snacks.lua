return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		image = {
			enabled = true,
			math = { enabled = false },
		},
		indent = {
			enabled = true,
			animate = { enabled = false },
		},
		lazygit = {
			enabled = true,
			configure = true,
		},
		picker = {
			enabled = true,
			ui_select = true,
		},
		explorer = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		-- Lazygit
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "[L]azy[G]it",
		},

		-- Picker
		{
			"<leader>ff",
			function()
				Snacks.picker.files({
					hidden = true,
				})
			end,
			desc = "[F]ind [F]iles",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "[F]ind [R]ecent",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep({ hidden = true })
			end,
			desc = "[F]ind [G]rep",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep_word({ hidden = true })
			end,
			desc = "[F]ind [W]ord",
		},
		{
			"<leader>f/",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "[/] Fuzzily search open buffers",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "[F]ind [B]uffers",
		},
		{
			"<leader>fd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "[F]ind [D]iagnostics",
		},
		{
			"<leader>fu",
			function()
				Snacks.picker.undo()
			end,
			desc = "[F]ind [U]ndo",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "[F]ind [K]eymaps",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.resume()
			end,
			desc = "[F]ind [C]ontinue",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "[F]ind [H]elp",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>fP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub Pull Requests (all)",
		},
		{
			"<leader>fe",
			function()
				Snacks.explorer()
			end,
			desc = "[F]ile [E]xplorer",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},
	},
	vim.api.nvim_set_hl(0, "SnacksPickerDir", { link = "Text" }),
	vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Text" }),
	vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "Comment" }),
	vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Special" }),
}
