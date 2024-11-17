return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = "make"
            },
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
            "nvim-lua/plenary.nvim",
            "debugloop/telescope-undo.nvim",
            "smartpde/telescope-recent-files",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            })

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fw", builtin.grep_string, {})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
            vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})
            vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[S]earch [R]esume' })

            require("telescope").load_extension("undo")
            vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>")

            require("telescope").load_extension("recent_files")
            vim.keymap.set("n", "<leader>fr", "<cmd>lua require('telescope').extensions.recent_files.pick()<CR>")

            require("telescope").load_extension("fzf")
            require("telescope").load_extension("ui-select")
        end,
    }
}
