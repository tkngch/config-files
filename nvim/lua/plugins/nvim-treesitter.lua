return { -- syntax highlighting and more
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            auto_install = true,
            ensure_installed = { "lua", "vim", "vimdoc" },
            incremental_selection = {
                enable = true,
                keymaps = { -- set to `false` to disable one of the mappings
                    init_selection = "[x",
                    scope_incremental = false,
                    node_incremental = "[x",
                    node_decremental = "]x",
                },
            },
        })
    end,
}
