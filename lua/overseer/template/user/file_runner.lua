-- /home/stevearc/.config/nvim/lua/overseer/template/user/run_script.lua
return {
  name = "build_and_run",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand("%:p")
    local outfile = vim.fn.expand("%:p:r") .. ".out"
    return {
      cmd = { outfile },
      components = {
        -- Note that since we're using the "raw task parameters" format for the dependency,
        -- we don't have to define a separate build task.
        {
          "dependencies",
          task_names = {
            {
              cmd = "clang++",
              args = { file, "-o", outfile },
            },
          },
        },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "cpp" },
  },
}
