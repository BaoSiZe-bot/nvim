return {
    -- copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "BufReadPost",
        opts = {
            suggestion = {
                enabled = false,
                auto_trigger = true,
                hide_during_completion = true,
                keymap = {
                    accept = false, -- handled by nvim-cmp / blink.cmp
                    next = "<M-]>",
                    prev = "<M-[>",
                },
            },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },
    {
        -- copilot cmp source
        {
            "hrsh7th/nvim-cmp",
            optional = true,
            dependencies = { -- this will only be evaluated if nvim-cmp is enabled
                {
                    "zbirenbaum/copilot-cmp",
                    event = "VeryLazy",
                    opts = {},
                    specs = {
                        {
                            "hrsh7th/nvim-cmp",
                            optional = true,
                            opts = function(_, opts)
                                table.insert(opts.sources, 1, {
                                    name = "copilot",
                                    group_index = 1,
                                    priority = 100,
                                })
                            end,
                        },
                    },
                },
            },
        },
        {
            "saghen/blink.cmp",
            optional = true,
            dependencies = { "giuxtaposition/blink-cmp-copilot" },
            opts = {
                sources = {
                    default = { "copilot" },
                    providers = {
                        copilot = {
                            name = "copilot",
                            module = "blink-cmp-copilot",
                            transform_items = function(_, items)
                                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                                local kind_idx = #CompletionItemKind + 1
                                CompletionItemKind[kind_idx] = "Copilot"
                                for _, item in ipairs(items) do
                                    item.kind = kind_idx
                                end
                                return items
                            end,
                            score_offset = 100,
                            async = true,
                        },
                    },
                },
            },
        },
    }
}
