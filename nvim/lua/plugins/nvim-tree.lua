return { -- file explorer
    "nvim-tree/nvim-tree.lua",
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
                group_empty = true,
                icons = {
                    git_placement = "after",
                    show = {
                        file = false,
                        folder = false,
                        folder_arrow = false,
                        git = true,
                        modified = true,
                        hidden = false,
                        diagnostics = false,
                        bookmarks = false,
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
