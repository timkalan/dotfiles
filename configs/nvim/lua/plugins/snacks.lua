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
			matcher = {
				frecency = true,
				cwd_bonus = true,
			},
			formatters = {
				file = {
					filename_first = true,
				},
			},
		},
		explorer = { enabled = true },
		words = { enabled = true },
		bigfile = { enabled = true },
		quickfile = { enabled = true },
	},
	keys = {
		-- Lazygit
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "[l]azy[g]it",
		},

		-- Picker
		{
			"<leader>ff",
			function()
				Snacks.picker.files({
					hidden = true,
				})
			end,
			desc = "[f]ind [f]iles",
		},
		{
			"<leader>fs",
			function()
				Snacks.picker.smart()
			end,
			desc = "[f]ind [s]mart (frecency)",
		},
		{
			"<leader>fC",
			function()
				Snacks.picker.command_history()
			end,
			desc = "[f]ind [C]ommand history",
		},
		{
			"<leader>fH",
			function()
				Snacks.picker.search_history()
			end,
			desc = "[f]ind search [H]istory",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "[g]it [s]tatus",
		},
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "[g]it [b]ranches",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "[g]it [l]og",
		},
		{
			"<leader>gL",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "[g]it [L]og (current file)",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "[g]it [S]tash",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "[f]ind [r]ecent",
		},
		{
			"<leader>fg",
			function()
				Snacks.picker.grep({ hidden = true })
			end,
			desc = "[f]ind [g]rep",
		},
		{
			"<leader>fw",
			function()
				Snacks.picker.grep_word({ hidden = true })
			end,
			desc = "[f]ind [w]ord",
		},
		{
			"<leader>f/",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "[f]uzzy search open buffers [/]",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "[f]ind [b]uffers",
		},
		{
			"<leader>fd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "[f]ind [d]iagnostics",
		},
		{
			"<leader>fu",
			function()
				Snacks.picker.undo()
			end,
			desc = "[f]ind [u]ndo",
		},
		{
			"<leader>fk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "[f]ind [k]eymaps",
		},
		{
			"<leader>fc",
			function()
				Snacks.picker.resume()
			end,
			desc = "[f]ind [c]ontinue (resume)",
		},
		{
			"<leader>fh",
			function()
				Snacks.picker.help()
			end,
			desc = "[f]ind [h]elp",
		},
		{
			"<leader>fp",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "[f]ind [p]Rs (open)",
		},
		{
			"<leader>fP",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "[f]ind [P]Rs (all)",
		},
		{
			"<leader>fe",
			function()
				Snacks.explorer()
			end,
			desc = "[f]ile [e]xplorer",
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
	config = function(_, opts)
		require("snacks").setup(opts)

		local function set_picker_highlights()
			vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "Text" })
			vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { link = "Special" })
		end

		set_picker_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("snacks-picker-highlights", { clear = true }),
			callback = set_picker_highlights,
		})
	end,
}
