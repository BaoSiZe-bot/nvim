local include_in_completion = vim.g.lazyvim_mini_snippets_in_completion == nil
    or vim.g.lazyvim_mini_snippets_in_completion
local function cmpborder(symbol, type, neovide, highlight)
    symbol = symbol or "═"
    type = type or "top"
    neovide = neovide or false
    highlight = "MyBorder"

    if vim.fn.exists("g:neovide") == 1 and not neovide then
        return "none"
    end

    if type == "top" then
        return { '', { symbol, highlight }, '', '', '', '', '', '' }
    elseif type == "bottom" then
        return { '', '', '', '', '', { symbol, highlight }, '', '' }
    end
end
local function expand_from_lsp(snippet)
    local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
    insert({ body = snippet })
end

local function jump(direction)
    local is_active = MiniSnippets.session.get(false) ~= nil
    if is_active then
        MiniSnippets.session.jump(direction)
        return true
    end
end

---@type fun(snippets, insert) | nil
local expand_select_override = nil

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
    -- Native sessions don't support nested snippet sessions.
    -- Always use the top-level session.
    -- Otherwise, when on the first placeholder and selecting a new completion,
    -- the nested session will be used instead of the top-level session.
    local session = vim.snippet.active() and vim.snippet._session or nil

    local ok, _ = pcall(vim.snippet.expand, snippet)
    if not ok then
        local fixed = snippet_fix(snippet)
        ok = pcall(vim.snippet.expand, fixed)
    end

    -- Restore top-level session when needed
    if session then
        vim.snippet._session = session
    end
end

return {
    {
        "stevearc/conform.nvim",
        event = "LazyFile", -- uncomment for format on save
        keys = {
            {
                "<leader>cF",
                function()
                    require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
                end,
                mode = { "n", "v" },
                desc = "Format Injected Langs",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                cpp = { "clang_format" },
                -- css = { "prettier" },
                -- html = { "prettier" },
            },

            -- format_on_save = {
            --     -- These options will be passed to conform.format()
            --     timeout_ms = 10000000,
            --     lsp_format = "fallback",
            -- },
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
            presets = {
                bottom_search = true,
                --     command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
            },
        },
        -- stylua: ignore
        keys = {
            { "<leader>sn",  "",                                                                            desc = "+noice" },
            { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
            { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
            { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
            { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
            { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
            { "<leader>snt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
            { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
            { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
        },
        config = function(_, opts)
            -- HACK: noice shows messages from before it was enabled,
            -- but this is not ideal when Lazy is installing plugins,
            -- so clear the messages in this case.
            if vim.o.filetype == "lazy" then
                vim.cmd([[messages clear]])
            end
            require("noice").setup(opts)
        end,
    },
    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "Bekaboo/dropbar.nvim",
                event = "LazyFile",
                priority = 1000,
                -- optional, but required for fuzzy finder support
                opts = {
                    icons = {
                        kinds = {
                            symbols = {
                                Array = " ",
                                Boolean = "󰨙 ",
                                Class = " ",
                                Codeium = "󰘦 ",
                                Color = " ",
                                Control = " ",
                                Collapsed = " ",
                                Constant = "󰏿 ",
                                Constructor = " ",
                                Copilot = " ",
                                Enum = " ",
                                EnumMember = " ",
                                Event = " ",
                                Field = " ",
                                File = " ",
                                Folder = " ",
                                Function = "󰊕 ",
                                Interface = " ",
                                Key = " ",
                                Keyword = " ",
                                Method = "󰊕 ",
                                Module = " ",
                                Namespace = "󰦮 ",
                                Null = " ",
                                Number = "󰎠 ",
                                Object = " ",
                                Operator = " ",
                                Package = " ",
                                Property = " ",
                                Reference = " ",
                                Snippet = "󱄽 ",
                                String = " ",
                                Struct = "󰆼 ",
                                Supermaven = " ",
                                TabNine = "󰏚 ",
                                Text = " ",
                                TypeParameter = " ",
                                Unit = " ",
                                Value = " ",
                                Variable = "󰀫 ",
                            },
                        },
                    },
                },
                config = function(_, opts)
                    local dropbar_api = require("dropbar.api")
                    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
                    vim.keymap.set(
                        "n",
                        "[;",
                        dropbar_api.goto_context_start,
                        { desc = "Go to start of current context" }
                    )
                    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
                    require("dropbar").setup(opts)
                end,
            },
            -- main one
            {
                "saghen/blink.cmp",
                version = "*",
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
                    local border = cmpborder(" ", "bottom")
                    local config = {
                        snippets = {
                            expand = function(snippet, _)
                                return expand(snippet)
                            end,
                        },
                        appearance = {
                            -- sets the fallback highlight groups to nvim-cmp's highlight groups
                            -- useful for when your theme doesn't support blink.cmp
                            -- will be removed in a future release, assuming themes add support
                            use_nvim_cmp_as_default = false,
                            -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                            -- adjusts spacing to ensure icons are aligned
                            nerd_font_variant = "mono",
                            kind_icons = {
                                Text = "",
                            },
                        },
                        completion = {
                            accept = {
                                -- experimental auto-brackets support
                                auto_brackets = {
                                    enabled = true,
                                },
                            },
                            menu = {
                                border = border,
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
                                            text = function(ctx)
                                                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                                                return kind_icon
                                            end,
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
                                -- border = border,
                                auto_show = true,
                                auto_show_delay_ms = 20,
                            },
                            ghost_text = {
                                enabled = true,
                            },
                        },

                        -- experimental signature help support
                        -- signature = { enabled = true },

                        sources = {
                            -- adding any nvim-cmp sources here will enable them
                            -- with blink.compat
                            -- compat = {},
                            default = { "lsp", "path", "snippets", "buffer", "markdown" },
                            cmdline = {},
                            providers = {
                                lsp = {
                                    enabled = true,
                                    transform_items = function(_, items)
                                        -- the default transformer will do this
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
                                        -- you can define your own filter for rime item
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

                        keymap = {
                            preset = "enter",
                            ["<C-y>"] = { "select_and_accept" },
                        },
                    }
                    return vim.tbl_deep_extend("force", opts, config)
                end,
            },
            { -- "saghen/blink.compat"
                "saghen/blink.compat",
                lazy = true,
                opts = {},
            },
            { -- xzbdmw/colorful-menu.nvim
                "xzbdmw/colorful-menu.nvim",
                config = true,
            },
        },
        event = "LazyFile",
        config = function()
            require("configs.lspconfig")
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "vim",
                "lua",
                "vimdoc",
                "c",
                "cpp",
                "markdown",
                "markdown_inline",
            },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts_extend = { "spec" },
        opts = {
            preset = "helix",
            defaults = {},
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader><tab>", group = "tabs" },
                    { "<leader>c", group = "code" },
                    { "<leader>d", group = "debug" },
                    { "<leader>dp", group = "profiler" },
                    { "<leader>f", group = "file/find" },
                    { "<leader>g", group = "git" },
                    { "<leader>gh", group = "hunks" },
                    { "<leader>q", group = "quit/session" },
                    { "<leader>s", group = "search" },
                    { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
                    { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "gs", group = "surround" },
                    { "z", group = "fold" },
                    {
                        "<leader>b",
                        group = "buffer",
                        expand = function()
                            return require("which-key.extras").expand.buf()
                        end,
                    },
                    {
                        "<leader>w",
                        group = "windows",
                        proxy = "<c-w>",
                        expand = function()
                            return require("which-key.extras").expand.win()
                        end,
                    },
                    -- better descriptions
                    { "gx", desc = "Open with system app" },
                },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Keymaps (which-key)",
            },
            {
                "<c-w><space>",
                function()
                    require("which-key").show({ keys = "<c-w>", loop = true })
                end,
                desc = "Window Hydra Mode (which-key)",
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            if not vim.tbl_isempty(opts.defaults) then
                wk.register(opts.defaults)
            end
            require("which-key").add({
                { "<leader>a", group = "Full text", icon = "󰒆" },
                { "<leader>ac", "<cmd>%d_<CR>i", desc = "Edit", icon = "" },
                { "<leader>ak", "<cmd>%d<CR>", desc = "Cut", icon = "" },
                { "<leader>ad", "<cmd>%d_<CR>", desc = "Delete", icon = "" },
                { "<leader>as", "ggVG<C-g>", desc = "Select(Select mode)", icon = "󱟁" },
                { "<leader>av", "ggVG", desc = "Select(Visual mode)", icon = "󰒅" },
                { "<leader>ay", "<cmd>%y<CR>", desc = "Copy", icon = "" },
                { "<leader>t", group = "Test", icon = "󰙨" },
                { "<leader>td", "<cmd>Comp delete_testcase<CR>", desc = "Delete testcase", icon = "󰆴" },
                { "<leader>te", "<cmd>Comp edit_testcase<CR>", desc = "Edit testcase", icon = "" },
                { "<leader>tn", "<cmd>Comp add_testcase<CR>", desc = "New testcase", icon = "" },
                { "<leader>tr", group = "Receive", icon = "󱃚" },
                { "<leader>trc", "<cmd>Comp receive contest<CR>", desc = "Problems(Contest)", icon = " " },
                { "<leader>trp", "<cmd>Comp receive problem<CR>", desc = "Problem", icon = "" },
                { "<leader>trt", "<cmd>Comp receive testcases<CR>", desc = "Testcase", icon = "✔" },
                { "<leader>tt", "<cmd>Comp run<CR>", desc = "Run test", icon = "󰙨" },
                { "<leader>bn", "<cmd>bnext<cr>", desc = "Next buffer" },
                { "<leader>bp", "<cmd>bprevious<cr>", desc = "Prev Buffer" },
            })
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
        event = "LspAttach",
        priority = 1919810, -- needs to be loaded in first
        opts = {
            preset = "ghost",
            options = {
                virt_texts = {
                    -- Priority for virtual text display
                    priority = 8192,
                },
                show_source = true,
                use_icons_from_diagnostic = true,
                multiple_diag_under_cursor = true,
                multilines = {
                    -- Enable multiline diagnostic messages
                    enabled = true,
                    -- Always show messages on all lines for multiline diagnostics
                    always_show = true,
                },
                show_all_diags_on_cursorline = true,
                enable_on_insert = true,
                enable_on_select = true,
                break_line = {
                    -- Enable the feature to break messages after a specific length
                    enabled = true,
                    -- Number of characters after which to break the line
                    after = 80,
                },
            }
        },
        config = function(_, opts)
            require("tiny-inline-diagnostic").setup(opts)
            vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
        end,
    },
    {
        "aznhe21/actions-preview.nvim",
        event = "LspAttach",
        opts = function()
            local hl = require("actions-preview.highlight")
            return {
                diff = { algorithm = "patience", ignore_whitespace = true },
                highlight_command = {
                    hl.diff_so_fancy("/usr/bin/diff-so-fancy --option1 --option2"),
                },
            }
        end,
        config = function(_, opts)
            require("actions-preview").setup(opts)
            vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
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
        lazy = true,
        priority = 100,
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
    }
}
