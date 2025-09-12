return {
    {
        "wsdjeg/code-runner.nvim",
        event = "LazyFile",
        dependencies = {
            "wsdjeg/job.nvim",
            "wsdjeg/notify.nvim"
        },
        opts = {
            runners = {
                -- Example
                lua = {
                    exe = "lua",
                    opt = { "-" },
                    usestdin = true
                },
                cpp = function()
                    -- Full path to current file (see :help expand())
                    local file = vim.fn.expand("%:p")
                    local tmpnoext = "/tmp/" .. vim.fn.expand("%:t:e") .. "-" .. vim.fn.expand("%:t:r")
                    return {
                        exe = { "clang++" },
                        opt = { file, "-o", tmpnoext, "-Wall", "-Wextra", "-Wno-register", "-std=c++2c", "-g3" },
                        usestdin = true
                    }
                end,

            },
            enter_win = true,
        }
    },
    {
        "wsdjeg/repl.nvim",
        event = "VeryLazy",
        config = function()
            require('repl').setup({
                executables = {
                    lua = 'lua',
                    igcc = 'igcc'
                },
            })
        end,
        dependencies = {
            "wsdjeg/job.nvim",
        },
    },
}
