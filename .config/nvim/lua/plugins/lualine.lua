return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "f-person/git-blame.nvim" },
	config = function()
		local git_blame = require("gitblame")
		vim.g.gitblame_display_virtual_text = 0
		vim.g.gitblame_date_format = "%r"
		vim.g.gitblame_message_template = "<author> • <date>"
		require("lualine").setup({
			sections = {
				lualine_c = {
					{
						"filename",
						file_status = true,
						path = 1,
					},
				},
				lualine_x = {
					{
						git_blame.get_current_blame_text,
						cond = git_blame.is_blame_text_available,
						separator = "",
						padding = 1,
					},
					{
						function()
							if vim.bo.expandtab then
								return "󱁐"
							else
								return ""
							end
						end,
						padding = 2,
					},
					"encoding",
					"fileformat",
					"filetype",
				},
			},
			options = {
				theme = "gruvbox",
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},
		})
	end,
}
