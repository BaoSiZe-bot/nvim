return {
    {
        'milanglacier/minuet-ai.nvim',
        event = "LazyFile",
        config = function()
            require('minuet').setup {
                -- Your configuration options here
                -- provider = 'gemini',
                provider_options = {
                    gemini = {
                        model = 'gemini-2.0-flash',
                        stream = true,
                        api_key = 'GEMINI_API_KEY',
                        end_point = 'https://generativelanguage.googleapis.com/v1beta/models',
                        optional = {
                            generationConfig = {
                                maxOutputTokens = 8192,
                                thinkingConfig = {
                                    thinkingBudget = 0,
                                },
                            },
                            safetySettings = {
                                {
                                    -- HARM_CATEGORY_HATE_SPEECH,
                                    -- HARM_CATEGORY_HARASSMENT
                                    -- HARM_CATEGORY_SEXUALLY_EXPLICIT
                                    category = 'HARM_CATEGORY_DANGEROUS_CONTENT',
                                    -- BLOCK_NONE
                                    threshold = 'BLOCK_ONLY_HIGH',
                                },
                            },
                        },
                    },
                },
            }
        end,
    },

    {
        "saghen/blink.cmp",
        optional = true,
        dependencies = { "milanglacier/minuet-ai.nvim" },
        opts = {
            sources = {
                providers = {
                    minuet = {
                        name = "minuet",
                        module = "minuet.blink",
                        score_offset = 100,
                        async = true,
                        timeout_ms = 3000,
                        -- kind = require('blink.cmp.types').CompletionItemKind.Snippet, -- or Text, Function, etc.
                        -- kind_icon = '', -- pick a Nerd Font icon you like
                        -- icon = '', -- pick a Nerd Font icon you like
                    },
                },
            },
            completion = {
                    trigger = {
                        prefetch_on_insert = false
                    },
            },
            appearance = {
                kind_icons = {
                    minuet = '', -- will be used when source name is 'minuet'
                },
            },
        },
    },
}
