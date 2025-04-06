return {
    name = "build_and_run",
    builder = function()
        return {
            cmd = { "C:/Users/Administrator/AppData/Local/Temp/" .. vim.fn.expand("%:t:e") .. "-" .. vim.fn.expand("%:t:r") .. ".exe"},
            strategy = "toggleterm",
            components = {
                {
                    "dependencies",
                    task_names = {
                        "clang_build",
                    },
                },
                "default"
            },
        }
    end,
    condition = {
        filetype = { "c", "cpp" },
    },
}
