return {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage [h]unk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset [h]unk" })
				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [s]tage [h]unk" })
				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "git [r]eset [h]unk" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage k" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review [h]unk" })
				map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "git preview [h]unk [i]nline" })
				map("n", "<leader>hb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "git [b]lame line" })
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "git [t]oggle [b]lame" })
				map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "git [t]oggle [w]ord diff" })
				map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff" })
				map("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end)
				map("n", "<leader>tg", function()
					require("gitsigns").setqflist("attached")
					require("trouble").open("quickfix")
				end, { desc = "Git Review (Current File)" })
				map("n", "<leader>tG", function()
					require("gitsigns").setqflist("all")
					require("trouble").open("quickfix")
				end, { desc = "Git Review (Current Project)" })
				map("n", "<leader>fv", function()
					Snacks.picker.git_status()
				end, { desc = "Git Review (Current Project)" })

				-- Text object
				map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "text object: [i]nside [h]unk" })
			end,
		})
	end,
}
