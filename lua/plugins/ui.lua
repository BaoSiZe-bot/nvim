return {
    {
        "Isrothy/neominimap.nvim",
        version = "v3.x.x",
        enabled = false,
        event = "LazyFile",
        priority = 1919810,
        init = function()
            vim.opt.wrap = false
            vim.opt.sidescrolloff = 36
            vim.g.neominimap = {
                auto_enable = true,
                float = {
                    window_border = "none",
                },
            }
        end,
    },
    {
        "dstein64/nvim-scrollview",
        event = "UIEnter",
    },
    {
        "sphamba/smear-cursor.nvim",
        event = "CursorMoved",
        cond = vim.g.neovide == nil,
        opts = {
            hide_target_hack = true,
            cursor_color = "none",
        },
        specs = {
            -- disable mini.animate cursor
            {
                "nvim-mini/mini.animate",
                optional = true,
                opts = {
                    cursor = { enable = false },
                },
            },
        },
    },
    {
        "LuxVim/nvim-luxmotion",
        enabled = false, -- kill it because it cause matchit don't work, it cause I can't insert 'web' in select mode.
        event = "CursorMoved",
        config = function()
            require("luxmotion").setup({
                cursor = {
                    duration = 250,
                    easing = "ease-out",
                    enabled = true,
                },
                scroll = {
                    duration = 400,
                    easing = "ease-out",
                    enabled = true,
                },
                performance = { enabled = true },
                keymaps = {
                    cursor = true,
                    scroll = true,
                },
            })
        end,
    },
    {
        "rainbowhxch/beacon.nvim",
        event = "CursorMoved",
        cond = function()
            -- Don't load in neovide
            return not vim.g.neovide
        end,
    },
    {
        "levouh/tint.nvim",
        event = "UIEnter",
        opts = {}
    },
}
