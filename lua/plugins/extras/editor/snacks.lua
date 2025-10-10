local function term_nav(dir)
    return function(self)
        return self:is_floating() and "<c-" .. dir .. ">"
            or vim.schedule(function()
                vim.cmd.wincmd(dir)
            end)
    end
end
---@type table<string, string[]|boolean>?
local kind_filter = Abalone.kind_filter
return {
    {
        "folke/snacks.nvim",
        -- lazy = true,
        -- enabled = false,
        priority = 1000,
        lazy = false,
        config = function(_, opts)
            local notify = vim.notify
            Snacks.setup(opts)
            Snacks.pick = Snacks.picker.pick
            vim.notify = notify
        end,
    },
    {
        "folke/snacks.nvim",
        opts = {
            -- indent = { enabled = true },
            input = { enabled = true },
            notifier = { enabled = true },
            scope = { enabled = true },
            toggle = { enabled = true },
            words = { enabled = true },
            bigfile = { enabled = true },
            -- quickfile = { enabled = true },
            zen = { enabled = true },
            animate = { enabled = true },
            dim = { enabled = true },
            gitbrowse = { enabled = true },
            layout = { enabled = true },
            scratch = { enabled = true },
            win = { enabled = true },
            image = { enabled = true },
        }
    },
    {
        "folke/snacks.nvim",
        opts = {
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
        }
    },
    {
        "folke/snacks.nvim",
        opts = {
            picker = {
                sources = {
                    explorer = {
                        layout = {
                            layout = {
                                width = 0.2,
                                height = 0.2,
                                position = "right"
                            }
                        }
                    },
                }
            }
        },
        keys = {
            {
                "<leader>fe",
                function()
                    Snacks.explorer({ cwd = Abalone.root.get() })
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
    {
        "folke/snacks.nvim",
        opts = {
            dashboard = {
                enabled = true,
                preset = {
                    pick = function(cmd, opts)
                        return Snacks.picker.pick(cmd, opts)()
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
                            action = ":lua Snacks.pick('files', {hidden = true})",
                        },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        {
                            icon = " ",
                            key = "g",
                            desc = "Find Text",
                            action = ":lua Snacks.pick('live_grep')",
                        },
                        {
                            icon = " ",
                            key = "r",
                            desc = "Recent Files",
                            action = ":lua Snacks.pick('recent')",
                        },
                        {
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = ":lua Snacks.pick('files', {cwd = vim.fn.stdpath('config')})",
                        },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
            },
        }
    },
    {
        "folke/snacks.nvim",
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
                        local root = Abalone.root.get({ buf = p.input.filter.current_buf, normalize = true })
                        local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
                        local current = p:cwd()
                        p:set_cwd(current == root and cwd or root)
                        p:find()
                    end,
                },
            },
        },
        keys = {
            { "<leader>n",       function() Snacks.picker.notifications() end,                                    desc = "Notification History" },
            { "<leader>un",      function() Snacks.notifier.hide() end,                                           desc = "Dismiss All Notifications" },
            { "<leader>,",       function() Snacks.picker.buffers() end,                                          desc = "Switch Buffer" },
            { "<leader>/",       function() Snacks.picker.grep() end,                                             desc = "Grep (Root Dir)" },
            { "<leader>:",       function() Snacks.picker.command_history() end,                                  desc = "Command History", },
            { "<leader><space>", function() Snacks.picker.files({ hidden = true, cwd = Abalone.root.get() }) end, desc = "Find Files (Root Dir)", },
            { "<leader>fb",      function() Snacks.picker.buffers() end,                                          desc = "Buffers", },
            { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,          desc = "Find Config File", },
            { "<leader>ff",      function() Snacks.picker.files({ hidden = true, cwd = Abalone.root.get() }) end, desc = "Find Files (Root Dir)", },
            { "<leader>fF",      function() Snacks.picker.files({ hidden = true }) end,                           desc = "Find Files (cwd)", },
            { "<leader>fg",      function() Snacks.picker.git_files() end,                                        desc = "Find Files (git-files)", },
            { "<leader>fr",      function() Snacks.picker.recent() end,                                           desc = "Recent", },
            { "<leader>gd",      function() Snacks.picker.git_diff() end,                                         desc = "Git Diff (hunks)", },
            { "<leader>gs",      function() Snacks.picker.git_status() end,                                       desc = "Git Status", },
            { "<leader>gS",      function() Snacks.picker.git_stash() end,                                        desc = "Git Stash", },
            { "<leader>gm",      function() Snacks.terminal({ "magit" }) end,                                     desc = "Magit (cwd)", },
            { "<leader>gM",      function() Snacks.terminal({ "magit" }, { cwd = Abalone.root.get() }) end,       desc = "Magit (Root Dir)", },
            { "<leader>gg",      function() Snacks.terminal({ "gitui" }) end,                                     desc = "GitUI (cwd)", },
            { "<leader>gG",      function() Snacks.terminal({ "gitui" }, { cwd = Abalone.root.get() }) end,       desc = "GitUI (Root Dir)", },
            { "<leader>gl",      function() Snacks.terminal({ "lazygit" }) end,                                   desc = "LazyGit (cwd)", },
            { "<leader>gL",      function() Snacks.terminal({ "lazygit"}, { cwd = Abalone.root.get() }) end,     desc = "LazyGit (Root Dir)", },
            { '<leader>s"',      function() Snacks.picker.registers() end,                                        desc = "Registers", },
            { "<leader>sa",      function() Snacks.picker.autocmds() end,                                         desc = "Auto Commands", },
            { "<leader>sb",      function() Snacks.picker.lines() end,                                            desc = "Buffer", },
            { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                                     desc = "Grep Open Buffers", },
            { "<leader>sc",      function() Snacks.picker.command_history() end,                                  desc = "Command History", },
            { "<leader>sC",      function() Snacks.picker.commands() end,                                         desc = "Commands", },
            { "<leader>sd",      function() Snacks.picker.diagnostics_buffer() end,                               desc = "Buffer Diagnostics", },
            { "<leader>sD",      function() Snacks.picker.diagnostics() end,                                      desc = "Wordkspace Diagnostics", },
            { "<leader>sg",      function() Snacks.pick("live_grep") end,                                         desc = "Grep (Root Dir)", },
            { "<leader>sh",      function() Snacks.picker.help() end,                                             desc = "Help Pages", },
            { "<leader>sp",      function() Snacks.picker.lazy() end,                                             desc = "Search for Plugin Spec", },
            { "<leader>sH",      function() Snacks.picker.highlights() end,                                       desc = "Search Highlight Groups", },
            { "<leader>si",      function() Snacks.picker.icons() end,                                            desc = "Icons", },
            { "<leader>sj",      function() Snacks.picker.jumps() end,                                            desc = "Jumps", },
            { "<leader>sk",      function() Snacks.picker.keymaps() end,                                          desc = "Keymaps", },
            { "<leader>sl",      function() Snacks.picker.loclist() end,                                          desc = "Location List", },
            { "<leader>sM",      function() Snacks.picker.man() end,                                              desc = "Man Pages", },
            { "<leader>sm",      function() Snacks.picker.marks() end,                                            desc = "Marks", },
            { "<leader>sR",      function() Snacks.picker.resume() end,                                           desc = "Resume", },
            { "<leader>sq",      function() Snacks.picker.qflist() end,                                           desc = "Quickfix List", },
            { "<leader>sw",      function() Snacks.picker.grep_word() end,                                        desc = "Word (Root Dir)", },
            { "<leader>uc",      function() Snacks.picker.colorschemes() end,                                     desc = "Colorscheme with Preview", },
            { "<leader>ss",      function() Snacks.picker.lsp_symbols({ filter = kind_filter }) end,              desc = "LSP Symbols" },
            { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols({ filter = kind_filter }) end,    desc = "LSP Workspace Symbols" },
            { "<leader>s/",      function() Snacks.picker.search_history() end,                                   desc = "Search History" },
            { "<leader>Z",       function() Snacks.picker.zoxide() end,                                           desc = "Zoxide", },
            { "<leader>U",       function() Snacks.picker.undo() end,                                             desc = "Undo History", },
            { "<leader>\\",      function() Snacks.picker.smart() end,                                            desc = "multiple-source search", },
            { "<leader>.",       function() Snacks.scratch() end,                                                 desc = "Toggle Scratch Buffer" },
            { "<leader>S",       function() Snacks.scratch.select() end,                                          desc = "Select Scratch Buffer" },
            { "<leader>dps",     function() Snacks.profiler.scratch() end,                                        desc = "Profiler Scratch Buffer" },
            { "<space>ft",       function() Snacks.terminal(nil, {cwd = Abalone.root.get()}) end,                 desc = "Open Terminal"},
            {
                "<leader>z",
                function()
                    Snacks.zen()
                    vim.cmd([[TWToggle]])
                end,
                desc = "Zen mode"
            },
            { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
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
}
