---@class abalone.utils.lazy

local M = {}
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end
function M.has(name)
  return M.get_plugin(name) ~= nil
end
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end
---@param extra string
function M.has_extra(extra)
  local modname = "plugins.extras." .. extra
  local LazyConfig = require("lazy.core.config")
  -- check if it was imported already
  if vim.tbl_contains(LazyConfig.spec.modules, modname) then
    return true
  end
  -- check if it's in the imports
  local spec = LazyConfig.options.spec
  if type(spec) == "table" then
    for _, s in ipairs(spec) do
      if type(s) == "table" and s.import == modname then
        return true
      end
    end
  end
  return false
end
return M
