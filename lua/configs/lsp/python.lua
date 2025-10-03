local M = {}

M.setup = function(on_attach, capabilities)
    local servers = { "basedpyright", "ruff" }

    -- lsps with default config
    for _, lsp in ipairs(servers) do
        vim.lsp.config(lsp, {
            on_attach = on_attach,
            capabilities = capabilities,
        })
        vim.lsp.enable(lsp)
    end
end

return M
