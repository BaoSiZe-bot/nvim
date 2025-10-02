return ---@type LazySpec
{
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>fy",
            mode = { "n", "v" },
            "<cmd>Yazi<cr>",
            desc = "Open yazi in filedir",
        },
        {
            -- Open in the current working directory
            "<leader>fY",
            "<cmd>Yazi cwd<cr>",
            desc = "Open yazi in workspace",
        },
        {
            -- NOTE: this requires a version of yazi that includes
            -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
            "<c-up>",
            "<cmd>Yazi toggle<cr>",
            desc = "Resume the last yazi session",
        },
    },
    opts = {
        open_for_directories = true,
        keymaps = {
            show_help = "<f1>",
        },
    },
}
