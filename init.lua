-- [nfnl] Compiled from init.fnl by https://github.com/Olical/nfnl, do not edit.
vim.g.mapleader = " "
local lazypath = (vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
local nfnlpath = (vim.fn.stdpath("data") .. "/lazy/nfnl")
if vim.env.PROF then
  local snacks = (vim.fn.stdpath("data") .. "/lazy/snacks.nvim")
  vim.opt.rtp:append(snacks)
  local _, profiler = pcall(require, "snacks")
  profiler.startup({startup = {{event = "VeryLazy"}}})
else
end
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
require("autocmds")
local function _4_()
  require("mappings")
  return require("configs.init_funcs")
end
vim.schedule(_4_)
return nil
