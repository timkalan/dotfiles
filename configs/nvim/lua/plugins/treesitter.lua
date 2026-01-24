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

		-- Enable treesitter highlighting and indentation, auto-install missing parsers
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match) or args.match
				-- Auto-install parser if missing
				if not pcall(vim.treesitter.language.inspect, lang) then
					vim.cmd("silent! TSInstall " .. lang)
				end
				pcall(vim.treesitter.start)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
