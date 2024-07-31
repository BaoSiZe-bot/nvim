local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://kkgithub.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      url = "https://kkgithub.com/olimorris/onedarkpro.nvim",
      opts = {
        options = {
          highlight_inactive_windows = true,
        },
      },
    },
    { "folke/tokyonight.nvim", enabled = false },
    -- add LazyVim and import its plugins
    {
      url = "https://kkgithub.com/LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = { colorscheme = "onedark" },
    },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
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

-- vim.opt.mousemoveevent = true
-- vim.keymap.set("n", "<RightMouse>", [[<Nop>]])
-- vim.keymap.set("n", "<RightDrag>", [[<Cmd>lua require("gesture").draw()<CR>]], { silent = true })
-- vim.keymap.set("n", "<RightRelease>", [[<Cmd>lua require("gesture").finish()<CR>]], { silent = true })
--
-- local gesture = require("gesture")
-- gesture.register({
--   name = "scroll to bottom",
--   inputs = { gesture.up(), gesture.down() },
--   action = "normal! G",
-- })
-- gesture.register({
--   name = "scroll to top",
--   inputs = { gesture.down(), gesture.up() },
--   action = "normal! gg",
-- })
-- gesture.register({
--   name = "scroll up",
--   inputs = { gesture.up() },
--   action = "normal! 20kzz",
-- })
-- gesture.register({
--   name = "scroll down",
--   inputs = { gesture.down() },
--   action = "normal! 20jzz",
-- })
-- gesture.register({
--   name = "next buffer",
--   inputs = { gesture.right() },
--   action = function(_) -- also can use callable
--     vim.cmd([[BufferLineCycleNext]])
--   end,
-- })
-- gesture.register({
--   name = "previous buffer",
--   inputs = { gesture.left() },
--   action = function(_) -- also can use callable
--     vim.cmd([[BufferLineCyclePrev]])
--   end,
-- })
-- gesture.register({
--   name = "go back",
--   inputs = { gesture.right(), gesture.left() },
--   -- map to `<C-o>` keycode
--   action = function()
--     vim.api.nvim_feedkeys(vim.keycode("<C-o>"), "n", true)
--   end,
-- })
-- gesture.register({
--   name = "New buffer",
--   match = function(ctx)
--     local last_input = ctx.inputs[#ctx.inputs]
--     return last_input and last_input.direction == "UP"
--   end,
--   can_match = function(ctx)
--     local first_input = ctx.inputs[1]
--     return first_input and first_input.direction == "RIGHT"
--   end,
--   action = function()
--     vim.cmd([[enew]])
--   end,
-- })
-- gesture.register({
--   name = "Delete buffer",
--   match = function(ctx)
--     local last_input = ctx.inputs[#ctx.inputs]
--     return last_input and last_input.direction == "UP"
--   end,
--   can_match = function(ctx)
--     local first_input = ctx.inputs[1]
--     return first_input and first_input.direction == "RIGHT"
--   end,
--   action = function()
--     LazyVim.ui.bufremove()
--   end,
-- })
