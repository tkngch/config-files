return { -- syntax highlighting and more
    "nvim-treesitter/nvim-treesitter",
    build = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
    end,
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vim", "vimdoc" },
            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<TAB>", -- set to `false` to disable one of the mappings
                    scope_incremental = false,
                    node_incremental = "<TAB>",
                    node_decremental = "<S-TAB>",
                },
            },
        })
    end,
}
