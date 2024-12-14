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
    { import = "lazyvim.plugins.extras.ui.smear-cursor" },
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.editor.illuminate" },
    { import = "lazyvim.plugins.extras.editor.inc-rename" },
    { import = "lazyvim.plugins.extras.editor.overseer" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.ui.edgy" },
    { import = "lazyvim.plugins.extras.util.octo" },
    { import = "lazyvim.plugins.extras.util.gitui" },
    { import = "plugins" },
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
