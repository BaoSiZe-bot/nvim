return {
    'Wansmer/treesj',
    keys = {
        {'<leader>m', function() require('treesj').toggle() end, desc = "toggle treesj"},
        {'gJ', function() require("treesj").join() end, desc = "Join lines"},
        {'gS', function() require("treesj").split() end, desc = "Split into lines"}
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
    opts = {
        ---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = false,
    }
}
