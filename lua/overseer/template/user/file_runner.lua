return {
    name = "build_and_run",
    strategy = "toggleterm",
    builder = function()
        -- Full path to current file (see :help expand())
        local tmpnoext = "/tmp/" .. vim.fn.expand("%:t:e") .. "-" .. vim.fn.expand("%:t:r")
        return {
            cmd = { tmpnoext },
            components = {
                -- Note that since we're using the "raw task parameters" format for the dependency,
                -- we don't have to define a separate build task.
                {
                    "dependencies",
                    task_names = {
                        "clang_build",
                    },
                },
                "default",
            },
        }
    end,
    condition = {
        filetype = { "c", "cpp" },
    },
}
