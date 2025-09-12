local bufnr = vim.api.nvim_get_current_buf()
local map = vim.keymap.set
local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
end
vim.keymap.set(
    "n",
    "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
    function()
        vim.cmd.RustLsp({ 'hover', 'actions' })
    end,
    { silent = true, buffer = bufnr }
)

map("n", "gd", require("snacks").picker.lsp_definitions, { desc = "Goto Definition" })
map("n", "gr", require("snacks").picker.lsp_references, { nowait = true, desc = "References" })
map("n", "gI", require("snacks").picker.lsp_implementations, { desc = "Goto Implementation" })
map("n", "gy", require("snacks").picker.lsp_type_definitions, { desc = "Goto T[y]pe Definition" })

vim.keymap.set("n", "<leader>lr", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })
map({ "n", "v" }, "<space>la", vim.lsp.buf.code_action, opts("Code action"))
