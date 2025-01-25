(local M [])
(fn M.dedup [list]
  (local ret [])
  (local seen [])
  (each [_ v (ipairs list)]
    (when (not (. seen v))
      (table.insert ret v)
      (set (. seen v) true)))
  ret)
M
