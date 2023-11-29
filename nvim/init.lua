-- init.lua
-- For the reference, please see `:help lua` or `https://neovim.io/doc/user/lua.html`

do -- Appearance
    -- Precede each line with its line number.
    vim.opt.number = true
    -- Show the line number relative to the line with the cursor.
    vim.opt.relativenumber = true
    -- Minimal number of screen lines to keep above and below the cursor.
    vim.opt.scrolloff = 8

    -- List mode to display tabs and spaces.
    vim.opt.list = true
    vim.opt.listchars = { tab = "→ ", trail = "␣" }
    -- string to put at the start of lines that have been wrapped
    vim.opt.showbreak = "↳\\"

    -- Turn off the match highlighting.
    vim.opt.hlsearch = false

    -- Enables 24-bit RGB color in the TUI.
    vim.opt.termguicolors = true
    -- Set the default colour-scheme. To be shadowed by the package below.
    vim.cmd.colorscheme("slate")

    if vim.g.neovide then
        vim.opt.guifont = { "Monaco", "h12" }
    end
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

    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
    vim.keymap.set("n", ";", ":")

    -- Get the standard keys to work with wrap
    vim.keymap.set("", "j", "gj", { silent = true })
    vim.keymap.set("", "k", "gk", { silent = true })
    -- Exit the terminal-mode with Escape key
    vim.keymap.set("t", "<esc>", "<C-\\><C-n>")

    -- Enable mouse support for all the modes
    vim.opt.mouse = "a"

    -- Highlight the yanked text
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank()
        end,
    })
end

require("packer").startup(function(use)
    -- package manager for neovim
    use("wbthomason/packer.nvim")

    use({ --  fuzzy finder for files, buffers, and more
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            configure_telescope()
        end,
    })

    use({ -- file explorer
        "nvim-tree/nvim-tree.lua",
        -- requires = {
        --     "nvim-tree/nvim-web-devicons", -- optional
        -- },
        config = function()
            configure_nvim_tree()
        end,
    })

    -- to change the working directory to the project root
    use("airblade/vim-rooter")

    use({ -- to comment and uncomment code
        "numToStr/Comment.nvim",
        config = function()
            configure_comment()
        end,
    })

    use({ -- autoformat code
        "mhartington/formatter.nvim",
        config = function()
            configure_formatter()
        end,
    })

    use({ -- syntax highlighting and more
        "nvim-treesitter/nvim-treesitter",
        run = function()
            update_treesitter_parsers()
        end,
        config = function()
            configure_treesitter()
        end,
    })

    use({ -- git decorations
        "lewis6991/gitsigns.nvim",
        config = function()
            configure_gitsigns()
        end,
    })

    use({ -- colour scheme
        "EdenEast/nightfox.nvim",
        config = function()
            vim.cmd.colorscheme("nightfox")
        end,
    })
end)

function configure_telescope()
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    require("telescope").setup({
        defaults = {
            sorting_strategy = "ascending",
            layout_strategy = "vertical",
            layout_config = { vertical = { mirror = true } },
            mappings = {
                i = {
                    -- Exit with Escape key
                    ["<esc>"] = actions.close,
                },
            },
        },
    })

    vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    -- list available help tags to show the help info
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    -- list previously open files
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {})
end

function configure_nvim_tree()
    -- disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local api = require("nvim-tree.api")

    require("nvim-tree").setup({
        view = {
            -- dynamically sized view, based on the longest line
            width = {},
        },
        update_focused_file = {
            enable = true,
        },
        renderer = {
            group_empty = true,
            icons = {
                glyphs = {
                    default = "",
                    symlink = "",
                    modified = "●",
                    folder = {
                        arrow_closed = "▷",
                        arrow_open = "▽",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "✗",
                        staged = "✓",
                        unmerged = "★",
                        renamed = "➜",
                        untracked = "",
                        deleted = "⦙",
                        ignored = "◌",
                    },
                },
            },
        },
    })

    vim.keymap.set("", "<leader>tt", function()
        if api.tree.is_visible() then
            api.tree.collapse_all()
            api.tree.close()
        else
            api.tree.open()
        end
    end)
end

function configure_comment()
    require("Comment").setup()
end

function configure_formatter()
    require("formatter").setup({
        filetype = {
            lua = require("formatter.filetypes.lua").stylua,
            markdown = require("formatter.filetypes.markdown").prettier,
            ["*"] = require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    })
    -- format and write after save asynchronously
    vim.cmd([[
        augroup FormatAutogroup
            autocmd!
            autocmd BufWritePost * FormatWrite
        augroup END
    ]])
end

function update_treesitter_parsers()
    local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
    ts_update()
end

function configure_treesitter()
    require("nvim-treesitter.configs").setup({
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
    })
end

function configure_gitsigns()
    require("gitsigns").setup({
        signs = {
            add = { text = "+" },
            change = { text = "│" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
    })
end

function reload_init()
    vim.cmd.source(vim.env.MYVIMRC)
    vim.cmd.PackerCompile()
    -- vim.cmd.PackerSync()
end
