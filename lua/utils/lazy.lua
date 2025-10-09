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
return M
