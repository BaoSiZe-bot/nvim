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
    { "nvim-lua/plenary.nvim"},
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
        "SCJangra/table-nvim",
        ft = "markdown",
        opts = {},
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
    {
        "jim-fx/sudoku.nvim",
        cmd = "Sudoku",
        config = function()
            require("sudoku").setup({
                -- configuration ...
            })
        end,
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
        "3rd/image.nvim",
        event = "UIEnter",
        enabled = false,
        opts = {
            backend = "ueberzug",
        }
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
        'abecodes/tabout.nvim',
        opts = {
            tabkey = '<Tab>',             -- key to trigger tabout, set to an empty string to disable
            backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
            act_as_tab = true,            -- shift content if tab out is not possible
            act_as_shift_tab = false,     -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
            default_tab = '<C-t>',        -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
            default_shift_tab = '<C-d>',  -- reverse shift default action,
            enable_backwards = true,      -- well ...
            completion = false,           -- if the tabkey is used in a completion pum
            tabouts = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
                { open = '`', close = '`' },
                { open = '(', close = ')' },
                { open = '[', close = ']' },
                { open = '{', close = '}' }
            },
            ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
            exclude = {}         -- tabout will ignore these filetypes
        },
        event = 'InsertCharPre', -- Set the event to 'InsertCharPre' for better compatibility
        priority = 1000,
    },
    {
        "Freed-Wu/rime.nvim",
        enabled = false,
        keys = {
            {
                "<C-\\>",
                function() require('rime.nvim').toggle() end,
                mode = { "i", "n" },
                desc = "toggle rime"
            }
        }
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
}
