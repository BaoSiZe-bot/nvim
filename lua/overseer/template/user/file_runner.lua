return {
    name = "build_and_run",
    builder = function()
        return {
            cmd = { "/tmp/" .. vim.fn.expand("%:t:e") .. "-" .. vim.fn.expand("%:t:r") },
            strategy = "toggleterm",
            components = {
                {
                    "dependencies",
                    task_names = {
                        "clang_build",
                    },
                },
            },
        }
    end,
    condition = {
        filetype = { "c", "cpp" },
    },
}
