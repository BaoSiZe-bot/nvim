return {
    {
        "lambdalisue/vim-suda",
        cmd = { "SudaRead", "SudaWrite" },
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
}
