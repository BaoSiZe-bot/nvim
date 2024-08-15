return {
  name = "clang_build",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    local fnoext = vim.fn.expand("%:p:r")
    return {
      cmd = { "clang++" },
      args = { file, "-o", fnoext, "-Wall", "-Wextra", "-Werror", "-Wno-register", "-std=c++2c", "-g3" },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
