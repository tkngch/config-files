return { -- interface for cycling through diffs for git rev.
    "sindrets/diffview.nvim",
    config = function()
        vim.keymap.set("", "<leader>gd", function()
            vim.cmd("DiffviewOpen")
        end)
    end,
}
