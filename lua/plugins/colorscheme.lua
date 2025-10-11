return {
    {
        "catppuccin/nvim",
        -- lazy = false,
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
                dropbar = {
                    enabled = true,
                    color_mode = true, -- enable color for kind's texts, not just kind's icons
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
                dap = true,
                dap_ui = true,
                neogit = true,
                octo = true,
                overseer = true,
                window_picker = true,
                rainbow_delimiters = true,
            },
            default_integrations = false,
            auto_integrations = false,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
        end,
    },

    {
        "folke/tokyonight.nvim",
        opts = { style = "moon" },
    },

    "askfiy/visual_studio_code",
    {
        "NTBBloodbath/doom-one.nvim",
        config = function()
            -- Add color to cursor
            vim.g.doom_one_cursor_coloring = true
            -- Set :terminal colors
            vim.g.doom_one_terminal_colors = true
            -- Enable italic comments
            vim.g.doom_one_italic_comments = true
            -- Enable TS support
            vim.g.doom_one_enable_treesitter = true
            -- Color whole diagnostic text or only underline
            vim.g.doom_one_diagnostics_text_color = false
            -- Enable transparent background
            vim.g.doom_one_transparent_background = false

            -- Pumblend transparency
            vim.g.doom_one_pumblend_enable = false
            vim.g.doom_one_pumblend_transparency = 20

            -- Plugins integration
            vim.g.doom_one_plugin_neorg = true
            vim.g.doom_one_plugin_barbar = false
            vim.g.doom_one_plugin_telescope = false
            vim.g.doom_one_plugin_neogit = true
            vim.g.doom_one_plugin_nvim_tree = false
            vim.g.doom_one_plugin_dashboard = false
            vim.g.doom_one_plugin_startify = false
            vim.g.doom_one_plugin_whichkey = true
            vim.g.doom_one_plugin_indent_blankline = false
            vim.g.doom_one_plugin_vim_illuminate = false
            vim.g.doom_one_plugin_lspsaga = false
        end,
    },
    "GustavoPrietoP/doom-themes.nvim",
    "NTBBloodbath/sweetie.nvim"
}
