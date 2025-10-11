return {
    {
        "shellRaining/hlchunk.nvim",
        dependencies = {
            {
                "nmac427/guess-indent.nvim",
                opts = {}
            },
            {
                "hiphish/rainbow-delimiters.nvim",
                config = function()
                    vim.g.rainbow_delimiters = {
                        strategy = {
                            [""] = 'rainbow-delimiters.strategy.global',
                            vim = 'rainbow-delimiters.strategy.local',
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
                    }
                end,
            },
        },
        event = "User FilePost",
        opts = {
            line_num = {
                enable = true,
                duration = 150,
                delay = 100,
                -- ...
            },
            chunk = {
                enable = false,
                duration = 150,
                delay = 100,
                -- ...
            },
            indent = {
                enable = false,
                duration = 100,
                delay = 100,
                -- chars = {
                --     "│",
                -- },
                style = {
                    -- vim.api.nvim_get_hl(0, { name = "Whitespace" }),

                    "#E78284",
                    "#E5C890",
                    "#8CAAEE",
                    "#EF9F76",
                    "#A6D189",
                    "#CA9EE6",
                    "#81C8BE",
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
        },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "User FilePost",
        opts = {
            indent = { char = "│" --[[, highlight = "IblChar"]] },
            scope = { char = "│" --[[, highlight = "IblScopeChar"]] },
        },
        config = function(_, opts)
            -- dofile(vim.g.base46_cache .. "blankline")

            local hooks = require "ibl.hooks"
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }
            opts.indent.highlight = highlight
            -- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                local hl = {}
                local C = require("catppuccin.palettes").get_palette(require("catppuccin").flavour)
                hl["RainbowRed"] = { blend = 0, fg = C.red }
                hl["RainbowYellow"] = { blend = 0, fg = C.yellow }
                hl["RainbowBlue"] = { blend = 0, fg = C.blue }
                hl["RainbowOrange"] = { blend = 0, fg = C.peach }
                hl["RainbowGreen"] = { blend = 0, fg = C.green }
                hl["RainbowViolet"] = { blend = 0, fg = C.mauve }
                hl["RainbowCyan"] = { blend = 0, fg = C.teal }
                local scopehl = {
                    link = "CursorLine"
                    -- bg = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false, create = false }).bg,
                    -- underline = false
                }

                for i = 1, 7, 1 do
                    hl["@ibl.scope.underline." .. i] = scopehl
                end

                for group, opt in pairs(hl) do
                    vim.api.nvim_set_hl(0, group, opt)
                end
            end)
            require("ibl").setup(opts)

            -- dofile(vim.g.base46_cache .. "blankline")
        end,
    },
    {
        "catppuccin/nvim",
        optional = true,
        opts = {
            integrations = {
                indent_blankline = {
                    enabled = false,
                    scope_color = "overlay2", -- catppuccin color (eg. `lavender`) Default: text
                    colored_indent_levels = true,
                },
            },
        }
    }
}
