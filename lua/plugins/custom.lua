return {
    {
        "ray-x/navigator.lua",
        event = "LspAttach",
        dependencies = {
            {
                "ray-x/guihua.lua",
                event = "LspAttach",
                build = "cd lua/fzy && make",
                opts = {},
                config = function(_, opts)
                    require("guihua.maps").setup()
                end,
            },
        },
        opts = {
            default_mapping = false,
            lsp = {
                format_on_save = false,
                code_action = { virtual_text = false },
                code_lens_action = { virtual_text = false },
                format_options = { async = true },
                disable_format_cap = { "sqlls", "stylua" },
                disable_lsp = { "ccls", "pyright" },
                diagnostic = {
                    virtual_text = false,
                    update_in_insert = true,
                    float = {
                        prefix = "󰃤",
                    },
                },
                clangd = {
                    cmd = {
                        "clangd",
                        "-j=12",
                        "--completion-style=detailed",
                        "--background-index",
                        "--suggest-missing-includes",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--enable-config",
                        "--offset-encoding=utf-16",
                        "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
                    },
                },
                diagnostic_scrollbar_sign = false,
                diagnostic_virtual_text = false,
                diagnostic_update_in_insert = true,
                display_diagnostic_qf = false,
                servers = { "lua_ls", "clangd", "jsonls", "pylsp", "ruff" },
            },
            icons = {
                code_action_icon = '',

                -- Code Lens (gutter, floating window)
                code_lens_action_icon = '',

                -- Diagnostics (gutter)
                diagnostic_head = '', -- prefix for other diagnostic_* icons
                diagnostic_err = '',
                diagnostic_warn = '',
                diagnostic_info = [[]],
                diagnostic_hint = [[]],

                -- Diagnostics (floating window)
                diagnostic_head_severity_1 = '',
                diagnostic_head_severity_2 = '',
                diagnostic_head_severity_3 = '',
                diagnostic_head_description = '', -- suffix for severities
                diagnostic_virtual_text = '',     -- floating text preview (set to empty to disable)
                diagnostic_file = '',             -- icon in floating window, indicates the file contains diagnostics

                -- Values (floating window)
                value_definition = '',  -- identifier defined
                value_changed = '',     -- identifier modified
                context_separator = '', -- separator between text and value

                -- Formatting for Side Panel
                side_panel = {
                    section_separator = '󰇜',
                    line_num_left = '',
                    line_num_right = '',
                    inner_node = '├○',
                    outer_node = '╰○',
                    bracket_left = '⟪',
                    bracket_right = '⟫',
                    tab = '󰌒',
                },
                fold = {
                    prefix = '⚡',
                    separator = '',
                },

                -- Treesitter
                -- Note: many more node.type or kind may be available
                match_kinds = {
                    var = ' ', -- variable -- "👹", -- Vampaire
                    const = '󱀍 ',
                    method = 'ƒ ', -- method --  "🍔", -- mac
                    -- function is a keyword so wrap in ['key'] syntax
                    ['function'] = '󰡱 ', -- function -- "🤣", -- Fun
                    parameter = '  ', -- param/arg -- Pi
                    parameters = '  ', -- param/arg -- Pi
                    required_parameter = '  ', -- param/arg -- Pi
                    associated = '󰁕', -- linked/related
                    namespace = '', -- namespace
                    type = '󰉿', -- type definition
                    field = '', -- field definition
                    module = '', -- module
                    flag = '󰏿', -- flag
                },
                treesitter_defult = '', -- default symbol when unknown node.type or kind
                doc_symbols = '', -- document
            },
        },
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            vim.cmd([[command! Magit Neogit]])
            require("neogit").setup({})
        end,
        cmd = { "Neogit" },
    },
    {
        url = "https://gitee.com/BesterBigWei/rainbow-delimiters.nvim",
        event = "LazyFile",
        config = function()
            local rainbow_delimiters = require("rainbow-delimiters")

            vim.g.rainbow_delimiters = {
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
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterViolet",
                    "RainbowDelimiterCyan",
                    "RainbowDelimiterRed",
                    "RainbowDelimiterYellow",
                },
            }
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        opts = function()
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)
            return {
                indent = {
                    char = "│",
                    tab_char = "│",
                    highlight = highlight,
                },
                scope = { enabled = false },
                exclude = {
                    filetypes = {
                        "help",
                        "alpha",
                        "dashboard",
                        "neo-tree",
                        "Trouble",
                        "trouble",
                        "lazy",
                        "mason",
                        "notify",
                        "toggleterm",
                        "lazyterm",
                    },
                },
            }
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        event = "LazyFile",
        dependencies = { "mason.nvim" },
        init = function()
            LazyVim.on_very_lazy(function()
                LazyVim.format.register({
                    name = "none-ls.nvim",
                    priority = 200,
                    primary = true,
                    format = function(buf)
                        return LazyVim.lsp.format({
                            bufnr = buf,
                            filter = function(client)
                                return client.name == "null-ls"
                            end,
                        })
                    end,
                    sources = function(buf)
                        local ret = require("null-ls.sources").get_available(vim.bo[buf].filetype, "NULL_LS_FORMATTING") or
                            {}
                        return vim.tbl_map(function(source)
                            return source.name
                        end, ret)
                    end,
                })
            end)
        end,
        config = function()
            require("null-ls").setup({
                sources = {
                    require("null-ls.builtins.diagnostics.cppcheck").with({
                        args = {
                            "--enable=warning,performance,portability,unusedFunction",
                            "--std=c++2c",
                            "--language=c++",
                            "--check-level=exhaustive",
                            "$FILENAME",
                        },
                    }),
                },
            })
        end,
    },
    {
        "winston0410/range-highlight.nvim",
        dependencies = "winston0410/cmd-parser.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "yioneko/nvim-cmp",
        priority = 10000,
        branch = "perf",
        event = "InsertEnter",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "nvimdev/lspsaga.nvim",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()
            require("lspsaga").setup({})
            local kind_icons = {
                Array = "",
                Boolean = "󰨙",
                Class = "",
                Codeium = "󰘦",
                Color = "",
                Control = "",
                Collapsed = "",
                Constant = "󰏿",
                Constructor = "",
                Copilot = "",
                Enum = "",
                EnumMember = "",
                Event = "",
                Field = "",
                File = "",
                Folder = "",
                Function = "󰊕",
                Interface = "",
                Key = "",
                Method = "󰊕",
                Keyword = "",
                Module = "",
                Namespace = "󰦮",
                Null = "",
                Number = "󰎠",
                Object = "",
                Operator = "",
                Package = "",
                Property = "",
                Reference = "",
                Snippet = "",
                String = "",
                Struct = "󰆼",
                TabNine = "󰏚",
                Text = "",
                TypeParameter = "",
                Unit = "",
                Value = "",
                Variable = "󰀫",
            }
            local cmp = require("cmp")
            local compare = require("cmp.config.compare")

            local formatting_style = {
                fields = { "kind", "abbr", "menu" },
                format = function(_, item)
                    item.kind = kind_icons[item.kind]
                    return item
                end,
            }
            local WIDE_HEIGHT = 20
            local function border(hl_name)
                return {
                    { "╭", hl_name },
                    { "─", hl_name },
                    { "╮", hl_name },
                    { "│", hl_name },
                    { "╯", hl_name },
                    { "─", hl_name },
                    { "╰", hl_name },
                    { "│", hl_name },
                }
            end
            local select_next_item = function(option)
                return function(fallback)
                    if not require("cmp").select_next_item(option) then
                        local release = require("cmp").core:suspend()
                        fallback()
                        vim.schedule(release)
                    end
                end
            end
            local select_prev_item = function(option)
                return function(fallback)
                    if not require("cmp").select_prev_item(option) then
                        local release = require("cmp").core:suspend()
                        fallback()
                        vim.schedule(release)
                    end
                end
            end
            local abort = function()
                return function(fallback)
                    if not require("cmp").abort() then
                        fallback()
                    end
                end
            end
            local types = require("cmp.types")
            cmp.setup({
                matching = {
                    disallow_fuzzy_matching = true,
                    disallow_fullfuzzy_matching = false,
                    disallow_partial_fuzzy_matching = false,
                    disallow_partial_matching = false,
                    disallow_prefix_unmatching = false,
                    disallow_symbol_nonprefix_matching = false,
                },
                performance = {
                    debounce = 0,
                    throttle = 0,
                    fetching_timeout = 0,
                    confirm_resolve_timeout = 0,
                    async_budget = 1,
                    max_view_entries = 500,
                },
                mapping = {
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<cr>"] = LazyVim.cmp.confirm({ select = true }),
                    ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
                    ["<C-f>"] = {
                        i = select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
                    },
                    ["<C-b>"] = {
                        i = select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
                    },
                    ["<C-e>"] = {
                        i = abort(),
                    },
                },
                auto_brackets = {},
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                preselect = cmp.PreselectMode.Item,
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
                formatting = formatting_style,
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "snippets" },
                    { name = "git" },
                }),
                window = {
                    completion = {
                        side_padding = 1,
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
                        winblend = vim.o.pumblend,
                        scrolloff = 0,
                        col_offset = 0,
                        border = border("CmpBorder"),
                        scrollbar = true,
                    },
                    documentation = {
                        max_height = math.floor((WIDE_HEIGHT * 2) * (WIDE_HEIGHT / vim.o.lines)),
                        max_width = math.floor((WIDE_HEIGHT) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 8))),
                        border = border("CmpDocBorder"),
                        winhighlight = "FloatBorder:NormalFloat",
                        winblend = vim.o.pumblend,
                    },
                },
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        compare.sort_text,
                        compare.offset,
                        compare.exact,
                        compare.scopes,
                        compare.score,
                        compare.recently_used,
                        compare.locality,
                        compare.kind,
                        compare.length,
                        compare.order,
                    },
                },
            })
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "cmp_git" },
                    { name = "buffer" },
                }),
            })
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline" },
                }),
            })
            local function setup_rime()
                vim.g.rime_enabled = false
                local function rime_status()
                    if vim.g.rime_enabled then
                        return "ㄓ"
                    else
                        return ""
                    end
                end
                require("lualine").setup({
                    sections = {
                        lualine_x = {
                            rime_status,
                            {
                                function()
                                    return require("noice").api.status.command.get()
                                end,
                                cond = function()
                                    return package.loaded["noice"] and require("noice").api.status.command.has()
                                end,
                                color = function()
                                    return LazyVim.ui.fg("Statement")
                                end,
                            },
                            {
                                function()
                                    return require("noice").api.status.mode.get()
                                end,
                                cond = function()
                                    return package.loaded["noice"] and require("noice").api.status.mode.has()
                                end,
                                color = function()
                                    return LazyVim.ui.fg("Constant")
                                end,
                            },
                            {
                                function()
                                    return "  " .. require("dap").status()
                                end,
                                cond = function()
                                    return package.loaded["dap"] and require("dap").status() ~= ""
                                end,
                                color = function()
                                    return LazyVim.ui.fg("Debug")
                                end,
                            },
                            {
                                require("lazy.status").updates,
                                cond = require("lazy.status").has_updates,
                                color = function()
                                    return LazyVim.ui.fg("Special")
                                end,
                            },
                            {
                                "diff",
                                source = function()
                                    local gitsigns = vim.b.gitsigns_status_dict
                                    if gitsigns then
                                        return {
                                            added = gitsigns.added,
                                            modified = gitsigns.changed,
                                            removed = gitsigns.removed,
                                        }
                                    end
                                end,
                            },
                        },
                    },
                })
                local lspconfig = require("lspconfig")
                local configs = require("lspconfig.configs")
                if not configs.rime_ls then
                    configs.rime_ls = {
                        default_config = {
                            name = "rime_ls",
                            cmd = { "rime_ls" },
                            filetypes = { "*" },
                            single_file_support = true,
                        },
                        settings = {},
                        docs = {
                            description = [[
            https://www.github.com/wlh320/rime-ls
            A language server for librime
            ]],
                        },
                    }
                end
                local rime_on_attach = function(client, _)
                    local toggle_rime = function()
                        client.request("workspace/executeCommand", { command = "rime-ls.toggle-rime" },
                            function(_, result, ctx, _)
                                if ctx.client_id == client.id then
                                    vim.g.rime_enabled = result
                                end
                            end)
                    end
                    vim.keymap.set("n", "<leader>ri", function()
                        toggle_rime()
                    end, { desc = "toggle rime" })
                    vim.keymap.set("i", "<C-x>", function()
                        toggle_rime()
                    end, { desc = "toggle rime" })
                    vim.keymap.set("n", "<leader>rs", function()
                        vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" })
                    end, { desc = "sync user data." })
                end
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
                lspconfig.rime_ls.setup({
                    init_options = {
                        enabled = vim.g.rime_enabled,
                        shared_data_dir = "/usr/share/rime-data",
                        user_data_dir = "~/.local/share/rime-ls",
                        log_dir = "~/.local/share/rime-ls",
                        max_candidates = 9,
                        trigger_characters = {},
                        schema_trigger_character = "&",
                    },
                    on_attach = rime_on_attach,
                    capabilities = capabilities,
                })
            end
            setup_rime()
        end,
    },
    {
        "p00f/clangd_extensions.nvim",
        lazy = true,
        config = function() end,
        opts = {
            inlay_hints = {
                inline = true,
            },
            server = {
                on_attach = function(client, bufnr)
                    require("navigator.lspclient.mapping").setup({ client = client, bufnr = bufnr })
                    require("navigator.dochighlight").documentHighlight(bufnr)
                    require("navigator.codeAction").code_action_prompt(bufnr)
                end,
            },
        },
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "LspAttach",
        config = function()
            require("lsp_lines").setup()
            vim.diagnostic.config({
                virtual_text = false,
            })
        end,
    },
    {
        "soulis-1256/eagle.nvim",
        event = "LspAttach",
        opts = {},
    },
    {
        "folke/noice.nvim",
        opts = {
            lsp = {
                signature = {
                    enabled = false,
                },
                hover = { enabled = false },
            },
        },
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "LspAttach",
        opts = {},
    },
    {
        url = "https://ghp.ci/github.com/xeluxee/competitest.nvim",
        cmd = "CompetiTest",
        opts = {},
    },
    { "kevinhwang91/nvim-bqf",         ft = "qf" },
    {
        "stevearc/overseer.nvim",
        opts = {
            templates = {
                "builtin",
                "user.cpp_build",
                "user.file_runner",
                "user.python",
                "user.igcc",
                "user.trans_shell",
                "user.paru",
            },
            strategy = {
                "toggleterm",
                use_shell = false,
                direction = nil,
                highlights = nil,
                auto_scroll = nil,
                close_on_exit = false,
                quit_on_exit = "never",
                open_on_start = true,
                hidden = false,
                on_create = nil,
            },
        },
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = { "ToggleTerm" },
        opts = {},
    },
    {
        "folke/edgy.nvim",
        opts = function()
            local opts = {
                bottom = {
                    {
                        ft = "toggleterm",
                        size = { height = 0.4 },
                    },
                    {
                        ft = "noice",
                        size = { height = 0.4 },
                        filter = function(buf, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    {
                        ft = "lazyterm",
                        title = "LazyTerm",
                        size = { height = 0.4 },
                        filter = function(buf)
                            return not vim.b[buf].lazyterm_cmd
                        end,
                    },
                    "Trouble",
                    { ft = "qf",                title = "QuickFix" },
                    {
                        ft = "help",
                        size = { height = 20 },

                        filter = function(buf)
                            return vim.bo[buf].buftype == "help"
                        end,
                    },
                    { title = "Spectre",        ft = "spectre_panel",        size = { height = 0.4 } },
                    { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
                },
                left = {
                    { title = "Neotest Summary", ft = "neotest-summary" },
                },
                right = {
                    { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
                },
                keys = {
                    ["<c-Right>"] = function(win)
                        win:resize("width", 2)
                    end,
                    ["<c-Left>"] = function(win)
                        win:resize("width", -2)
                    end,
                    ["<c-Up>"] = function(win)
                        win:resize("height", 2)
                    end,
                    ["<c-Down>"] = function(win)
                        win:resize("height", -2)
                    end,
                },
            }

            if LazyVim.has("neo-tree.nvim") then
                local pos = {
                    filesystem = "left",
                    buffers = "top",
                    git_status = "right",
                    document_symbols = "bottom",
                    diagnostics = "bottom",
                }
                local sources = LazyVim.opts("neo-tree.nvim").sources or {}
                for i, v in ipairs(sources) do
                    table.insert(opts.left, i, {
                        title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
                        ft = "neo-tree",
                        filter = function(buf)
                            return vim.b[buf].neo_tree_source == v
                        end,
                        pinned = false,
                        open = function()
                            vim.cmd(("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, LazyVim.root()))
                        end,
                    })
                end
            end

            for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
                opts[pos] = opts[pos] or {}
                table.insert(opts[pos], {
                    ft = "trouble",
                    filter = function(_buf, win)
                        return vim.w[win].trouble
                            and vim.w[win].trouble.position == pos
                            and vim.w[win].trouble.type == "split"
                            and vim.w[win].trouble.relative == "editor"
                            and not vim.w[win].trouble_preview
                    end,
                })
            end
            return opts
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = "LazyFile",
        dependencies = {
            "mason.nvim",
            { "williamboman/mason-lspconfig.nvim", config = function() end },
        },
        opts = function()
            ---@class PluginLspOpts
            local ret = {
                -- options for vim.diagnostic.config()
                ---@type vim.diagnostic.Opts
                diagnostics = {
                    underline = true,
                    update_in_insert = true,
                    virtual_text = false,
                    severity_sort = true,
                },
                -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
                -- Be aware that you also will need to properly configure your LSP server to
                -- provide the inlay hints.
                inlay_hints = {
                    enabled = true,
                    exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
                },
                -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
                -- Be aware that you also will need to properly configure your LSP server to
                -- provide the code lenses.
                codelens = {
                    enabled = false,
                },
                -- Enable lsp cursor word highlighting
                document_highlight = {
                    enabled = true,
                },
                -- add any global capabilities here
                capabilities = {
                    workspace = {
                        fileOperations = {
                            didRename = true,
                            willRename = true,
                        },
                    },
                },
                -- options for vim.lsp.buf.format
                -- `bufnr` and `filter` is handled by the LazyVim formatter,
                -- but can be also overridden when specified
                format = {
                    formatting_options = nil,
                    timeout_ms = nil,
                },
                -- LSP Server Settings
                ---@type lspconfig.options
                servers = {
                    clangd = { mason = false },
                    marksman = { mason = false },
                    lua_ls = {
                        mason = false, -- set to false if you don't want this server to be installed with mason
                        -- Use this to add any additional keymaps
                        -- for specific lsp servers
                        -- ---@type LazyKeysSpec[]
                        -- keys = {},
                        settings = {
                            Lua = {
                                workspace = {
                                    checkThirdParty = false,
                                },
                                codeLens = {
                                    enable = true,
                                },
                                completion = {
                                    callSnippet = "Replace",
                                },
                                doc = {
                                    privateName = { "^_" },
                                },
                                hint = {
                                    enable = true,
                                    setType = false,
                                    paramType = true,
                                    paramName = "Disable",
                                    semicolon = "Disable",
                                    arrayIndex = "Disable",
                                },
                            },
                        },
                    },
                },
                -- you can do any additional lsp server setup here
                -- return true if you don't want this server to be setup with lspconfig
                ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
                setup = {
                    -- example to setup with typescript.nvim
                    -- tsserver = function(_, opts)
                    --   require("typescript").setup({ server = opts })
                    --   return true
                    -- end,
                    -- Specify * to use this function as a fallback for any server
                    -- ["*"] = function(server, opts) end,
                },
            }
            return ret
        end,
        ---@param opts PluginLspOpts
        config = function(_, opts)
            -- setup autoformat

            -- setup keymaps
            LazyVim.lsp.on_attach(function(client, buffer)
                require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
            end)

            LazyVim.lsp.setup()
            LazyVim.lsp.on_dynamic_capability(require("lazyvim.plugins.lsp.keymaps").on_attach)

            LazyVim.lsp.words.setup(opts.document_highlight)

            -- diagnostics signs
            if vim.fn.has("nvim-0.10") == 1 then
                -- inlay hints
                if opts.inlay_hints.enabled then
                    LazyVim.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
                        if
                            vim.api.nvim_buf_is_valid(buffer)
                            and vim.bo[buffer].buftype == ""
                            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
                        then
                            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
                        end
                    end)
                end

                -- code lens
                if opts.codelens.enabled and vim.lsp.codelens then
                    LazyVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                            buffer = buffer,
                            callback = vim.lsp.codelens.refresh,
                        })
                    end)
                end
            end

            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
            local servers = opts.servers
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                opts.capabilities or {}
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})
                if server_opts.enabled == false then
                    return
                end

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available through mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    if server_opts.enabled ~= false then
                        -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                        if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                            setup(server)
                        else
                            ensure_installed[#ensure_installed + 1] = server
                        end
                    end
                end
            end

            if have_mason then
                mlsp.setup({
                    ensure_installed = vim.tbl_deep_extend(
                        "force",
                        ensure_installed,
                        LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}
                    ),
                    handlers = { setup },
                })
            end

            if LazyVim.lsp.is_enabled("denols") and LazyVim.lsp.is_enabled("vtsls") then
                local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
                LazyVim.lsp.disable("vtsls", is_deno)
                LazyVim.lsp.disable("denols", function(root_dir, config)
                    if not is_deno(root_dir) then
                        config.settings.deno.enable = false
                    end
                    return false
                end)
            end
        end,
    },

    {
        "nvim-neorg/neorg",
        version = "*",
        ft = "norg",
        cmd = "Neorg",
        opts = {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.ui"] = {},
            },
        },
    },
    {
        "lambdalisue/vim-suda",
        cmd = { "SudaRead", "SudaWrite" },
    },
    {
        "chrisgrieser/nvim-spider",
        keys = {
            {
                "e",
                function()
                    require("spider").motion("e")
                end,
                mode = { "n", "x" },
            },
            {
                "w",
                function()
                    require("spider").motion("w")
                end,
                mode = { "n", "x" },
            },
            {
                "b",
                function()
                    require("spider").motion("b")
                end,
                mode = { "n", "x" },
            },
        },
    },
    {
        url = "https://ghp.ci/github.com/mikavilpas/yazi.nvim",
        keys = {

            {
                "<leader>fy",
                function()
                    require("yazi").yazi()
                end,
                desc = "Open the file manager",
            },
            {

                "<leader>fY",
                function()
                    require("yazi").yazi(nil, vim.fn.getcwd())
                end,
                desc = "Open the file manager in nvim's working directory",
            },
            {
                "<c-up>",
                function()
                    require("yazi").toggle()
                end,
                desc = "Resume the last yazi session",
            },
        },
        opts = {
            open_for_directories = true,
        },
    },
    { "mateuszwieloch/automkdir.nvim", event = "BufWrite" },

    {
        url = "https://ghp.ci/github.com/sontungexpt/url-open",
        branch = "mini",
        cmd = "URLOpenUnderCursor",
        keys = {
            { "gx", "<cmd>URLOpenUnderCursor<cr>", { desc = "open url under cursor" } },
        },
        config = function()
            local status_ok, url_open = pcall(require, "url-open")
            if not status_ok then
                return
            end
            url_open.setup({})
        end,
    },
    {
        "kosayoda/nvim-lightbulb",
        event = "LspAttach",
        opts = {
            autocmd = { enabled = true },
        },
    },
    {
        "luukvbaal/statuscol.nvim",
        event = "LazyFile",
        config = function()
            require("statuscol").setup({})
        end,
    },
    { "dstein64/nvim-scrollview",           event = "LazyFile", opts = {} },
    { "MeanderingProgrammer/markdown.nvim", enabled = false },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            file_types = { "markdown", "norg", "org" },
            code = {
                sign = false,
                width = "block",
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
            },
        },
        ft = { "markdown", "norg", "org" },
        config = function(_, opts)
            require("render-markdown").setup(opts)
            LazyVim.toggle.map("<leader>um", {
                name = "Render Markdown",
                get = function()
                    return require("render-markdown.state").enabled
                end,
                set = function(enabled)
                    local m = require("render-markdown")
                    if enabled then
                        m.enable()
                    else
                        m.disable()
                    end
                end,
            })
        end,
    },
    {
        "Isrothy/neominimap.nvim",
        version = "v3.*.*",
        enabled = true,
        lazy = false,
        init = function()
            vim.opt.wrap = false
            vim.opt.sidescrolloff = 36
            ---@type Neominimap.UserConfig
            vim.g.neominimap = {
                auto_enable = true,
            }
        end,
        opts = { float = { minimap_width = 10 } },
    },

    {
        "v1nh1shungry/cppman.nvim",
        dependencies = "nvim-telescope/telescope.nvim",
        opts = { position = "vsplit" },
    },
    {
        "jvgrootveld/telescope-zoxide",
        keys = {
            {
                "<Space>z",
                function()
                    require("telescope").extensions.zoxide.list()
                end,
                mode = { "n" },
            },
        },
        config = function()
            local t = require("telescope")
            local z_utils = require("telescope._extensions.zoxide.utils")
            t.setup({
                extensions = {
                    zoxide = {
                        prompt_title = "[ Walking on the shoulders of TJ ]",
                        mappings = {
                            default = {
                                after_action = function(selection)
                                    print("Update to (" .. selection.z_score .. ") " .. selection.path)
                                end,
                            },
                            ["<C-s>"] = {
                                before_action = function(selection)
                                    print("before C-s")
                                end,
                                action = function(selection)
                                    vim.cmd.edit(selection.path)
                                end,
                            },
                            ["<C-q>"] = { action = z_utils.create_basic_command("split") },
                        },
                    },
                },
            })
            t.load_extension("zoxide")
        end,
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
    },
    {
        'SCJangra/table-nvim',
        ft = 'markdown',
        opts = {},
    }
}
