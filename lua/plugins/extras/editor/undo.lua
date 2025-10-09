return {
    {
        "kevinhwang91/nvim-fundo",
        event = "VeryLazy",
        dependencies = "kevinhwang91/promise-async",
        opts = {},
        build = function()
            require("fundo").install()
        end,
    },
}
