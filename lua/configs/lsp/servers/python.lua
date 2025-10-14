local M = {}

M.setup = function()
    vim.lsp.config("basedpyright", {
        on_attach = Abalone.lsp._on_attach,
        capabilities = Abalone.lsp._capabilities,
    })
    vim.lsp.config("ruff", {
        on_attach = Abalone.lsp._on_attach,
        capabilities = Abalone.lsp._capabilities,
    })
    vim.lsp.enable("basedpyright")
    vim.lsp.enable("ruff")
end

return M
