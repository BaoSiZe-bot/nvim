
return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
        },
        cmd = { "CodeCompanionChat", "CodeCompanion", "CodeCompanionCmd", "CodeCompanionActions" },
        event = "VeryLazy",
        opts = {
            strategies = {
                -- Change the default chat adapter
                chat = {
                    adapter = "gemini",
                },
                cmd = {
                    adapter = "gemini",
                },
                inline = {
                    adapter = "gemini",
                },
            },
            opts = {
                -- Set debug logging
                log_level = "DEBUG",
            },
            adapters = {
                copilot = function()
                    return require("codecompanion.adapters").extend("copilot", {
                        env = {
                            token = "",
                            api_key = ""
                        },
                    })
                end,
                gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        env = {
                            api_key = ""
                        },
                    })
                end,
                opts = {
                    allow_insecure = true,
                },
            },
        },
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            -- suggestion = { enabled = false },
            -- panel = { enabled = false },
            copilot_model = "gpt-4o-copilot",
            filetypes = {
                markdown = true,
                help = true,
            },
        },
    },
    {
        "saghen/blink.cmp",
        optional = true,
        dependencies = { "fang2hou/blink-copilot" },
        opts = {
            sources = {
                default = { "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
        },
    },
    {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        event = "InsertEnter",
        build = ":Codeium Auth",
        opts = {
            enable_cmp_source = true,
            tools = {
                language_server = "D:\\language_server.exe"
            },
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
        "saghen/blink.cmp",
        optional = true,
        dependencies = { "codeium.nvim", "saghen/blink.compat" },
        opts = {
            sources = {
                default = { "codeium" },
                providers = {
                    codeium = {
                        transform_items = function(_, items)
                            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = "Codeium"
                            for _, item in ipairs(items) do
                                item.kind = kind_idx
                            end
                            return items
                        end,
                        name = "codeium",
                        module = 'blink.compat.source',
                        score_offset = 100,
                        async = true,
                    },
                },
            },
        },
    },

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
                default = { "supermaven" },
                providers = {
                    supermaven = {
                        transform_items = function(_, items)
                            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = "Supermaven"
                            for _, item in ipairs(items) do
                                item.kind = kind_idx
                            end
                            return items
                        end,
                        name = "supermaven",
                        module = 'blink.compat.source',
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
