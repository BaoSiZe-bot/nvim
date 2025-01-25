-- [nfnl] Compiled from fnl/configs/funcs.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
M.dedup = function(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    else
    end
  end
  return ret
end
return M
