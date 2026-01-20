return { -- code outline window
    "stevearc/aerial.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("aerial").setup()
        vim.keymap.set("n", "<leader>aa", function()
            vim.cmd("AerialToggle!")
        end)
    end,
}
