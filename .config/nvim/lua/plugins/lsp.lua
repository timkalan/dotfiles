return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{
			"j-hui/fidget.nvim",
			opts = {
				notification = {
					window = {
						winblend = 0,
					},
				},
			},
		},
		"saghen/blink.cmp",
		{
			"folke/lazydev.nvim",
			ft = "lua",
		},
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Disable defaults
				pcall(vim.keymap.del, { "n", "x" }, "gra")
				pcall(vim.keymap.del, "n", "gri")
				pcall(vim.keymap.del, "n", "grn")
				pcall(vim.keymap.del, "n", "grr")
				pcall(vim.keymap.del, "n", "grt")

				map("gd", function()
					Snacks.picker.lsp_definitions()
				end, "[G]oto [D]efinition")
				map("<leader>gd", function()
					vim.api.nvim_command("vsplit")
					vim.api.nvim_command("wincmd l")
					vim.lsp.buf.definition()
				end, "[G]oto [D]efinition [Split]")
				map("gr", function()
					Snacks.picker.lsp_references()
				end, "[G]oto [R]eferences")
				map("<leader>gr", vim.lsp.buf.references, "[G]oto [R]eferences")
				map("gi", function()
					Snacks.picker.lsp_implementations()
				end, "[G]oto [I]mplementation")
				map("<leader>gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
				map("gt", function()
					Snacks.picker.lsp_type_definitions()
				end, "[G]oto [T]ype Definition")
				map("gD", function()
					Snacks.picker.lsp_declarations()
				end, "[G]oto [D]eclaration")
				map("<leader>ds", function()
					Snacks.picker.lsp_symbols()
				end, "[D]ocument [S]ymbols")
				map("<leader>ws", function()
					Snacks.picker.lsp_workspace_symbols()
				end, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("<leader>ho", vim.lsp.buf.hover, "[H][o]ver")

				-- Highlight references for word under cursor
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if
					client
					and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
				then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

					-- Highlight references like matching paranthesis
					vim.api.nvim_set_hl(0, "LspReferenceText", { link = "MatchParen" })
					vim.api.nvim_set_hl(0, "LspReferenceRead", { link = "MatchParen" })
					vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "MatchParen" })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- Toggle inlay hints
				if
					client
					and client:supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
				then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Diagnostic Config
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			-- underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "E ",
					[vim.diagnostic.severity.WARN] = "W ",
					[vim.diagnostic.severity.INFO] = "I ",
					[vim.diagnostic.severity.HINT] = "H ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 4,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local servers = {
			bashls = {},
			clangd = {},
			cssls = {},
			denols = {
				root_markers = { "deno.json", "deno.jsonc" },
				workspace_required = true,
			},
			eslint = {},
			gopls = {
				gopls = {
					hints = {
						compositeLiteralFields = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					usePlaceholders = true,
				},
			},
			golangci_lint_ls = {},
			html = {},
			jsonls = {},
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
			-- ocamllsp = {},
			pyright = {},
			ruff = {},
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
						},
					},
				},
			},
			svelte = {},
			templ = {},
			tailwindcss = {
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"templ",
				},
				init_options = {
					userLanguages = {
						templ = "html",
					},
				},
			},
			vtsls = {
				root_markers = { "package.json" },
				single_file_support = false,
			},
			yamlls = {},
			black = {},
			nil_ls = {},
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("lazydev").setup()
		require("mason-lspconfig").setup({
			automatic_installation = false,
		})

		for server_name, server_config in pairs(servers) do
			server_config.capabilities =
				vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
			vim.lsp.config(server_name, server_config)
			vim.lsp.enable(server_name)
		end
	end,
}
