return { -- git decorations
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")
                vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { buffer = bufnr })
                vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { buffer = bufnr })
            end,
        })
    end,
}
