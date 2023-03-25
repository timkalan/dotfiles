-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

mason.setup()

-- list: https://github.com/williamboman/mason-lspconfig.nvim#setup
mason_lspconfig.setup({
	ensure_installed = {
		"clangd",
		"ltex",
		"lua_ls",
		"ocamllsp",
		"pyright",
	},
	-- auto-install configured formatters & linters (with lspconfig)
	automatic_installation = true,
})

-- list: https://github.com/jayp0521/mason-null-ls.nvim
mason_null_ls.setup({
	-- list of formatters & linters for mason to install
	ensure_installed = {
		"cpplint",
		"clang_format",
		"stylua", -- lua formatter
		"pylint", -- python linter
		-- "black", -- python formatter
	},
	-- auto-install configured formatters & linters (with null-ls)
	automatic_installation = true,
})
