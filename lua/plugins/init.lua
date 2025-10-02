return {
    {
        "stevearc/conform.nvim",
        event = "LazyFile", -- uncomment for format on save
        keys = {
            {
                "<leader>cF",
                function()
                    require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
                end,
                mode = { "n", "v" },
                desc = "Format Injected Langs",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                cpp = { "clang_format" },
                -- css = { "prettier" },
                -- html = { "prettier" },
            },

            -- format_on_save = {
            --     -- These options will be passed to conform.format()
            --     timeout_ms = 10000000,
            --     lsp_format = "fallback",
            -- },
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            notify = {
                enabled = false
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
            presets = {
                bottom_search = true,
                --     command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
            },
        },
        -- stylua: ignore
        keys = {
            { "<leader>sn",  "",                                                                            desc = "+noice" },
            { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                              desc = "Redirect Cmdline" },
            { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
            { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
            { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
            { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
            { "<leader>snt", function() require("noice").cmd("pick") end,                                   desc = "Noice Picker (Telescope/FzfLua)" },
            { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,                           expr = true,              desc = "Scroll Forward",  mode = { "i", "n", "s" } },
            { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,                           expr = true,              desc = "Scroll Backward", mode = { "i", "n", "s" } },
        },
        config = function(_, opts)
            -- HACK: noice shows messages from before it was enabled,
            -- but this is not ideal when Lazy is installing plugins,
            -- so clear the messages in this case.
            if vim.o.filetype == "lazy" then
                vim.cmd([[messages clear]])
            end
            require("noice").setup(opts)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "vim",
                "lua",
                "vimdoc",
                "c",
                "cpp",
                "markdown",
                "markdown_inline",
            },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts_extend = { "spec" },
        opts = {
            preset = "helix",
            defaults = {},
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader><tab>", group = "tabs" },
                    { "<leader>c", group = "code" },
                    { "<leader>d", group = "debug" },
                    { "<leader>dp", group = "profiler" },
                    { "<leader>f", group = "file/find" },
                    { "<leader>g", group = "git" },
                    { "<leader>gh", group = "hunks" },
                    { "<leader>q", group = "quit/session" },
                    { "<leader>s", group = "search" },
                    { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
                    { "<leader>v", group = "org", icon = " " },
                    { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "gs", group = "surround" },
                    { "z", group = "fold" },
                    {
                        "<leader>b",
                        group = "buffer",
                        expand = function()
                            return require("which-key.extras").expand.buf()
                        end,
                    },
                    {
                        "<leader>w",
                        group = "windows",
                        proxy = "<c-w>",
                        expand = function()
                            return require("which-key.extras").expand.win()
                        end,
                    },
                    -- better descriptions
                    { "gx", desc = "Open with system app" },
                },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Keymaps (which-key)",
            },
            {
                "<c-w><space>",
                function()
                    require("which-key").show({ keys = "<c-w>", loop = true })
                end,
                desc = "Window Hydra Mode (which-key)",
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            if not vim.tbl_isempty(opts.defaults) then
                wk.register(opts.defaults)
            end
            require("which-key").add({
                { "<leader>a", group = "Full text/Sidekick", icon = "󰒆" },
                { "<leader>ac", "<cmd>%d_<CR>i", desc = "Edit", icon = "" },
                { "<leader>ak", "<cmd>%d<CR>", desc = "Cut", icon = "" },
                { "<leader>ad", "<cmd>%d_<CR>", desc = "Delete", icon = "" },
                { "<leader>as", "ggVG<C-g>", desc = "Select(Select mode)", icon = "󱟁" },
                { "<leader>av", "ggVG", desc = "Select(Visual mode)", icon = "󰒅" },
                { "<leader>ay", "<cmd>%y<CR>", desc = "Copy", icon = "" },
                { "<leader>t", group = "Test", icon = "󰙨" },
                { "<leader>td", "<cmd>Comp delete_testcase<CR>", desc = "Delete testcase", icon = "󰆴" },
                { "<leader>te", "<cmd>Comp edit_testcase<CR>", desc = "Edit testcase", icon = "" },
                { "<leader>tn", "<cmd>Comp add_testcase<CR>", desc = "New testcase", icon = "" },
                { "<leader>tr", group = "Receive", icon = "󱃚" },
                { "<leader>trc", "<cmd>Comp receive contest<CR>", desc = "Problems(Contest)", icon = " " },
                { "<leader>trp", "<cmd>Comp receive problem<CR>", desc = "Problem", icon = "" },
                { "<leader>trt", "<cmd>Comp receive testcases<CR>", desc = "Testcase", icon = "✔" },
                { "<leader>tt", "<cmd>Comp run<CR>", desc = "Run test", icon = "󰙨" },
                { "<leader>bn", "<cmd>bnext<cr>", desc = "Next buffer" },
                { "<leader>bp", "<cmd>bprevious<cr>", desc = "Prev Buffer" },
            })
        end,
    },
}
