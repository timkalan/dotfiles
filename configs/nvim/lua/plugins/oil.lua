return {
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("oil").setup({
				skip_confirm_for_simple_edits = true,
				prompt_save_on_select_new_entry = false,
				lsp_file_methods = {
					enabled = true,
					timeout_ms = 1000,
					autosave_changes = false,
				},
				delete_to_trash = true,
				view_options = {
					show_hidden = true,
				},
				win_options = {
					signcolumn = "yes:2",
				},
				keymaps = {
					-- interfere with vim-tmux
					["<C-l>"] = false,
					["<C-h>"] = false,
				},
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{
		"refractalize/oil-git-status.nvim",

		dependencies = {
			"stevearc/oil.nvim",
		},

		config = true,
	},
	{
		"JezerM/oil-lsp-diagnostics.nvim",
		dependencies = { "stevearc/oil.nvim" },
		opts = {},
	},
}
