return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"folke/snacks.nvim", -- for file_selector provider snacks
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	opts = {
		provider = "openrouter",
		providers = {
			openrouter = {
				__inherited_from = "openai",
				endpoint = "https://openrouter.ai/api/v1",
				api_key_name = "OPENROUTER_API_KEY",
				-- model = "anthropic/claude-sonnet-4",
				-- model = "anthropic/claude-3.7-sonnet",
				model = "google/gemini-2.5-pro",
			},
		},
		-- behaviour = {
		-- 	auto_apply_diff_after_generation = true,
		-- 	enable_cursor_planning_mode = true,
		-- },
	},
}
