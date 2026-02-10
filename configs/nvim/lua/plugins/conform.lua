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
					timeout_ms = 5000,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = {
			css = { "deno_fmt", "prettierd", "biome" },
			go = { "gofumpt" },
			html = { "rustywind" },
			javascript = { "deno_fmt", "prettierd", "biome" },
			javascriptreact = { "deno_fmt", "prettierd", "biome" },
			json = { "deno_fmt", "prettierd", "biome" },
			lua = { "stylua" },
			markdown = { "mdformat" },
			nix = { "nixfmt" },
			python = { "isort", "black" },
			sh = { "shfmt" },
			typescript = { "deno_fmt", "prettierd", "biome" },
			typescriptreact = { "deno_fmt", "prettierd", "biome" },
			yaml = { "deno_fmt", "prettierd", "biome" },
		},
	},
}
