return {
    {
        "catppuccin/nvim",
        lazy = false,
        priority = 1000,
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                integrations = {
                    aerial = true,
                    alpha = true,
                    blink_cmp = true,
                    dashboard = true,
                    flash = true,
                    fzf = true,
                    grug_far = true,
                    gitsigns = true,
                    headlines = true,
                    illuminate = true,
                    indent_blankline = { enabled = true },
                    leap = true,
                    lsp_trouble = true,
                    mason = true,
                    markdown = true,
                    diffview = true,
                    fidget = true,
                    mini = true,
                    native_lsp = {
                        enabled = true,
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                        },
                    },
                    navic = {
                        enabled = false,
                        custom_bg = "NONE",
                    },
                    neotest = true,
                    neotree = true,
                    noice = true,
                    notify = true,
                    semantic_tokens = true,
                    snacks = true,
                    telescope = true,
                    treesitter = true,
                    treesitter_context = true,
                    which_key = true,
                },
            })
            vim.cmd.colorscheme("catppuccin-frappe")
        end,
    },
    "folke/tokyonight.nvim",
}
