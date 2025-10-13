return {
    {
        "lambdalisue/vim-suda",
        cmd = { "SudaRead", "SudaWrite" },
    },
    {
        "MagicDuck/grug-far.nvim",
        opts = { headerMaxWidth = 80 },
        cmd = "GrugFar",
        keys = {
            {
                "<leader>sr",
                function()
                    local grug = require("grug-far")
                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.open({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                    })
                end,
                mode = { "n", "v" },
                desc = "Search and Replace",
            },
        },
    },
    {
        "folke/persistence.nvim",
        event = "VimLeavePre",
        opts = {},
        keys = {
            {
                "<leader>qs",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<leader>qS",
                function()
                    require("persistence").select()
                end,
                desc = "Select Session",
            },
            {
                "<leader>ql",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore Last Session",
            },
            {
                "<leader>qd",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "LazyFile",
        opts = {

        },
        keys = {
            {
                "<leader>st",
                function()
                    require("todo-comments.fzf").todo()
                end,
                desc = "Todo",
            },
            {
                "<leader>sT",
                function()
                    require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
                end,
                desc = "Todo/Fix/Fixme",
            },
        },
    },
    {
        "azratul/live-share.nvim",
        cmd = { "LiveShareServer", "LiveShareJoin" },
        dependencies = {
            "jbyuki/instant.nvim",
        },
        config = function()
            vim.g.instant_username = "your-username"
            require("live-share").setup({
                max_attempts = 40, -- 10 seconds
            })
        end,
    },
    {
        "JuanZoran/Trans.nvim",
        enabled = false,
        build = function()
            require("Trans").install()
        end,
        keys = {
            -- 可以换成其他你想映射的键
            { "mm", mode = { "n", "x" }, "<Cmd>Translate<CR>", desc = "󰊿 Translate" },
            { "mk", mode = { "n", "x" }, "<Cmd>TransPlay<CR>", desc = " Auto Play" },
            -- 目前这个功能的视窗还没有做好，可以在配置里将view.i改成hover
            { "mi", "<Cmd>TranslateInput<CR>", desc = "󰊿 Translate From Input" },
        },
        dependencies = { "skywind3000/ECDICT", "kkharji/sqlite.lua" },
        opts = {
            -- your configuration there
        },
    },
    {
        "cpea2506/relative-toggle.nvim",
        event = "LazyFile",
        enabled = false,
        opts = {},
    },
    {
        "dnlhc/glance.nvim",
        event = "LspAttach",
        keymap = {
            {
                "<leader>cp",
                "<cmd>Glance<cr>",
                mode = { "n" },
                desc = "Lsp Peek",
            },
        },
    },
    {
        "iamyoki/buffer-reopen.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "joshuadanpeterson/typewriter",
        cmd = { "TWEnable", "TWToggle", "TWDisable" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
    },
    {
        "axieax/urlview.nvim",
        cmd = { "UrlView" }
    },
    {
        "mistricky/codesnap.nvim",
        build = "make",
        keys = {
            { "<leader>cc", "<cmd>CodeSnap<cr>",     mode = "x", desc = "Save selected code snapshot into clipboard" },
            { "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
        },
        opts = {
            save_path = "~/Pictures",
            has_breadcrumbs = true,
            bg_theme = "summer",
        },
    },
    {
        'noearc/jieba.nvim',
        enabled = false,
        dependencies = { 'noearc/jieba-lua' },
        event = "LazyFile",
        config = function()
            require("jieba_nvim").setup()
            vim.keymap.set('n', 'ce', ":lua require'jieba_nvim'.change_w()<CR>", { noremap = false, silent = true })
            vim.keymap.set('n', 'de', ":lua require'jieba_nvim'.delete_w()<CR>", { noremap = false, silent = true })
            -- vim.keymap.set('n', '<leader>w', ":lua require'jieba_nvim'.select_w()<CR>", { noremap = false, silent = true })
        end
    },
    {
        'mcauley-penney/visual-whitespace.nvim',
        event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
        opts = {},
    },
    {
        "boltlessengineer/sense.nvim",
        event = "UIEnter"
    },
    {
        "LudoPinelli/comment-box.nvim",
        event = "VeryLazy",
    },
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        'tomiis4/Hypersonic.nvim',
        event = "CmdlineEnter",
        cmd = "Hypersonic",
        opts = {}
    },
}
