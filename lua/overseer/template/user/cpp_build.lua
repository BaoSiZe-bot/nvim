return {
    name = "clang_build",
    builder = function()
        -- Full path to current file (see :help expand())
        local file = vim.fn.expand("%:p")
        local tmpnoext = "C:/Users/Administrator/AppData/Local/Temp/" .. vim.fn.expand("%:t:e") .. "-" .. vim.fn.expand("%:t:r") .. ".exe"
        return {
            cmd = { "D:/msys64/clang64/bin/clang++" },
            args = { file, "-o", tmpnoext, "-Wall", "-Wextra", "-Wno-register", "-std=c++2c", "-g3" },
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "cpp" },
    },
}
