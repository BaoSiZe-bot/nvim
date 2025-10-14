return {
    "tiagovla/scope.nvim",
    event = "UIEnter",
    keys = {
        {
            "<leader>sf",
            mode = { "n" },
            function()
                vim.cmd("ScopeMoveBuf")
            end,
            desc = "Find all buffers",
        },
    },
    opts = {

    }
}
