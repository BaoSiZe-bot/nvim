return {

    -- codeium
    {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        event = "InsertEnter",
        build = ":Codeium Auth",
        opts = {
            enable_cmp_source = true,
            virtual_text = {
                enabled = false,
                key_bindings = {
                    accept = false, -- handled by nvim-cmp / blink.cmp
                    next = "<M-]>",
                    prev = "<M-[>",
                },
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        optional = true,
        dependencies = { "codeium.nvim" },
        opts = function(_, opts)
            table.insert(opts.sources, 1, {
                name = "codeium",
                group_index = 1,
                priority = 100,
            })
        end,
    },
    {
        "saghen/blink.cmp",
        optional = true,
        dependencies = { "codeium.nvim", "saghen/blink.compat" },
        opts = {
            sources = {
                providers = {
                    codeium = {
                        name = "codeium",
                        transform_items = function(_, items)
                            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = "Codeium"
                            for _, item in ipairs(items) do
                                item.kind = kind_idx
                            end
                            return items
                        end,
                        module = 'blink.compat.source',
                        score_offset = 100,
                        async = true,
                    },
                },
            },
        },
    },
}
