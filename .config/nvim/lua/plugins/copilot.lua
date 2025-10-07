return {
	event = "InsertEnter",
	"zbirenbaum/copilot.lua",
	config = function()
		require("copilot").setup({
			panel = { enabled = false },
			suggestion = { auto_trigger = true },
		})
		vim.keymap.set("i", "<Tab>", function()
			if require("copilot.suggestion").is_visible() then
				return require("copilot.suggestion").accept()
			else
				return "<Tab>"
			end
		end, { expr = true, silent = true })
	end,
}
