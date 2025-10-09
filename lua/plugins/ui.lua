return {
    {
        "Isrothy/neominimap.nvim",
        version = "v3.x.x",
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
        "eandrju/cellular-automaton.nvim",
        cmd = { "CellularAutomaton" },
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
    }
}
