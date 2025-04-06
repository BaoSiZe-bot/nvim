local function term_nav(dir)
    return function(self)
        return self:is_floating() and "<c-" .. dir .. ">"
            or vim.schedule(function()
                vim.cmd.wincmd(dir)
            end)
    end
end
---@type table<string, string[]|boolean>?
local kind_filter = {
    default = {
        "Class",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Package",
        "Property",
        "Struct",
        "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
        "Class",
        "Constructor",
        "Enum",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        -- "Package", -- remove package since luals uses it for control flow structures
        "Property",
        "Struct",
        "Trait",
    },
}
return {
    {
        "folke/snacks.nvim",
        event = "UIEnter",
        opts = {
            picker = {
                win = {
                    input = {
                        keys = {
                            ["<a-c>"] = {
                                "toggle_cwd",
                                mode = { "n", "i" },
                            },
                        },
                    },
                },
                actions = {
                    toggle_cwd = function(p)
                        local root = RootGet({ buf = p.input.filter.current_buf, normalize = true })
                        local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
                        local current = p:cwd()
                        p:set_cwd(current == root and cwd or root)
                        p:find()
                    end,
                },
            },
            image = {

            },
            dashboard = {
                enabled = true,
                preset = {
                    pick = function(cmd, opts)
                        return require("snacks").picker.pick(cmd, opts)()
                    end,
                    header = [[
         (   )              (   )                                 .-.
  .---.   | |.-.     .---.   | |    .--.    ___ .-.    ___  ___  ( __)  ___ .-. .-.
 / .-, \  | /   \   / .-, \  | |   /    \  (   )   \  (   )(   ) (''") (   )   '   \
(__) ; |  |  .-. | (__) ; |  | |  |  .-. ;  |  .-. .   | |  | |   | |   |  .-.  .-. ;
  .'`  |  | |  | |   .'`  |  | |  | |  | |  | |  | |   | |  | |   | |   | |  | |  | |
 / .'| |  | |  | |  / .'| |  | |  | |  | |  | |  | |   | |  | |   | |   | |  | |  | |
| /  | |  | |  | | | /  | |  | |  | |  | |  | |  | |   | |  | |   | |   | |  | |  | |
; |  ; |  | '  | | ; |  ; |  | |  | '  | |  | |  | |   ' '  ; '   | |   | |  | |  | |
' `-'  |  ' `-' ;  ' `-'  |  | |  '  `-' /  | |  | |    \ `' /    | |   | |  | |  | |
`.__.'_.   `.__.   `.__.'_. (___)  `.__.'  (___)(___)    '_.'    (___) (___)(___)(___)
                ]],
                    keys = {
                        {
                            icon = " ",
                            key = "f",
                            desc = "Find File",
                            action = ':lua require("snacks").picker.files({hidden = true})',
                        },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        {
                            icon = " ",
                            key = "g",
                            desc = "Find Text",
                            action = ":lua require(\"snacks\").picker.pick('live_grep')",
                        },
                        {
                            icon = " ",
                            key = "r",
                            desc = "Recent Files",
                            action = ":lua require(\"snacks\").picker.pick('recent')",
                        },
                        {
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = ":lua require(\"snacks\").picker.pick('files', {cwd = vim.fn.stdpath('config')})",
                        },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
            },
            indent = { enabled = true },
            input = { enabled = true },
            notifier = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            image = { enabled = true },
            -- statuscolumn = { enabled = true }, -- we set this in options.lua
            toggle = { enabled = true },
            words = { enabled = true },
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            zen = { enabled = true },
            animate = { enabled = true },
            -- bufdelete = { enabled = true }, -- enabled by default
            -- debug = { enabled = true }, -- enabled by default
            dim = { enabled = true },
            -- git = { enabled = true }, -- enabled by default
            gitbrowse = { enabled = true },
            layout = { enabled = true },
            scratch = { enabled = true },
            win = { enabled = true },
            terminal = {
                win = {
                    keys = {
                        nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
                        nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
                        nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
                        nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
                    },
                },
            },
        },
        init = function()
            _G.dd = function(...)
                Snacks.debug.inspect(...)
            end
            _G.bt = function()
                Snacks.debug.backtrace()
            end
            vim.print = _G.dd
        end,
        keys = {
            {
                "<leader>n",
                function()
                    Snacks.picker.notifications()
                end,
                desc = "Notification History"
            },
            {
                "<leader>un",
                function()
                    require("snacks").notifier.hide()
                end,
                desc = "Dismiss All Notifications",
            },
            {
                "<leader>,",
                function()
                    require("snacks").picker.buffers()
                end,
                desc = "Switch Buffer",
            },
            {
                "<leader>/",
                function()
                    require("snacks").picker.grep()
                end,
                desc = "Grep (Root Dir)",
            },
            {
                "<leader>:",
                function()
                    require("snacks").picker.command_history()
                end,
                desc = "Command History",
            },
            {
                "<leader><space>",
                function()
                    require("snacks").picker.files({ hidden = true })
                end,
                desc = "Find Files (Root Dir)",
            },
            {
                "<leader>fb",
                function()
                    require("snacks").picker.buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>fc",
                function()
                    require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
                end,
                desc = "Find Config File",
            },
            {
                "<leader>ff",
                function()
                    require("snacks").picker.files({ hidden = true })
                end,
                desc = "Find Files (Root Dir)",
            },
            {
                "<leader>fg",
                function()
                    require("snacks").picker.git_files()
                end,
                desc = "Find Files (git-files)",
            },
            {
                "<leader>fr",
                function()
                    require("snacks").picker.recent()
                end,
                desc = "Recent",
            },
            -- {
            --     "<leader>gc",
            --     function()
            --         require("snacks").picker.git_log()
            --     end,
            --     desc = "Git Log",
            -- },
            {
                "<leader>gd",
                function()
                    require("snacks").picker.git_diff()
                end,
                desc = "Git Diff (hunks)",
            },
            {
                "<leader>gs",
                function()
                    require("snacks").picker.git_status()
                end,
                desc = "Git Status",
            },
            {
                "<leader>gS",
                function()
                    require("snacks").picker.git_stash()
                end,
                desc = "Git Stash",
            },
            -- search
            {
                '<leader>s"',
                function()
                    require("snacks").picker.registers()
                end,
                desc = "Registers",
            },
            {
                "<leader>sa",
                function()
                    require("snacks").picker.autocmds()
                end,
                desc = "Auto Commands",
            },
            {
                "<leader>sb",
                function()
                    require("snacks").picker.lines()
                end,
                desc = "Buffer",
            },
            {
                "<leader>sB",
                function()
                    require("snacks").picker.grep_buffers()
                end,
                desc = "Grep Open Buffers",
            },
            {
                "<leader>sc",
                function()
                    require("snacks").picker.command_history()
                end,
                desc = "Command History",
            },
            {
                "<leader>sC",
                function()
                    require("snacks").picker.commands()
                end,
                desc = "Commands",
            },
            {
                "<leader>sd",
                function()
                    require("snacks").picker.diagnostics_buffer()
                end,
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>sD",
                function()
                    require("snacks").picker.diagnostics()
                end,
                desc = "Wordkspace Diagnostics",
            },
            {
                "<leader>sg",
                function()
                    require("snacks").picker.pick("live_grep")
                end,
                desc = "Grep (Root Dir)",
            },
            {
                "<leader>sh",
                function()
                    require("snacks").picker.help()
                end,
                desc = "Help Pages",
            },
            {
                "<leader>sp",
                function()
                    require("snacks").picker.lazy()
                end,
                desc = "Search for Plugin Spec",
            },
            {
                "<leader>sH",
                function()
                    require("snacks").picker.highlights()
                end,
                desc = "Search Highlight Groups",
            },
            {
                "<leader>si",
                function()
                    require("snacks").picker.icons()
                end,
                desc = "Icons",
            },
            {
                "<leader>sj",
                function()
                    require("snacks").picker.jumps()
                end,
                desc = "Jumps",
            },
            {
                "<leader>sk",
                function()
                    require("snacks").picker.keymaps()
                end,
                desc = "Keymaps",
            },
            {
                "<leader>sl",
                function()
                    require("snacks").picker.loclist()
                end,
                desc = "Location List",
            },
            {
                "<leader>sM",
                function()
                    require("snacks").picker.man()
                end,
                desc = "Man Pages",
            },
            {
                "<leader>sm",
                function()
                    require("snacks").picker.marks()
                end,
                desc = "Marks",
            },
            {
                "<leader>sR",
                function()
                    require("snacks").picker.resume()
                end,
                desc = "Resume",
            },
            {
                "<leader>sq",
                function()
                    require("snacks").picker.qflist()
                end,
                desc = "Quickfix List",
            },
            {
                "<leader>sw",
                function()
                    require("snacks").picker.grep_word()
                end,
                desc = "Word (Root Dir)",
            },
            {
                "<leader>uc",
                function()
                    require("snacks").picker.colorschemes()
                end,
                desc = "Colorscheme with Preview",
            },
            {
                "<leader>ss",
                function()
                    require("snacks").picker.lsp_symbols({ filter = kind_filter })
                end,
                desc = "LSP Symbols",
                -- has = "documentSymbol",
            },
            {
                "<leader>sS",
                function()
                    require("snacks").picker.lsp_workspace_symbols({ filter = kind_filter })
                end,
                desc = "LSP Workspace Symbols",
                -- has = "workspace/symbols",
            },
            {
                "<leader>s/",
                function()
                    require("snacks").picker.search_history()
                end,
                desc = "Search History"
            },
            {
                "<leader>Z",
                function()
                    require("snacks").picker.zoxide()
                end,
                desc = "Zoxide",
            },
            {
                "<leader>U",
                function()
                    require("snacks").picker.undo()
                end,
                desc = "Undo History",
            },
            {
                "<leader>\\",
                function()
                    require("snacks").picker.smart()
                end,
                desc = "multiple-source search",
            },
            {
                "<leader>.",
                function()
                    require("snacks").scratch()
                end,
                desc = "Toggle Scratch Buffer",
            },
            {
                "<leader>S",
                function()
                    require("snacks").scratch.select()
                end,
                desc = "Select Scratch Buffer",
            },
            {
                "<leader>dps",
                function()
                    require("snacks").profiler.scratch()
                end,
                desc = "Profiler Scratch Buffer",
            },
            {
                "<leader>z",
                function()
                    require("snacks").zen()
                    vim.cmd([[TWToggle]])
                end,
                desc = "Zen mode",
            },
            {
                "<leader>cl",
                function()
                    Snacks.picker.lsp_config()
                end,
                desc = "Lsp Info"
            },
        },
    },
    {
        "folke/snacks.nvim",
        opts = function(_, opts)
            return vim.tbl_deep_extend("force", opts or {}, {
                picker = {
                    actions = {
                        trouble_open = function(...)
                            return require("trouble.sources.snacks").actions.trouble_open.action(...)
                        end,
                    },
                    win = {
                        input = {
                            keys = {
                                ["<a-t>"] = {
                                    "trouble_open",
                                    mode = { "n", "i" },
                                },
                            },
                        },
                    },
                },
            })
        end,
    },
    {
        "folke/flash.nvim",
        optional = true,
        specs = {
            {
                "folke/snacks.nvim",
                opts = {
                    picker = {
                        win = {
                            input = {
                                keys = {
                                    ["<a-s>"] = { "flash", mode = { "n", "i" } },
                                    ["s"] = { "flash" },
                                },
                            },
                        },
                        actions = {
                            flash = function(picker)
                                require("flash").jump({
                                    pattern = "^",
                                    label = { after = { 0, 0 } },
                                    search = {
                                        mode = "search",
                                        exclude = {
                                            function(win)
                                                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~=
                                                    "snacks_picker_list"
                                            end,
                                        },
                                    },
                                    action = function(match)
                                        local idx = picker.list:row2idx(match.pos[1])
                                        picker.list:_move(idx, true, true)
                                    end,
                                })
                            end,
                        },
                    },
                },
            },
        },
    },
    {
        "folke/snacks.nvim",
        opts = { explorer = {} },
        keys = {
            {
                "<leader>fe",
                function()
                    Snacks.explorer({ cwd = RootGet() })
                end,
                desc = "Explorer Snacks (root dir)",
            },
            {
                "<leader>fE",
                function()
                    Snacks.explorer()
                end,
                desc = "Explorer Snacks (cwd)",
            },
            { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
            { "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)",      remap = true },
        },
    },
}
