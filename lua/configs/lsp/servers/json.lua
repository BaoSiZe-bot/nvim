local M = {}
M.setup = function()
    vim.lsp.config('jsonls', {
        -- lazy-load schemastore when needed
        filetypes = { "json", "jsonc", "json5" },
        before_init = function(_, new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        settings = {
            json = {
                format = {
                    enable = true,
                },
                validate = { enable = true },
            },
        },
        on_attach = Abalone.lsp._on_attach,
        capabilities = Abalone.lsp._capabilities,
    })
    vim.lsp.enable("jsonls")
end
return M
