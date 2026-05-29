return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			dockerfile = { "hadolint" },
			-- go = { "golangci-lint" }, -- currently using LSP version
			markdown = { "markdownlint" },
			nix = { "statix" },
			sh = { "shellcheck" },
			sql = { "sqlfluff" },
			yaml = { "yamllint" },
		}

		-- lll: custom LLM linter (https://github.com/timkalan/lll, install via `cargo install --path .`)
		lint.linters.lll = {
			cmd = "lll",
			stdin = false,
			args = { "--format", "editor" },
			append_fname = true,
			ignore_exitcode = true,
			parser = require("lint.parser").from_pattern(
				[[([^:]+):(%d+):(%d+):(%d+):(%d+): (%w+): (.+)]],
				{ "file", "lnum", "col", "end_lnum", "end_col", "severity", "message" },
				{
					error = vim.diagnostic.severity.ERROR,
					warning = vim.diagnostic.severity.WARN,
					suggestion = vim.diagnostic.severity.HINT,
				},
				{ ["source"] = "lll" },
				{ end_col_offset = 0 }
			),
		}

		-- Runs linting on save, insert leave, or when reading a file
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				if not vim.bo.modifiable then
					return
				end

				lint.try_lint()
				lint.try_lint("typos")

				if vim.fn.expand("%:p"):match("%.github/workflows") then
					lint.try_lint("actionlint")
				end
			end,
		})

		-- lll runs save-only (multi-second Gemini call, costs API quota)
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = lint_augroup,
			callback = function()
				if not vim.bo.modifiable then
					return
				end
				lint.try_lint("lll")
			end,
		})
	end,
}
