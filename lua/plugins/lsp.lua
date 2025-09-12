
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
local utils = require("configs.utils")
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
        },
        event = "InsertEnter",
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
                    kind_icons = vim.tbl_extend("force", {}, utils.icons.kinds)
                },
                completion = {
                    accept = {
                        auto_brackets = {
                            enabled = true,
                        },
                    },
                    menu = {
                        -- border = "rounded",
                        enabled = true,
                        winhighlight =
                        "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
                        auto_show = true,
                        draw = {
                            treesitter = { "lsp" },
                            columns = { { "kind_icon" }, { "label", gap = 1 } },
                            components = {
                                label = {
                                    text = function(ctx)
                                        return require("colorful-menu").blink_components_text(ctx)
                                    end,
                                    highlight = function(ctx)
                                        return require("colorful-menu").blink_components_highlight(ctx)
                                    end,
                                },
                                kind_icon = {
                                    ellipsis = false,
                                    -- text = function(ctx)
                                    --     local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                    --     return kind_icon
                                    -- end,
                                }
                            },
                        },
                    },
                    keyword = {
                        range = "prefix",
                        -- regex = "[_,:\\?!]\\|[A-Za-z0-9]",
                    },
                    list = {
                        selection = {
                            preselect = true,
                            auto_insert = true,
                        },
                    },
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 20,
                        -- window = {
                        --     border = "rounded",
                        -- }
                    },
                    ghost_text = {
                        enabled = true,
                    },
                },
                -- signature = { enabled = true }, -- have other plugin instead.
                sources = {
                    default = { "lsp", "path", "snippets", "buffer", "markdown", "minuet" },
                    providers = {
                        lsp = {
                            enabled = true,
                            transform_items = function(_, items)
                                for _, item in ipairs(items) do
                                    if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                                        item.score_offset = item.score_offset - 3
                                    end
                                    if
                                        item.kind == require("blink.cmp.types").CompletionItemKind.Text
                                        and item.source_id == "lsp"
                                        and vim.lsp.get_client_by_id(item.client_id).name == "rime_ls"
                                    then
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
                },
                term = {
                    enabled = true,
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
    {
        "xzbdmw/colorful-menu.nvim",
        opts = {}
    },
    {
        "neovim/nvim-lspconfig",
        event = "LazyFile",
        config = function()
            require("configs.lspconfig")
        end,
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
        lazy = false,
        -- event = "LazyFile",
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
                use_icons_from_diagnostic = false,
                multiple_diag_under_cursor = true,
                multilines = {
                    enabled = true,
                    always_show = false,
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
                end
            }
        },
        config = function(_, opts)
            vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
            require("tiny-inline-diagnostic").setup(opts)
            vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
        end,
    },
    {
        "VidocqH/lsp-lens.nvim",
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
            always_incomplete = false,
            schema_trigger_character = "&",
            cmp_keymaps = {
                disable = {
                    space = false,
                    numbers = false,
                    enter = false,
                    brackets = false,
                    backspace = false,
                },
            },
        },
        init = function()
            vim.system({
                "rime_ls",
                "--listen",
                "127.0.0.1:9257",
            }, { detach = true })
        end,
        config = function(_, opts)
            require("rimels").setup(opts)
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
        event = "LazyFile",
        opts = {
            autocmd = { enabled = true },
            float = { enabled = true },
            code_lenses = true,
        },
    },
}
