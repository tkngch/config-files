-- init.lua
-- For the reference, please see `:help lua` or `https://neovim.io/doc/user/lua.html`

do -- Appearance
    -- Precede each line with its line number.
    vim.opt.number = true
    -- Show the line number relative to the line with the cursor.
    vim.opt.relativenumber = true
    -- Minimal number of screen lines to keep above and below the cursor.
    vim.opt.scrolloff = 8
    -- Highlight the text line of the cursor.
    vim.opt.cursorline = true

    -- List mode to display tabs and spaces.
    vim.opt.list = true
    vim.opt.listchars = { tab = "→ ", trail = "␣" }
    -- string to put at the start of lines that have been wrapped
    vim.opt.showbreak = "↳\\"

    -- Turn on the match highlighting.
    vim.opt.hlsearch = true

    -- Enables 24-bit RGB color in the TUI.
    vim.opt.termguicolors = true
end

do -- Behaviour
    -- Spell-check with British English
    vim.opt_local.spell.spelllang = "en_gb"
    vim.opt.spell = true

    -- Number of spaces to use for each step of (auto)indent.
    vim.opt.shiftwidth = 4
    -- Number of spaces that a <Tab> counts for while performing editing operations.
    vim.opt.softtabstop = 4
    -- Use the appropriate number of spaces to insert a <Tab>.
    vim.opt.expandtab = true
    -- Round indent to multiple of `shiftwidth`.
    vim.opt.shiftround = true

    -- Use the clipboard for all operations
    vim.opt.clipboard = "unnamedplus"

    -- Maximum number of lines kept beyond the visible screen in terminal buffers.
    vim.opt.scrollback = 100000

    -- Save undo history to a file and restore undo history from the file on buffer read.
    vim.opt.undofile = true

    -- <C-w><C-d> Show diagnostics under the cursor
    -- [d Jump to the previous diagnostic
    -- ]d Jump to the next diagnostic
    vim.diagnostic.config({
        -- Show diagnostics with higher severity before lower severity
        severity_sort = true,
    })

    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    local keymap_opts = { silent = false }
    vim.keymap.set("n", ";", ":")

    -- Exit the terminal-mode with Escape key
    vim.keymap.set("t", "<esc>", "<C-\\><C-n>")

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
            vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, keymap_opts)
            vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, keymap_opts)
            vim.keymap.set("n", "<leader>lu", vim.lsp.buf.references, keymap_opts)
            vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, keymap_opts)
        end,
    })

    -- Enable mouse support for all the modes
    vim.opt.mouse = "a"

    -- Highlight the yanked text
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank()
        end,
    })
end

-- Manage packages with lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load the packages defined in .config/nvim/lua/plugins/*.lua
require("lazy").setup("plugins")
