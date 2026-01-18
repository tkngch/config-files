return { --  fuzzy finder for files, buffers, and more
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.1",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        local actions = require("telescope.actions")
        local builtin = require("telescope.builtin")

        require("telescope").setup({
            defaults = {
                layout_strategy = "vertical",
                layout_config = {
                    vertical = {
                        mirror = true,
                    },
                },
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                        ["<Down>"] = actions.cycle_history_next,
                        ["<Up>"] = actions.cycle_history_prev,
                    },
                },
            },
        })

        vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
        -- list available help tags to show the help info
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        -- list previously open files
        vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {})
    end,
}
