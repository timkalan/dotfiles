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
						function()
							return " "
						end,
						color = function()
							local status = require("sidekick.status").get()
							if status then
								return status.kind == "Error" and "DiagnosticError"
									or status.busy and "DiagnosticWarn"
									or "Special"
							end
						end,
						cond = function()
							local status = require("sidekick.status")
							return status.get() ~= nil
						end,
					},
					{
						function()
							local status = require("sidekick.status").cli()
							return " " .. (#status > 1 and #status or "")
						end,
						cond = function()
							return #require("sidekick.status").cli() > 0
						end,
						color = function()
							return "Special"
						end,
					},
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
