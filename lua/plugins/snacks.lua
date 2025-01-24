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
                            action = ":lua require(\"snacks\").picker.pick('oldfiles')",
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
            statuscolumn = { enabled = true }, -- we set this in options.lua
            toggle = { enabled = true },
            words = { enabled = true },
            bigfile = { enabled = true },
            quickfile = { enabled = true },
            zen = { enabled = true },
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
        keys = {
            {
                "<leader>n",
                function()
                    require("snacks").notifier.show_history()
                end,
                desc = "Notification History",
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
            {
                "<leader>gc",
                function()
                    require("snacks").picker.git_log()
                end,
                desc = "Git Log",
            },
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
            -- search
            {
                '<leader>s"',
                function()
                    require("snacks").registers()
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
                "<leader>sH",
                function()
                    require("snacks").picker.highlights()
                end,
                desc = "Search Highlight Groups",
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
        },
    },
    {
        "folke/snacks.nvim",
        opts = function(_, opts)
            return vim.tbl_deep_extend("force", opts or {}, {
                picker = {
                    actions = require("trouble.sources.snacks").actions,
                    win = {
                        input = {
                            keys = {
                                ["<c-t>"] = {
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
}
