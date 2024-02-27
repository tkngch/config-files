return { -- file explorer
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- optional
        -- nvim-web-devicons requires a patched font.
        -- To install on Mac, `brew tap homebrew/cask-fonts` and then `brew install --cask font-hack-nerd-font`
    },
    config = function()
        -- disable netrw
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        local api = require("nvim-tree.api")

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
            },
        })

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
