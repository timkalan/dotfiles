return {
	"neovim/nvim-lspconfig",
	dependencies = {
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
			opts = {
				library = {
					{ path = "snacks.nvim", words = { "Snacks" } },
					{ path = "lazy.nvim", words = { "LazyVim" } },
				},
			},
		},
		{
			"dmmulroy/ts-error-translator.nvim",
			opts = {}, -- Automatic setup
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
				end, "[g]oto [d]efinition")
				map("<leader>gd", function()
					vim.api.nvim_command("vsplit")
					vim.api.nvim_command("wincmd l")
					vim.lsp.buf.definition()
				end, "[g]oto [d]efinition (split)")
				map("gr", function()
					Snacks.picker.lsp_references()
				end, "[g]oto [r]eferences")
				map("<leader>gr", vim.lsp.buf.references, "[g]oto [r]eferences")
				map("gi", function()
					Snacks.picker.lsp_implementations()
				end, "[g]oto [i]mplementation")
				map("<leader>gi", vim.lsp.buf.implementation, "[g]oto [i]mplementation")
				map("gt", function()
					Snacks.picker.lsp_type_definitions()
				end, "[g]oto [t]ype definition")
				map("gD", function()
					Snacks.picker.lsp_declarations()
				end, "[g]oto [D]eclaration")
				map("<leader>ds", function()
					Snacks.picker.lsp_symbols()
				end, "[d]ocument [s]ymbols")
				map("<leader>ws", function()
					Snacks.picker.lsp_workspace_symbols()
				end, "[w]orkspace [s]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction", { "n", "x" })
				map("<leader>ho", vim.lsp.buf.hover, "[h][o]ver")

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
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[t]oggle inlay [h]ints")
				end
			end,
		})

		-- Diagnostic Config
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = { min = vim.diagnostic.severity.WARN } },
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
			-- Open the float on [d / ]d so the message is readable without a second keypress
			jump = {
				on_jump = function(_, bufnr)
					vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
				end,
			},
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local servers = {
			bashls = {},
			biome = {},
			clangd = {},
			cssls = {},
			denols = {
				root_markers = { "deno.json", "deno.jsonc" },
				workspace_required = true,
			},
			docker_compose_language_service = {},
			dockerls = {},
			eslint = {},
			gopls = {
				settings = {
					gopls = {
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
						usePlaceholders = true,
						staticcheck = true,
					},
				},
			},
			golangci_lint_ls = {},
			html = {},
			jsonls = {},
			lua_ls = {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			},
			-- ocamllsp = {},
			marksman = {},
			pyright = {},
			ruff = {},
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
							-- Strict lint set from namtao.com/rust, applied to every Rust
							-- project. These land after any Cargo.toml `[lints]`, so they
							-- override a project that sets these lints itself.
							extraArgs = {
								"--",
								-- um, actually
								"-Dclippy::pedantic",
								"-Dclippy::nursery",
								-- deny panics
								"-Dclippy::unwrap_used",
								"-Dclippy::expect_used",
								"-Dclippy::indexing_slicing",
								"-Dclippy::arithmetic_side_effects",
								"-Dclippy::unreachable",
								"-Dclippy::unimplemented",
								"-Dclippy::unchecked_time_subtraction",
								"-Dclippy::todo",
								"-Dclippy::string_slice",
								"-Dclippy::panic_in_result_fn",
								"-Dclippy::panic",
								"-Dclippy::exit",
								"-Dclippy::as_conversions",
							},
							-- Lets the allow-*-in-tests keys apply everywhere too.
							extraEnv = {
								CLIPPY_CONF_DIR = vim.fn.expand("~/dotfiles/configs/rust"),
							},
						},
					},
				},
			},
			tailwindcss = {
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
				},
			},
			taplo = {},
			vtsls = {
				root_markers = { "package.json" },
				single_file_support = false,
			},
			yamlls = {},
			nixd = {
				settings = {
					nixd = {
						nixpkgs = {
							expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs { }",
						},
						options = {
							nixos = {
								expr = "(builtins.getFlake (toString ./.)).nixosConfigurations.davor.options",
							},
							nix_darwin = {
								expr = "(builtins.getFlake (toString ./.)).darwinConfigurations.diego.options",
							},
							home_manager = {
								expr = "(builtins.getFlake (toString ./.)).darwinConfigurations.diego.options.home-manager.users.type.getSubOptions []",
							},
						},
					},
				},
			},
		}

		require("lazydev").setup()

		for server_name, server_config in pairs(servers) do
			server_config.capabilities =
				vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
			vim.lsp.config(server_name, server_config)
			pcall(vim.lsp.enable, server_name)
		end
	end,
}
