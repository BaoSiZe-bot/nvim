return {
    {
        "Isrothy/neominimap.nvim",
        version = "v3.x.x",
        lazy = false,
        -- enabled = false,
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
        "folke/flash.nvim",
        event = "VeryLazy",
        vscode = true,
        config = function()
            require("flash").setup({})
            function FlashWords()
                local Flash = require("flash")

                local function format(opts)
                    -- always show first and second label
                    return {
                        { opts.match.label1, "FlashMatch" },
                        { opts.match.label2, "FlashLabel" },
                    }
                end

                Flash.jump({
                    search = { mode = "search" },
                    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
                    pattern = [[\<]],
                    action = function(match, state)
                        state:hide()
                        Flash.jump({
                            search = { max_length = 0 },
                            highlight = { matches = false },
                            label = { format = format },
                            matcher = function(win)
                                -- limit matches to the current label
                                return vim.tbl_filter(function(m)
                                    return m.label == match.label and m.win == win
                                end, state.results)
                            end,
                            labeler = function(matches)
                                for _, m in ipairs(matches) do
                                    m.label = m.label2 -- use the second label
                                end
                            end,
                        })
                    end,
                    labeler = function(matches, state)
                        local labels = state:labels()
                        for m, match in ipairs(matches) do
                            match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                            match.label2 = labels[(m - 1) % #labels + 1]
                            match.label = match.label1
                        end
                    end,
                })
            end

            function FlashLines()
                require("flash").jump({
                    search = { mode = "search", max_length = 0 },
                    label = { after = { 0, 0 } },
                    pattern = "^",
                })
            end

            vim.keymap.set({ "o", "x", "n" }, "gw", FlashWords, { desc = "Flash Words" })
            vim.keymap.set({ "o", "x", "n" }, "gj", FlashLines, { desc = "Flash Lines" })
        end,
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },
    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
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
    -- {
    --     "sphamba/smear-cursor.nvim",
    --     event = "CursorMoved",
    --     cond = vim.g.neovide == nil,
    --     opts = {
    --         -- Smear cursor when switching buffers or windows.
    --         smear_between_buffers = true,
    --
    --         -- Smear cursor when moving within line or to neighbor lines.
    --         -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
    --         smear_between_neighbor_lines = true,
    --
    --         -- Draw the smear in buffer space instead of screen space when scrolling
    --         scroll_buffer_space = true,
    --
    --         -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    --         -- Smears will blend better on all backgrounds.
    --         legacy_computing_symbols_support = false,
    --
    --         -- Smear cursor in insert mode.
    --         -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
    --         smear_insert_mode = true,
    --     }
    -- },
    {
        "hiphish/rainbow-delimiters.nvim",
        event = "LazyFile",
        config = function()
            local rainbow_delimiters = require("rainbow-delimiters")
            require("rainbow-delimiters.setup").setup({
                strategy = {
                    [""] = rainbow_delimiters.strategy["global"],
                    vim = rainbow_delimiters.strategy["local"],
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                },
                priority = {
                    [""] = 110,
                    lua = 210,
                },
                highlight = {
                    "RainbowDelimiterRed",
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterViolet",
                    "RainbowDelimiterCyan",
                },
            })
        end,
    },
    {
        "eandrju/cellular-automaton.nvim",
        cmd = { "CellularAutomaton" },
    },
    {
        "LuxVim/nvim-luxmotion",
        enabled = false,
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
                performance = { enabled = false },
                keymaps = {
                    cursor = true,
                    scroll = true,
                },
            })
        end,
    }
}
