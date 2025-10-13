return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "LazyFile",
    keys = {
        {
            "<leader>st",
            function()
                require("todo-comments.fzf").todo()
            end,
            desc = "Todo",
        },
        {
            "<leader>sT",
            function()
                require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
            end,
            desc = "Todo/Fix/Fixme",
        },
    },
    opts = {}
}
