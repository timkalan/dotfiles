return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			transparent_mode = true,
			dim_inactive = false,
			terminal_colors = false,
		})
		vim.o.background = "dark"
		vim.cmd.colorscheme("gruvbox")
	end,
}
-- return {
--     "neanias/everforest-nvim",
--     version = false,
--     lazy = false,
--     priority = 1000, -- make sure to load this before all the other start plugins
--     -- Optional; default configuration will be used if setup isn't called.
--     config = function()
--         require("everforest").setup({
--             -- Your config here
--         })
--         vim.cmd.colorscheme("everforest")
--     end,
-- }
