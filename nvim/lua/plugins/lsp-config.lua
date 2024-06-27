return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.gopls.setup({})
        lspconfig.jdtls.setup({})
        lspconfig.lua_ls.setup({})
        lspconfig.pyright.setup({})
        lspconfig.rust_analyzer.setup({})
    end,
}
