local function snippet_replace(snippet, fn)
    return snippet:gsub("%$%b{}", function(m)
        local n, name = m:match("^%${(%d+):(.+)}$")
        return n and fn({ n = n, text = name }) or m
    end) or snippet
end
local function snippet_preview(snippet)
    local ok, parsed = pcall(function()
        return vim.lsp._snippet_grammar.parse(snippet)
    end)
    return ok and tostring(parsed)
        or snippet_replace(snippet, function(placeholder)
            return snippet_preview(placeholder.text)
        end):gsub("%$0", "")
end
local function snippet_fix(snippet)
    local texts = {} ---@type table<number, string>
    return snippet_replace(snippet, function(placeholder)
        texts[placeholder.n] = texts[placeholder.n] or snippet_preview(placeholder.text)
        return "${" .. placeholder.n .. ":" .. texts[placeholder.n] .. "}"
    end)
end
local function expand(snippet)
    local ok, _ = pcall(vim.snippet.expand, snippet)
    if not ok then
        local fixed = snippet_fix(snippet)
        ok = pcall(vim.snippet.expand, fixed)
    end
end
return {
    {
        "lewis6991/hover.nvim",
        opts = {
            init = function()
                require("hover.providers.lsp")
            end,
        },
    },
    {
        "saghen/blink.cmp",
        build = "cargo build --release",
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.compat",
            "sources.default",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            {
                "windwp/nvim-autopairs",
                opts = {
                    fast_wrap = {},
                    disable_filetype = { "TelescopePrompt", "vim" },
                },
            },
        },
        event = { "LspAttach", "CmdlineEnter" },
        ---@module 'blink.cmp'
        opts = function(_, opts)
            local config = {
                snippets = {
                    expand = function(snippet, _)
                        return expand(snippet)
                    end,
                },
                appearance = {
                    use_nvim_cmp_as_default = false,
                    nerd_font_variant = "mono",
                },
                completion = {
                    accept = {
                        auto_brackets = {
                            enabled = true,
                        },
                    },
                    menu = {
                        border = "none",
                        -- border = "rounded",
                        -- enabled = true,
                        -- scrollbar = false
                        -- auto_show = true,
                        draw = {
                            treesitter = { "lsp" },
                            padding = { 0, 1 },
                            columns = { { "kind_icon" }, { "label" }, { "kind" } },
                            components = {
                                kind_icon = {
                                    text = function(ctx)
                                        local icons = vim.tbl_extend("force", {}, Abalone.icons.kinds)
                                        local icon = (icons[ctx.kind] or "󰈚")
                                        icon = " " .. icon .. " "
                                        return icon
                                    end,
                                },

                                kind = {
                                    highlight = function(ctx)
                                        return "comment"
                                    end,
                                },

                                label = {
                                    highlight = function(ctx)
                                        -- label and label details
                                        ctx.label = ctx.label .. ctx.label_detail
                                        ctx.label_detail = ""
                                        local label = ctx.label
                                        local highlights = {
                                            {
                                                0,
                                                #label,
                                                group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
                                            },
                                        }

                                        if
                                            vim.list_contains(ctx.self.treesitter, ctx.source_id) and not ctx.deprecated
                                        then
                                            -- add treesitter highlights
                                            vim.list_extend(
                                                highlights,
                                                require("blink.cmp.completion.windows.render.treesitter").highlight(ctx)
                                            )
                                        end

                                        -- characters matched on the label by the fuzzy matcher
                                        for _, idx in ipairs(ctx.label_matched_indices) do
                                            table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                                        end

                                        return highlights
                                    end,
                                    -- text = function(ctx)
                                    --     return require("colorful-menu").blink_components_text(ctx)
                                    -- end,
                                    -- highlight = function(ctx)
                                    --     return require("colorful-menu").blink_components_highlight(ctx)
                                    -- end,
                                },
                            },
                        },
                    },
                    -- keyword = {
                    --     range = "prefix",
                    --     regex = "[_,:\\?!]\\|[A-Za-z0-9]",
                    -- },
                    list = {
                        selection = {
                            preselect = true,
                            auto_insert = true,
                        },
                    },
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 200,
                        window = {
                            -- border = "single",
                        },
                    },
                    ghost_text = {
                        enabled = true,
                    },
                },
                -- signature = { enabled = true }, -- have other plugin instead.
                sources = {
                    default = {
                        "lsp",
                        "path",
                        "snippets",
                        "buffer",
                        "markdown" --[[, "minuet" -- ]],
                    },
                    providers = {
                        lsp = {
                            enabled = true,
                            transform_items = function(_, items)
                                for _, item in ipairs(items) do
                                    if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                                        item.score_offset = item.score_offset - 3
                                    end
                                end
                                return items
                            end,
                        },
                        markdown = {
                            name = "RenderMarkdown",
                            module = "render-markdown.integ.blink",
                            fallbacks = { "lsp" },
                        },
                    },
                },
                cmdline = {
                    enabled = true,
                    keymap = { preset = "cmdline" },
                    completion = {
                        list = { selection = { preselect = false } },
                        menu = {
                            auto_show = function(_)
                                return vim.fn.getcmdtype() == ":"
                            end,
                        },
                        ghost_text = { enabled = true },
                    },
                },
                term = {
                    enabled = true,
                    -- enabled = false,
                    keymap = { preset = "super-tab" }, -- Inherits from top level `keymap` config when not set
                    sources = {},
                    completion = {
                        trigger = {
                            show_on_blocked_trigger_characters = {},
                            show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
                        },
                        -- Inherits from top level config options when not set
                        list = {
                            selection = {
                                -- When `true`, will automatically select the first item in the completion list
                                preselect = true,
                                -- When `true`, inserts the completion item automatically when selecting it
                                auto_insert = true,
                            },
                        },
                        -- Whether to automatically show the window when new completion items are available
                        menu = { auto_show = true },
                        -- Displays a preview of the selected item on the current line
                        ghost_text = { enabled = true },
                    },
                },
                keymap = {
                    preset = "enter",
                    ["<C-y>"] = { "select_and_accept" },
                    -- ["<C-S-y>"] = require('minuet').make_blink_map(),
                },
            }
            return vim.tbl_deep_extend("force", opts, config)
        end,
    },
    {
        "saghen/blink.compat",
        opts = {},
    },
    -- {
    --     "xzbdmw/colorful-menu.nvim",
    --     opts = {
    --         ls = {
    --             clangd = {
    --                 -- import_dot_hl = "@comment",
    --             },
    --         },
    --     },
    -- },
    {
        "neovim/nvim-lspconfig",
        event = "User FilePost",
        config = vim.schedule_wrap(function(_, opts)
            require("configs.lsp")
            vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
        end),
    },
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        opts = {},
    },
    -- {
    --     "chikko80/error-lens.nvim",
    --     event = "LazyFile",
    --     opts = {}
    -- },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        -- lazy = false,
        event = "User FilePost",
        priority = 1919810, -- needs to be loaded in first
        opts = {
            preset = "modern",
            -- transparent_bg = true,
            -- transparent_cursorline = true, -- Set the background of the cursorline to transparent (only one the first diagnostic)
            options = {
                virt_texts = {
                    priority = 8192,
                },
                show_source = {
                    enabled = true,
                    if_many = true,
                },
                use_icons_from_diagnostic = true,
                multiple_diag_under_cursor = true,
                multilines = {
                    enabled = true,
                    always_show = true,
                },
                show_all_diags_on_cursorline = true,
                enable_on_insert = true,
                enable_on_select = true,
                break_line = {
                    enabled = true,
                    after = 80,
                },
                format = function(diagnostic)
                    return diagnostic.source .. ": " .. diagnostic.message
                end,
            },
        },
    },
    {
        "VidocqH/lsp-lens.nvim",
        enabled = false,
        opts = {},
        event = "LspAttach",
    },
    {
        "liubianshi/cmp-lsp-rimels",
        keys = { { "<localleader>f", mode = "i" } },
        branch = "blink.cmp",
        opts = {
            keys = { start = "<localleader>f", stop = "<localleader>;", esc = "<localleader>j" },
            cmd = vim.lsp.rpc.connect("127.0.0.1", 9257),
            -- schema_trigger_character = "&",
            -- cmp_keymaps = {
            --     disable = {
            --         space = false,
            --         numbers = false,
            --         enter = false,
            --         brackets = false,
            --         backspace = false,
            --     },
            -- },
        },
        config = function(_, opts)
            vim.system({
                "rime_ls",
                "--listen",
                "127.0.0.1:9257",
            }, { detach = true })
            require("rimels").setup(opts)
            vim.opt.iskeyword = "_,49-57,A-Z,a-z"
        end,
    },
    -- {
    --     "m-demare/hlargs.nvim",
    --     event = "LspAttach",
    --     opts = {},
    -- },
    {
        "soulis-1256/eagle.nvim",
        event = "LspAttach",
        opts = {},
    },
    {
        "Fildo7525/pretty_hover",
        event = "LspAttach",
        opts = {},
    },
    {
        "kosayoda/nvim-lightbulb",
        event = "LspAttach",
        opts = {
            autocmd = { enabled = true },
            float = {
                -- fucking border!
                enabled = false,
                text = " ",
                lens_text = " ",
            },
            status_text = {
                enabled = true,
                text = " ",
                lens_text = " ",
            },
            sign = {
                enabled = true,
                text = " ",
                lens_text = " ",
            },
            number = {
                enabled = true,
            },
            code_lenses = true,
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim",        words = { "Snacks" } },
                { path = "lazy.nvim",          words = { "Abalone" } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        opts = {
            sources = {
                per_filetype = {
                    lua = { inherit_defaults = true, "lazydev" },
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                },
            },
        },
    },
}
