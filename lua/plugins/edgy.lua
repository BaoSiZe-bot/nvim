return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        keys = {
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = RootGet() })
                end,
                desc = "Explorer NeoTree (Root Dir)",
            },
            {
                "<leader>fE",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
            { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
            {
                "<leader>ge",
                function()
                    require("neo-tree.command").execute({ source = "git_status", toggle = true })
                end,
                desc = "Git Explorer",
            },
            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                desc = "Buffer Explorer",
            },
        },
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        init = function()
            -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
            -- because `cwd` is not set up properly.
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
                desc = "Start Neo-tree with directory",
                once = true,
                callback = function()
                    if package.loaded["neo-tree"] then
                        return
                    else
                        local stats = vim.uv.fs_stat(vim.fn.argv(0))
                        if stats and stats.type == "directory" then
                            require("neo-tree")
                        end
                    end
                end,
            })
        end,
        opts = {
            sources = { "filesystem", "buffers", "git_status" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
            },
            window = {
                mappings = {
                    ["l"] = "open",
                    ["h"] = "close_node",
                    ["<space>"] = "none",
                    ["Y"] = {
                        function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.setreg("+", path, "c")
                        end,
                        desc = "Copy Path to Clipboard",
                    },
                    ["O"] = {
                        function(state)
                            require("lazy.util").open(state.tree:get_node().path, { system = true })
                        end,
                        desc = "Open with System Application",
                    },
                    ["P"] = { "toggle_preview", config = { use_float = false } },
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                git_status = {
                    symbols = {
                        unstaged = "󰄱",
                        staged = "󰱒",
                    },
                },
            },
        },
        config = function(_, opts)
            local function on_move(data)
                require("snacks").rename.on_rename_file(data.source, data.destination)
            end

            local events = require("neo-tree.events")
            opts.event_handlers = opts.event_handlers or {}
            vim.list_extend(opts.event_handlers, {
                { event = events.FILE_MOVED, handler = on_move },
                { event = events.FILE_RENAMED, handler = on_move },
            })
            require("neo-tree").setup(opts)
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        optional = true,
        opts = function(_, opts)
            opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
                or { "terminal", "Trouble", "qf", "Outline", "trouble" }
            table.insert(opts.open_files_do_not_replace_types, "edgy")
        end,
    },
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>ue",
                function()
                    require("edgy").toggle()
                end,
                desc = "Edgy Toggle",
            },
            {
                "<leader>uE",
                function()
                    require("edgy").select()
                end,
                desc = "Edgy Select Window",
            },
        },
        opts = function()
            local opts = {
                bottom = {
                    {
                        ft = "toggleterm",
                        size = { height = 0.4 },
                        filter = function(buf, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    {
                        ft = "noice",
                        size = { height = 0.4 },
                        filter = function(buf, win)
                            return vim.api.nvim_win_get_config(win).relative == ""
                        end,
                    },
                    "Trouble",
                    { ft = "qf", title = "QuickFix" },
                    {
                        ft = "help",
                        size = { height = 20 },
                        -- don't open help files in edgy that we're editing
                        filter = function(buf)
                            return vim.bo[buf].buftype == "help"
                        end,
                    },
                    { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
                    { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
                },
                left = {
                    { title = "Neotest Summary", ft = "neotest-summary" },
                    -- "neo-tree",
                },
                right = {
                    { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
                },
                keys = {
                    -- increase width
                    ["<c-Right>"] = function(win)
                        win:resize("width", 2)
                    end,
                    -- decrease width
                    ["<c-Left>"] = function(win)
                        win:resize("width", -2)
                    end,
                    -- increase height
                    ["<c-Up>"] = function(win)
                        win:resize("height", 2)
                    end,
                    -- decrease height
                    ["<c-Down>"] = function(win)
                        win:resize("height", -2)
                    end,
                },
            }
            local pos = {
                filesystem = "left",
                buffers = "top",
                git_status = "right",
                document_symbols = "bottom",
                diagnostics = "bottom",
            }
            local sources = { "filesystem", "buffers", "git_status" }
            for i, v in ipairs(sources) do
                table.insert(opts.left, i, {
                    title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
                    ft = "neo-tree",
                    filter = function(buf)
                        return vim.b[buf].neo_tree_source == v
                    end,
                    pinned = true,
                    open = function()
                        vim.cmd(("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, RootGet()))
                    end,
                })
            end

            -- trouble
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

            -- snacks terminal
            for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
                opts[pos] = opts[pos] or {}
                table.insert(opts[pos], {
                    ft = "snacks_terminal",
                    size = { height = 0.4 },
                    title = "%{b:snacks_terminal.id}: %{b:term_title}",
                    filter = function(_buf, win)
                        return vim.w[win].snacks_win
                            and vim.w[win].snacks_win.position == pos
                            and vim.w[win].snacks_win.relative == "editor"
                            and not vim.w[win].trouble_preview
                    end,
                })
            end
            return opts
        end,
    },
    {
        "lucobellic/edgy-group.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = { "folke/edgy.nvim" },
        keys = {
            {
                '<leader>el',
                function() require('edgy-group').open_group_offset('left', 1) end,
                desc = 'Edgy Group Next Left',
            },
            {
                '<leader>eh',
                function() require('edgy-group').open_group_offset('left', -1) end,
                desc = 'Edgy Group Prev Left',
            },
            {
                '<c-,>',
                function()
                    require('edgy-group.stl').pick()
                end,
                desc = 'Edgy Group Pick',
            },
        },
        opts = {
            groups = {
                left = {
                    { icon = '',  titles = { 'Neo-Tree filesystem', 'Neo-Tree Buffers', 'Neo-Tree Git status'} },
                    { icon = '',  titles = { 'Outline' } },
                },
            },
            statusline = {
                separators = { ' ', ' ' },
                clickable = true,
                colored = true,
                colors = {
                    active = 'PmenuSel',
                    inactive = 'Pmenu',
                },
            },
        }
    }
}
