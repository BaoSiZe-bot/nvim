vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", repo, lazypath })
end
vim.opt.rtp:prepend(lazypath)
local lazy_config = require("configs.lazy")
local _, lazyevent = pcall(require, "lazy.core.handler.event")
lazyevent.mappings.LazyFile = {
    id = "LazyFile",
    event = "BufReadPost",
    BufWrite = "BufNewFile",
}
local _, lazy = pcall(require, "lazy")
if not vim.g.vscode then
    lazy.setup({
        {
            import = "plugins",
        },
        -- {
        --    import = "plugins.extras.gemini"
        -- },
        -- {
        --    import = "plugins.extras.spacevim"
        --},
        {
            "Old-Farmer/im-autoswitch.nvim",
            event = "BufEnter",
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
    lazy.setup({ {
        import = "plugins-vscode",
    } }, {
        defaults = {
            lazy = true,
            version = false,
        },
        {
            rocks = {
                hererocks = true, -- recommended if you do not have global installation of Lua 5.1.
            },
        },
        ui = {
            icons = {
                ft = "",
                lazy = "󰂠 ",
                loaded = "",
                not_loaded = "",
            },
        },
        performance = {
            rtp = {
                disabled_plugins = {
                    "2html_plugin",
                    "tohtml",
                    "getscript",
                    "getscriptPlugin",
                    "gzip",
                    "logipat",
                    "netrw",
                    "netrwPlugin",
                    "netrwSettings",
                    "netrwFileHandlers",
                    "matchit",
                    "tar",
                    "tarPlugin",
                    "rrhelper",
                    "spellfile_plugin",
                    "vimball",
                    "vimballPlugin",
                    "zip",
                    "zipPlugin",
                    "tutor",
                    "rplugin",
                    "syntax",
                    "synmenu",
                    "optwin",
                    "compiler",
                    "bugreport",
                    "ftplugin",
                },
            },
        },
    })
end
require("options")
local function _3_()
    require("mappings")
    return require("configs.init_funcs")
end
if not vim.g.vscode then
    vim.schedule(_3_)
    require("autocmds")
else
    require("mappings-vscode")
end
vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
