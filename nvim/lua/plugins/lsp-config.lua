return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = function()
        vim.lsp.enable("lua_ls")
        vim.lsp.enable("gopls")
        vim.lsp.enable("pyright")
        vim.lsp.enable("rust_analyzer")
    end,
}
