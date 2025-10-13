local M = {}

M.setup = function()
    vim.lsp.enable("basedpyright")
    vim.lsp.enable("ruff")
end

return M
