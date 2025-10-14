local M = {}

M.setup = function()
    vim.lsp.config("lua_ls", {
        filetypes = { "lua" },
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = {
                        vim.fn.expand("$VIMRUNTIME/lua"),
                        vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                        vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                        "${3rd}/luv/library",
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
            },
        },
        on_attach = Abalone.lsp._on_attach,
        capabilities = Abalone.lsp._capabilities,
    })
    vim.lsp.enable("lua_ls")
end

return M
