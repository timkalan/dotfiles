return {
	"saghen/blink.cmp",
	version = "*",
	build = "cargo build --release",
	event = "VimEnter",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
		-- "zbirenbaum/copilot-cmp",
		"onsails/lspkind.nvim",
		"folke/lazydev.nvim",
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = {
			-- 'default' (recommended) for mappings similar to built-in completions
			--   <c-y> to accept ([y]es) the completion.
			--    This will auto-import if your LSP supports it.
			--    This will expand snippets if the LSP sent a snippet.
			-- 'super-tab' for tab to accept
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- For an understanding of why the 'default' preset is recommended,
			-- you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			--
			-- All presets have the following mappings:
			-- <tab>/<s-tab>: move to right/left of your snippet expansion
			-- <c-space>: Open menu or open docs if already open
			-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
			-- <c-e>: Hide menu
			-- <c-k>: Toggle signature help
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			preset = "super-tab",

			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		completion = {
			-- By default, you may press `<c-space>` to show the documentation.
			-- Optionally, set `auto_show = true` to show the documentation after a delay.
			documentation = { auto_show = true, auto_show_delay_ms = 0 },
			-- ghost_text = { enabled = true },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer", "lazydev" },
			providers = {
				lazydev = {
					module = "lazydev.integrations.blink",
					score_offset = 5,
				},
				snippets = {
					-- min_keyword_length = 2,
					score_offset = 4,
				},
				lsp = {
					score_offset = 3,
				},
				path = {
					score_offset = 2,
				},
				buffer = {
					score_offset = 1,
				},
			},
		},

		snippets = { preset = "luasnip" },

		-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
		-- which automatically downloads a prebuilt binary when enabled.
		--
		-- By default, we use the Lua implementation instead, but you may enable
		-- the rust implementation via `'prefer_rust_with_warning'`
		--
		-- See :h blink-cmp-config-fuzzy for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },

		-- Shows a signature help window while you type arguments for a function
		signature = { enabled = true },
	},

	-- Change the bg color to be "transparent"
	vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "BlinkCmpDoc" }),
	vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "BlinkCmpDocBorder" }),
}
