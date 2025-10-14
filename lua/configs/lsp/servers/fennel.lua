local M = {}

-- Define a new lsp
local fennel_language_server = {
    default_config = {
        -- replace it with true path
        cmd = { '/home/bszzz/.cargo/bin/fennel-language-server' },
        filetypes = { 'fennel' },
        single_file_support = true,
        -- source code resides in directory `fnl/`
        root_dir = require("lspconfig.util").root_pattern("fnl"),
        -- root_dir = lspconfig["util"].root_pattern("fnl"),
        settings = {
            fennel = {
                workspace = {
                    -- If you are using hotpot.nvim or aniseed,
                    -- make the server aware of neovim runtime files.
                    library = vim.api.nvim_list_runtime_paths(),
                },
                diagnostics = {
                    globals = { 'vim' },
                },
            },
        },
        on_attach = Abalone.lsp._on_attach,
        capabilities = Abalone.lsp._capabilities,
    },
}

M.setup = function()
    vim.lsp.fennel_language_server = fennel_language_server
    vim.lsp.enable("fennel_language_server")
end

return M
