vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", repo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")
local lazyevent = require("lazy.core.handler.event")
lazyevent.mappings.LazyFile = {
    id = "LazyFile",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }
}
local lazy = require("lazy")

require("options")
if not vim.g.vscode then
    require("autocmds")
    require("mappings")
    lazy.setup({
        {
            import = "plugins",
        },
        {
            -- cond = vim.fn.has("nvim-0.12") == 1,
            import = "plugins.extras.sidekick",
        },
        {
            import = "plugins.extras.mini-hipatterns",
        },
        {
            import = "plugins.extras.yazi"
        },
        {
            import = "plugins.extras.rainbow"
        },
        -- {
        --    import = "plugins.extras.gemini"
        -- },
        -- {
        --    import = "plugins.extras.spacevim"
        --},
        {
            "Old-Farmer/im-autoswitch.nvim",
            event = "LazyFile",
            opts = {
                cmd = {
                    -- default im
                    default_im = "1",
                    -- get current im
                    get_im_cmd = "fcitx5-remote",
                    -- cmd to switch im. the plugin will put an im name in "{}"
                    -- or
                    -- cmd to switch im between active/inactive
                    switch_im_cmd = "fcitx5-remote -t",
                },
            },
        },
    }, lazy_config)
else
    require("mappings-vscode")
    lazy.setup({ {
        import = "plugins-vscode",
    } }, lazy_config)
end

require("custom")
