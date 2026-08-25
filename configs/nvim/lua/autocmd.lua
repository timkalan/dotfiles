vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	desc = "Reload the buffer when the file changed on disk",
	group = vim.api.nvim_create_augroup("checktime", { clear = true }),
	callback = function()
		-- Scheduled because :checktime cannot reload a buffer while an autocmd is running
		if vim.o.buftype ~= "nofile" then
			vim.schedule(function()
				vim.cmd("checktime")
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Restore the cursor to its last position in the file",
	group = vim.api.nvim_create_augroup("last-loc", { clear = true }),
	callback = function(args)
		-- Guarded so `:e` on a file you have scrolled doesn't drag you back to the mark
		if vim.bo[args.buf].filetype == "gitcommit" or vim.b[args.buf].last_loc then
			return
		end
		vim.b[args.buf].last_loc = true

		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "Close throwaway buffers with q",
	group = vim.api.nvim_create_augroup("close-with-q", { clear = true }),
	pattern = { "checkhealth", "gitsigns-blame", "help", "man", "qf", "snacks_notif_history" },
	callback = function(args)
		vim.bo[args.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true, desc = "close buffer" })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Create missing parent directories when saving",
	group = vim.api.nvim_create_augroup("auto-create-dir", { clear = true }),
	callback = function(args)
		if args.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		vim.fn.mkdir(vim.fn.fnamemodify(args.match, ":p:h"), "p")
	end,
})
