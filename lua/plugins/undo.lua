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
    {
        "jiaoshijie/undotree",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {},
        keys = { -- load the plugin only when using it's keybinding:
            { "<leader>uu", "<cmd>lua require('undotree').toggle()<cr>" },
        },
    },
}
