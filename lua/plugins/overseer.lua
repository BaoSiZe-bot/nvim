return {
    {
        "catppuccin",
        optional = true,
        opts = {
            integrations = { overseer = true },
        },
    },
    {
        "stevearc/overseer.nvim",
        cmd = {
            "OverseerOpen",
            "OverseerClose",
            "OverseerToggle",
            "OverseerSaveBundle",
            "OverseerLoadBundle",
            "OverseerDeleteBundle",
            "OverseerRunCmd",
            "OverseerRun",
            "OverseerInfo",
            "OverseerBuild",
            "OverseerQuickAction",
            "OverseerTaskAction",
            "OverseerClearCache",
        },
        keys = {
            { "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "Task list" },
            { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
            { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
            { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
            { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Task builder" },
            { "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
            { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
        },
        opts = {
            -- dap = false,
            form = {
                win_opts = {
                    winblend = 0,
                },
            },
            confirm = {
                win_opts = {
                    winblend = 0,
                },
            },
            task_win = {
                win_opts = {
                    winblend = 0,
                },
            },
            task_list = {
                bindings = {
                    ["<C-h>"] = false,
                    ["<C-j>"] = false,
                    ["<C-k>"] = false,
                    ["<C-l>"] = false,
                },
            },
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
        "folke/which-key.nvim",
        optional = true,
        opts = {
            spec = {
                { "<leader>o", group = "overseer" },
            },
        },
    },
    {
        "folke/edgy.nvim",
        optional = true,
        opts = function(_, opts)
            opts.right = opts.right or {}
            table.insert(opts.right, {
                title = "Overseer",
                ft = "OverseerList",
                open = function()
                    require("overseer").open()
                end,
            })
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm" },
        opts = {},
    },
    {
        "xeluxee/competitest.nvim",
        cmd = "CompetiTest",
        opts = {},
    },
    {
        "mfussenegger/nvim-dap",
        opts = function()
            require("overseer").enable_dap()
        end,
    },
}
