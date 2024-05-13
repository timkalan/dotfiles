return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			overrides = {
				SignColumn = { link = "Normal" },
				GruvboxGreenSign = { bg = "" },
				GruvboxOrangeSign = { bg = "" },
				GruvboxPurpleSign = { bg = "" },
				GruvboxYellowSign = { bg = "" },
				GruvboxRedSign = { bg = "" },
				GruvboxBlueSign = { bg = "" },
				GruvboxAquaSign = { bg = "" },
			},
			italic = {
				strings = false,
				emphasis = false,
				comments = false,
				operators = false,
				folds = false,
			},
		})
		vim.cmd.colorscheme("gruvbox")
	end,
}
