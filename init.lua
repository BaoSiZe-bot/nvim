local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            "LazyVim/LazyVim",
            import = "lazyvim.plugins",
            opts = { colorscheme = "catppuccin-frappe" },
        },
        { import = "plugins" },
        { import = "plugins.extras.git" },
        { import = "plugins.extras.inc-rename" },
        { import = "plugins.extras.mini-surround" },
        -- { import = "plugins.extras.smear-curosr" },
        { import = "plugins.extras.edgy" },
        { import = "plugins.extras.cpp" },
        { import = "plugins.extras.blink" },
        { import = "lazyvim.plugins.extras.lang.markdown" },
    },
    defaults = {
        lazy = true,
        version = false,
    },
    checker = {
        enabled = false,
        notify = false,
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
                "matchparen",
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
vim.o.mousemoveevent = true
vim.keymap.set("n", "ge", "G")
vim.keymap.set("n", "<leader>k", function()
    vim.lsp.buf.hover()
end, { desc = "symbol info" })
