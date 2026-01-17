return {
    "neovim/nvim-lspconfig",
    config = function()
        vim.lsp.enable("lua_ls")
        vim.lsp.enable("gopls")
        vim.lsp.enable("pyright")
        vim.lsp.enable("rust_analyzer")
    end,
}
