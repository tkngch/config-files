return { -- to comment and uncomment code
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
        require("Comment").setup()
    end,
}
