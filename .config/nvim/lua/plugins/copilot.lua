return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			panel = { enabled = false },
			suggestion = { auto_trigger = true, keymap = { accept = "<M-CR>" } },
		})
	end,
}
