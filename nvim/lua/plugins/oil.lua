return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = false,
      view_options = {
        show_hidden = true
      }
    })
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end
}
