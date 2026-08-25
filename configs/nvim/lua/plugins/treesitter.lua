return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
				enable = true,
				max_lines = 10,
				trim_scope = "outer",
			},
		},
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	},
	config = function()
		vim.api.nvim_set_hl(0, "TreesitterContext", { link = "ColorColumn" })

		local function attach(buf, lang)
			if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(lang) then
				return
			end
			vim.treesitter.start(buf, lang)
			-- Only some parsers ship an indents query; without one indentexpr breaks indentation
			if vim.treesitter.query.get(lang, "indents") ~= nil then
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end

		-- Enable treesitter highlighting and indentation, auto-install missing parsers
		local available = require("nvim-treesitter").get_available()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end

				local installed = require("nvim-treesitter").get_installed("parsers")
				if vim.tbl_contains(installed, lang) or not vim.tbl_contains(available, lang) then
					attach(args.buf, lang)
				else
					require("nvim-treesitter").install(lang):await(function()
						attach(args.buf, lang)
					end)
				end
			end,
		})

		-- Incremental selection keymaps using built-in treesitter
		vim.keymap.set("n", "<M-Up>", function()
			require("nvim-treesitter.incremental_selection").init_selection()
		end, { desc = "Init treesitter selection" })
		vim.keymap.set("v", "<M-Up>", function()
			require("nvim-treesitter.incremental_selection").node_incremental()
		end, { desc = "Expand treesitter selection" })
		vim.keymap.set("v", "<M-Down>", function()
			require("nvim-treesitter.incremental_selection").node_decremental()
		end, { desc = "Shrink treesitter selection" })
		vim.keymap.set("v", "<M-Right>", function()
			require("nvim-treesitter.incremental_selection").scope_incremental()
		end, { desc = "Expand to scope" })
	end,
}
