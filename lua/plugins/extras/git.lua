return {
    {
        "pwntester/octo.nvim",
        cmd = "Octo",
        event = { { event = "BufReadCmd", pattern = "octo://*" } },
        opts = {
            enable_builtin = true,
            default_to_projects_v2 = true,
            default_merge_method = "squash",
            picker = "snacks",
        },
        keys = {
            { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List Issues (Octo)" },
            { "<leader>gI", "<cmd>Octo issue search<CR>", desc = "Search Issues (Octo)" },
            { "<leader>gp", "<cmd>Octo pr list<CR>", desc = "List PRs (Octo)" },
            { "<leader>gP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Octo)" },
            { "<leader>gr", "<cmd>Octo repo list<CR>", desc = "List Repos (Octo)" },
            { "<leader>gS", "<cmd>Octo search<CR>", desc = "Search (Octo)" },
            { "<localleader>a", "", desc = "+assignee (Octo)", ft = "octo" },
            { "<localleader>c", "", desc = "+comment/code (Octo)", ft = "octo" },
            { "<localleader>l", "", desc = "+label (Octo)", ft = "octo" },
            { "<localleader>i", "", desc = "+issue (Octo)", ft = "octo" },
            { "<localleader>r", "", desc = "+react (Octo)", ft = "octo" },
            { "<localleader>p", "", desc = "+pr (Octo)", ft = "octo" },
            { "<localleader>pr", "", desc = "+rebase (Octo)", ft = "octo" },
            { "<localleader>ps", "", desc = "+squash (Octo)", ft = "octo" },
            { "<localleader>v", "", desc = "+review (Octo)", ft = "octo" },
            { "<localleader>g", "", desc = "+goto_issue (Octo)", ft = "octo" },
            { "@", "@<C-x><C-o>", mode = "i", ft = "octo", silent = true },
            { "#", "#<C-x><C-o>", mode = "i", ft = "octo", silent = true },
        },
    },
    {
        "pwntester/octo.nvim",
        opts = function(_, opts)
            vim.treesitter.language.register("markdown", "octo")
            vim.api.nvim_create_autocmd("ExitPre", {
                group = vim.api.nvim_create_augroup("octo_exit_pre", { clear = true }),
                callback = function(ev)
                    local keep = { "octo" }
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        if vim.tbl_contains(keep, vim.bo[buf].filetype) then
                            vim.bo[buf].buftype = "" -- set buftype to empty to keep the window
                        end
                    end
                end,
            })
        end,
    },
    {
        "NeogitOrg/neogit",
        keys = {
            {
                "<leader>gn",
                "<cmd>lua require('neogit').open({cwd = Abalone.root.get()})<CR>",
                desc = "Neogit",
            },
        },
        dependencies = {
            "sindrets/diffview.nvim", -- optional - Diff integration
        },
        opts = {
            -- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
            -- events.
            filewatcher = {
                interval = 1000,
                enabled = true,
            },
            -- "ascii"   is the graph the git CLI generates
            -- "unicode" is the graph like https://kkgithub.com/rbong/vim-flog
            -- "kitty"   is the graph like https://kkgithub.com/isakbm/gitgraph.nvim - use https://kkgithub.com/rbong/flog-symbols if you don't use Kitty
            graph_style = "unicode",
            -- Set to false if you want to be responsible for creating _ALL_ keymappings
            use_default_keymaps = true,
            -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
            -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
            auto_refresh = true,
            -- Change the default way of opening neogit
            kind = "tab",
            -- The time after which an output console is shown for slow running commands
            console_timeout = 10000,
            -- Automatically show console if a command takes more than console_timeout milliseconds
            auto_show_console = true,
            -- Automatically close the console if the process exits with a 0 (success) status
            auto_close_console = false,
            notification_icon = "󰊢",
            commit_editor = {
                kind = "tab",
                show_staged_diff = true,
                staged_diff_split_kind = "auto",
                spell_check = true,
            },
            preview_buffer = {
                kind = "floating_console",
            },
            signs = {
                -- { CLOSED, OPENED }
                hunk = { "", "" },
                item = { ">", "v" },
                section = { ">", "v" },
            },
            sections = {
                -- Reverting/Cherry Picking
                sequencer = {
                    folded = false,
                    hidden = false,
                },
                untracked = {
                    folded = false,
                    hidden = false,
                },
                unstaged = {
                    folded = false,
                    hidden = false,
                },
                staged = {
                    folded = false,
                    hidden = false,
                },
                stashes = {
                    folded = true,
                    hidden = false,
                },
                unpulled_upstream = {
                    folded = true,
                    hidden = false,
                },
                unmerged_upstream = {
                    folded = false,
                    hidden = false,
                },
                unpulled_pushRemote = {
                    folded = true,
                    hidden = false,
                },
                unmerged_pushRemote = {
                    folded = false,
                    hidden = false,
                },
                recent = {
                    folded = true,
                    hidden = false,
                },
                rebase = {
                    folded = true,
                    hidden = false,
                },
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "LazyFile",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            signs_staged = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                map("n", "]h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, "Next Hunk")
                map("n", "[h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, "Prev Hunk")
                map("n", "]H", function()
                    gs.nav_hunk("last")
                end, "Last Hunk")
                map("n", "[H", function()
                    gs.nav_hunk("first")
                end, "First Hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
                map("n", "<leader>ghb", function()
                    gs.blame_line({ full = true })
                end, "Blame Line")
                map("n", "<leader>ghB", function()
                    gs.blame()
                end, "Blame Buffer")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function()
                    gs.diffthis("~")
                end, "Diff This ~")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
            end,
        },
    },
    -- {
    --     "APZelos/blamer.nvim",
    --     event = "LazyFile",
    --     config = function()
    --         vim.g.blamer_enabled = true
    --         vim.g.blamer_delay = 300
    --     end,
    -- },
    { "akinsho/git-conflict.nvim", opts = {}, event = "LazyFile"},
}
