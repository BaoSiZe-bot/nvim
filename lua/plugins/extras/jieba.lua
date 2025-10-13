return {
    'noearc/jieba.nvim',
    dependencies = { 'noearc/jieba-lua' },
    event = "LazyFile",
    config = function()
        require("jieba_nvim").setup()
        vim.keymap.set('n', 'ce', ":lua require'jieba_nvim'.change_w()<CR>", { noremap = false, silent = true })
        vim.keymap.set('n', 'de', ":lua require'jieba_nvim'.delete_w()<CR>", { noremap = false, silent = true })
        -- vim.keymap.set('n', '<leader>w', ":lua require'jieba_nvim'.select_w()<CR>", { noremap = false, silent = true })
    end
}
