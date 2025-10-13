return {
    "azratul/live-share.nvim",
    cmd = { "LiveShareServer", "LiveShareJoin" },
    dependencies = {
        "jbyuki/instant.nvim",
    },
    config = function()
        vim.g.instant_username = "your-username"
        require("live-share").setup({
            max_attempts = 40,     -- 10 seconds
        })
    end,
}
