return {
    {
        "rhysd/nyaovim-popup-tooltip",
        cond = vim.fn.exists("g:nyaovim_version") ~= 0,
        lazy = false
    },
    {
        "rhysd/nyaovim-markdown-preview",
        cond = vim.fn.exists("g:nyaovim_version") ~= 0,
        lazy = false
    },
    {
        "rhysd/nyaovim-mini-browser",
        cond = vim.fn.exists("g:nyaovim_version") ~= 0,
        lazy = false
    },
    -- {
    --     "rhysd/nyaovim-tree-view",
    --     cond = vim.fn.exists("g:nyaovim_version") ~= 0,
    --     lazy = false
    -- }
}
