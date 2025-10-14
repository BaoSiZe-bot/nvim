return {
    {
        "brenton-leighton/multiple-cursors.nvim",
        opts = {}, -- This causes the plugin setup function to be called
        keys = {
            { "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "x" }, desc = "Add cursor and move down" },
            { "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>",   mode = { "n", "x" }, desc = "Add cursor and move up" },

            {
                "<C-LeftMouse>",
                "<Cmd>MultipleCursorsMouseAddDelete<CR>",
                mode = { "n", "i" },
                desc = "Add or remove cursor",
            },

            { "ga",    "<Cmd>MultipleCursorsAddMatches<CR>",    mode = { "n", "x" }, desc = "Add cursors to cword" },
            {
                "gA",
                "<Cmd>MultipleCursorsAddMatchesV<CR>",
                mode = { "n", "x" },
                desc = "Add cursors to cword in previous area",
            },

            {
                "<M-i>",
                "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
                mode = { "n", "x" },
                desc = "Add cursor and jump to next cword",
            },
            { "<M-n>", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Jump to next cword" },
        },
    },
}
