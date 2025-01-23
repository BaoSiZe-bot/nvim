return {
    {
        "lewis6991/hover.nvim",
        lazy = true,
        opts = {
            init = function()
                require("hover.providers.lsp")
            end,
        },
    },
}
