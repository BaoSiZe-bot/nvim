return
{
    "shellRaining/hlchunk.nvim",
    dependencies = {
        {
            "nmac427/guess-indent.nvim",
            event = "LazyFile",
            opts = {}
        },
        {
            "hiphish/rainbow-delimiters.nvim",
            event = "LazyFile",
            config = function()
                local rainbow_delimiters = require("rainbow-delimiters")
                require("rainbow-delimiters.setup").setup({
                    strategy = {
                        [""] = rainbow_delimiters.strategy["global"],
                        vim = rainbow_delimiters.strategy["local"],
                    },
                    query = {
                        [""] = "rainbow-delimiters",
                        lua = "rainbow-blocks",
                    },
                    priority = {
                        [""] = 110,
                        lua = 210,
                    },
                    highlight = {
                        "RainbowDelimiterRed",
                        "RainbowDelimiterYellow",
                        "RainbowDelimiterBlue",
                        "RainbowDelimiterOrange",
                        "RainbowDelimiterGreen",
                        "RainbowDelimiterViolet",
                        "RainbowDelimiterCyan",
                    },
                })
            end,
        },
    },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        line_num = {
            enable = true,
            duration = 150,
            delay = 100,
            -- ...
        },
        chunk = {
            enable = true,
            duration = 150,
            delay = 100,
            -- ...
        },
        indent = {
            enable = true,
            duration = 100,
            delay = 100,
            -- chars = {
            --     "│",
            -- },
            style = {
                -- vim.api.nvim_get_hl(0, { name = "Whitespace" }),

                "#E78285",
                "#E5C891",
                "#8CAAEF",
                "#EF9F77",
                "#A6D18A",
                "#CA9EE7",
                "#81C8BF",
            },
        },
        blank = {
            enable = false,
            chars = {
                "    ",
            },
            style = {
                { bg = "#443456" }, -- 紫色调     (原 #ca9ee7)
                { bg = "#2c3850" }, -- 蓝色调     (原 #8caaef)
                { bg = "#503830" }, -- 橙色调     (原 #ef9f77)
                { bg = "#4a4430" }, -- 黄褐色调   (原 #e5c897)
                { bg = "#3a4b34" }, -- 草绿色调   (原 #a6d18a)
                { bg = "#324b47" }, -- 青绿色调   (原 #81c8bf)
            },
        },
    }
}
