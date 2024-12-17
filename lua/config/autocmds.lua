vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = { "*" },
    command = "silent! wall",
    nested = true,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "cpp", "c" },
    callback = function()
        vim.b.autoformat = false
    end,
})
