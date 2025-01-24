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
    { "nvim-lua/plenary.nvim", lazy = true },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
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
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = function()
            require("lazy").load({ plugins = { "markdown-preview.nvim" } })
            vim.fn["mkdp#util#install"]()
        end,
        keys = {
            {
                "<leader>cp",
                ft = "markdown",
                "<cmd>MarkdownPreviewToggle<cr>",
                desc = "Markdown Preview",
            },
        },
        config = function()
            vim.cmd([[do FileType]])
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            code = {
                sign = false,
                width = "block",
                right_pad = 1,
            },
            heading = {
                sign = false,
                icons = {},
            },
            checkbox = {
                enabled = false,
            },
        },
        ft = { "markdown", "norg", "rmd", "org" },
        config = function(_, opts)
            require("render-markdown").setup(opts)
        end,
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters = {
                ["markdown-toc"] = {
                    condition = function(_, ctx)
                        for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                            if line:find("<!%-%- toc %-%->") then
                                return true
                            end
                        end
                    end,
                },
                ["markdownlint-cli2"] = {
                    condition = function(_, ctx)
                        local diag = vim.tbl_filter(function(d)
                            return d.source == "markdownlint"
                        end, vim.diagnostic.get(ctx.buf))
                        return #diag > 0
                    end,
                },
            },
            formatters_by_ft = {
                ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
                ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
            },
        },
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = {
            linters_by_ft = {
                markdown = { "markdownlint-cli2" },
            },
        },
    },
    {
        "azratul/live-share.nvim",
        cmds = { "LiveShareServer", "LiveShareJoin" },
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
        "SCJangra/table-nvim",
        ft = "markdown",
        opts = {},
    },
    {
        "JuanZoran/Trans.nvim",
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
        "2kabhishek/nerdy.nvim",
        cmd = "Nerdy",
    },
    {
        "cpea2506/relative-toggle.nvim",
        event = "LazyFile",
        opts = {},
    },
    {
        "dnlhc/glance.nvim",
        event = "LspAttach",
        keymap = {
            {
                "<leader>lp",
                "<cmd>Glance<cr>",
                mode = { "n" },
                desc = "Lsp Peek",
            },
        },
    },
    {
        "NStefan002/2048.nvim",
        cmd = "Play2048",
        opts = {},
    },
    {
        "iamyoki/buffer-reopen.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
