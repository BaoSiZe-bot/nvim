-- [nfnl] Compiled from init.fnl by https://github.com/Olical/nfnl, do not edit.
vim.g.mapleader = " "
local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
local nfnlpath = (vim.fn.stdpath("data") .. "/lazy/nfnl")
if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({git = "clone", ["--filter=blob:none"] = repo, ["--branch=stable"] = lazypath})
else
end
if not vim.uv.fs_stat(nfnlpath) then
  local repo = "https://github.com/Olical/nfnl.git"
  vim.fn.system({git = "clone", [repo] = lazypath})
else
end
vim.opt.rtp:prepend(nfnlpath)
vim.opt.rtp:prepend(lazypath)
local lazy_config = require("configs.lazy")
do
  local _, lazyevent = pcall(require, "lazy.core.handler.event")
  lazyevent.mappings.LazyFile = {id = "LazyFile", event = "BufReadPost", BufWrite = "BufNewFile"}
end
do
  local _, lazy = pcall(require, "lazy")
  lazy.setup({{url = "https://github.com/Olical/nfnl", ft = "fennel"}, {import = "plugins"}}, lazy_config)
end
require("options")
local function _3_()
  require("mappings")
  return require("configs.init_funcs")
end
vim.schedule(_3_)
require("autocmds")
return nil
