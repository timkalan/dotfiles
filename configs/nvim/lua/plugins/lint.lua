return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			dockerfile = { "hadolint" },
			-- go = { "golangci-lint" }, -- Commented out: currently using LSP version
			markdown = { "markdownlint" },
			nix = { "statix" },
			sh = { "shellcheck" },
			yaml = { "yamllint" },
		}

		-- Runs linting on save, insert leave, or when reading a file
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
				lint.try_lint("typos")

				if vim.fn.expand("%:p"):match("%.github/workflows") then
					lint.try_lint("actionlint")
				end
			end,
		})
	end,
}
