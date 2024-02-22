return { -- autoformat code
    "mhartington/formatter.nvim",
    config = function()
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
    end,
}
