-- The setup for LUA_LS is taken from https://github.com/neovim/nvim-lspconfig/blob/a284b14b3a9c4851f900286cd7eb68e3a8f90b1c/lua/lspconfig/server_configurations/lua_ls.lua#L46
local lua_ls_setup = {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
        })
    end,
    settings = {
        Lua = {},
    },
}

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    config = function()
        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup(lua_ls_setup)
        lspconfig.pyright.setup({})
        lspconfig.rust_analyzer.setup({})
    end,
}
