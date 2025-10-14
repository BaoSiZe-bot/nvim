return {
    {
        "cpea2506/relative-toggle.nvim",
        event = "LazyFile",
        enabled = false,
        opts = {},
    },
    {
        -- reopen buffer as your browser do
        "iamyoki/buffer-reopen.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        -- stay center for your cursor
        "joshuadanpeterson/typewriter",
        cmd = { "TWEnable", "TWToggle", "TWDisable" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
    },
    {
        "axieax/urlview.nvim",
        cmd = { "UrlView" },
        keys = {
            {
                "<leader>fl",
                function ()
                    require("urlview").search("lazy")
                end,
                desc = "Find plugins urls",
            },
            {
                "<leader>su",
                function ()
                    require("urlview").search()
                end,
                desc = "Urls in buffer",
            }
        },
        opts = {}
    },
    {
        -- takes snapshot for your code
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
        -- show whitespace in visual mode as vscode do
        'mcauley-penney/visual-whitespace.nvim',
        event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
        opts = {},
    },
    {
        -- style your comment as a box
        "LudoPinelli/comment-box.nvim",
        event = "VeryLazy",
    },
    {
        -- show marks on your status column
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        -- render your regex on-the-fly
        'tomiis4/Hypersonic.nvim',
        event = "CmdlineEnter",
        cmd = "Hypersonic",
        opts = {}
    },
}
