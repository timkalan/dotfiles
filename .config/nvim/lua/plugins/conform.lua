return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>fo",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F][o]rmat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 1000,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = {
			css = { "prettier" },
			html = { "rustywind" },
			javascript = { "biome", "rustywind" },
			javascriptreact = { "biome", "rustywind" },
			typescript = { "biome", "rustywind" },
			typescriptreact = { "biome", "rustywind" },
			json = { "biome" },
			lua = { "stylua" },
			markdown = { "prettier" },
			python = { "isort", "black" },
			sh = { "shfmt" },
			templ = { "templ", "rustywind" },
			yaml = { "prettier" },
		},
	},
}
