return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"refractalize/oil-git-status.nvim",
	},
	config = function()
		require("oil").setup({
			skip_confirm_for_simple_edits = true,
			prompt_save_on_select_new_entry = false,
			delete_to_trash = true,
			view_options = {
				show_hidden = true,
			},
			win_options = {
				signcolumn = "yes",
			},
			keymaps = {
				-- interfere with vim-tmux
				["<C-l>"] = false,
				["<C-h>"] = false,
			},
		})
		require("oil-git-status").setup({})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
