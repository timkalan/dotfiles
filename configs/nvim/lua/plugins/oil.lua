return {
	{
		"stevearc/oil.nvim",
		lazy = false, -- needed so default_file_explorer takes over netrw at startup
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			skip_confirm_for_simple_edits = true,
			prompt_save_on_select_new_entry = false,
			delete_to_trash = true,
			lsp_file_methods = {
				enabled = true,
				timeout_ms = 3000,
				autosave_changes = true,
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					return name == ".DS_Store"
				end,
			},
			win_options = {
				signcolumn = "yes:2",
			},
			keymaps = {
				-- interfere with vim-tmux-navigator
				["<C-l>"] = false,
				["<C-h>"] = false,
			},
		},
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "oil: open parent directory" },
		},
	},
	{
		"refractalize/oil-git-status.nvim",
		dependencies = { "stevearc/oil.nvim" },
		config = true,
	},
	{
		"JezerM/oil-lsp-diagnostics.nvim",
		dependencies = { "stevearc/oil.nvim" },
		opts = {},
	},
}
