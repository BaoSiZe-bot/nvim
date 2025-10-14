return {
    {
        "lewis6991/hover.nvim",
        opts = {
            init = function()
                require("hover.providers.lsp")
            end,
        },
    },
    {
        "Fildo7525/pretty_hover",
        event = "LspAttach",
        opts = {},
    },
    {
        "soulis-1256/eagle.nvim",
        event = "LspAttach",
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
        "VidocqH/lsp-lens.nvim",
        enabled = false,
        opts = {},
        event = "LspAttach",
    },

    {
        "neovim/nvim-lspconfig",
        event = "User FilePost",
        opts = {
            lsps = { "lua" },
        },
        config = vim.schedule_wrap(function(_, opts)
            for _, lsp_name in ipairs(opts.lsps) do
                require("configs.lsp.servers." .. lsp_name).setup()
            end
            vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
        end)
    },

    {
        "kosayoda/nvim-lightbulb",
        event = "LspAttach",
        opts = {
            autocmd = { enabled = true },
            float = {
                -- fucking border!
                enabled = false,
                text = " ",
                lens_text = " ",
            },
            status_text = {
                enabled = true,
                text = " ",
                lens_text = " ",
            },
            sign = {
                enabled = true,
                text = " ",
                lens_text = " ",
            },
            number = {
                enabled = true,
            },
            code_lenses = true,
        },
    },

    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        opts = {},
    },

    -- {
    --     "m-demare/hlargs.nvim",
    --     event = "LspAttach",
    --     opts = {},
    -- },

}
