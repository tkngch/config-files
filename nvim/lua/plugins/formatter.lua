return { -- autoformat code
    "mhartington/formatter.nvim",
    config = function()
        require("formatter").setup({
            filetype = {
                json = require("formatter.filetypes.json").prettier,
                lua = require("formatter.filetypes.lua").stylua,
                markdown = require("formatter.filetypes.markdown").prettier,
                python = require("formatter.filetypes.python").ruff,
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
    end,
}
