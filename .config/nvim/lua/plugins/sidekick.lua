return {
	"folke/sidekick.nvim",
	opts = {
		nes = { enabled = false },
		cli = {
			mux = {
				backend = "tmux",
				enabled = false,
			},
		},
	},
	keys = {
		{
			"<tab>",
			function()
				-- if there is a next edit, jump to it, otherwise apply it if any
				if require("sidekick").nes_jump_or_apply() then
					return -- jumped or applied
				end

				-- if you are using Neovim's native inline completions
				-- if require("copilot.suggestion").is_visible() then
				-- 	return require("copilot.suggestion").accept()
				-- end

				-- fall back to normal tab
				return "<Tab>"
			end,
			mode = { "i", "n" },
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle({ name = "opencode" })
			end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>as",
			function()
				require("sidekick.cli").select()
			end,
			desc = "Select CLI",
		},
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}", name = "opencode" })
			end,
			desc = "Send File",
		},
		{
			"<leader>at",
			function()
				require("sidekick.cli").send({ msg = "{this}", name = "opencode" })
			end,
			mode = { "x", "n" },
			desc = "Send This",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}", name = "opencode" })
			end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt({ name = "opencode" })
			end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
		{
			"<c-.>",
			function()
				require("sidekick.cli").focus()
			end,
			mode = { "n", "x", "i", "t" },
			desc = "Sidekick Switch Focus",
		},
		{
			"<leader>ac",
			function()
				require("sidekick.cli").toggle({ name = "opencode", focus = true })
			end,
			desc = "Sidekick Toggle Claude",
		},
	},
}
