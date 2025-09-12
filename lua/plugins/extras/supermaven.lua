return {
    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        cmd = {
            "SupermavenUseFree",
            "SupermavenUsePro",
        },
        opts = {
            keymaps = {
                accept_suggestion = nil, -- handled by nvim-cmp / blink.cmp
            },
            disable_inline_completion = true,
            ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
        },
    },

    {
        "saghen/blink.cmp",
        optional = true,
        dependencies = { "supermaven-nvim", "saghen/blink.compat" },
        opts = {
            sources = {
                -- compat = { "supermaven" },
                providers = {
                    supermaven = {
                        name = "supermaven",
                        module = 'blink.compat.source',
                        transform_items = function(_, items)
                            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = "Supermaven"
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

    {
        "folke/noice.nvim",
        optional = true,
        opts = function(_, opts)
            vim.list_extend(opts.routes, {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "Starting Supermaven" },
                            { find = "Supermaven Free Tier" },
                        },
                    },
                    skip = true,
                },
            })
        end,
    },
}
