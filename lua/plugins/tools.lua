return {
    {
        "lambdalisue/vim-suda",
        cmd = { "SudaRead", "SudaWrite" },
    },
    {
        "Zeioth/hot-reload.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "BufEnter",
        opts = function()
            local config_dir = vim.fn.stdpath("config") .. "/lua/config"
            return {
                -- Files to be hot-reloaded when modified.
                reload_files = {
                    config_dir .. "autocmds.lua",
                    config_dir .. "keymaps.lua",
                    config_dir .. "options.lua",
                },
                -- Things to do after hot-reload trigger.
                reload_callback = function()
                    vim.cmd(":silent! colorscheme " .. vim.g.default_colorscheme) -- nvim     colorscheme reload command.
                    vim.cmd(":silent! doautocmd ColorScheme") -- heirline colorscheme reload event.
                end,
            }
        end,
    },
    {
        "azratul/live-share.nvim",
        cmd = { "LiveShareServer", "LiveShareJoin" },
        dependencies = {
            "jbyuki/instant.nvim",
        },
        opts = {},
        init = function()
            vim.g.instant_username = "2012bsz"
        end,
    },
    "nvzone/volt",
    { "nvzone/timerly", cmd = "TimerlyToggle" },
    { "nvzone/typr", cmd = { "Typr", "TyprStats" } },
    {
        "yorickpeterse/nvim-window",
        keys = {
            { "<leader>ww", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
        },
        opts = {
            normal_hl = "Normal",
            render = "float",
        },
    },
    {
        "mhanberg/output-panel.nvim",
        event = "LspAttach",
        keys = { "<F2>", "<cmd>OutputPannel<cr>", desc = "Lsp Output" },
        opts = {},
    },
}
