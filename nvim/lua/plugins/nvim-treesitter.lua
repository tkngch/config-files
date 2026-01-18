return { -- syntax highlighting and more
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            modules = {},
            -- A list of parser names, or "all"
            ensure_installed = { "lua", "vim", "vimdoc" },
            -- Automatically install missing parsers when entering buffer
            auto_install = true,
            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,
            -- List of parsers to ignore installing (for "all")
            ignore_install = {},
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
