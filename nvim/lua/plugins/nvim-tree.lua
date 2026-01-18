return { -- file explorer
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- disable netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            -- Changes the tree root directory on `DirChanged` and refreshes the tree.
            sync_root_with_cwd = true,
            view = {
                -- dynamically sized view, based on the longest line
                width = {},
            },
            update_focused_file = {
                enable = true,
            },
            renderer = {
                -- Appends a trailing slash to folder names.
                add_trailing = true,
                -- Compact folders that only contain a single folder into one node.
                group_empty = true,
                -- Enable highlight for git attributes.
                highlight_git = "name",
                icons = {
                    show = {
                        bookmarks = false,
                        diagnostics = false,
                        file = false,
                        folder = false,
                        folder_arrow = true,
                        git = false,
                        hidden = false,
                        modified = false,
                    },
                },
            },
        })

        local api = require("nvim-tree.api")
        vim.keymap.set("", "<leader>tt", function()
            if api.tree.is_visible() then
                api.tree.collapse_all()
                api.tree.close()
            else
                api.tree.open()
            end
        end)
    end,
}
