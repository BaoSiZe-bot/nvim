return {
    {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        opts = {
            integrations = {
                blink_cmp = true,
                flash = true,
                fzf = true,
                grug_far = true,
                gitsigns = true,
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
                semantic_tokens = true,
                snacks = true,
                telescope = true,
                treesitter = true,
                treesitter_context = true,
                which_key = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin-frappe")
        end,
    },
}
