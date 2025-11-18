local M = {}

M.setup = function()
	vim.lsp.config("marksman", {
		on_attach = Abalone.lsp._on_attach,
		capabilities = Abalone.lsp._capabilities,
	})
	vim.lsp.enable("marksman")
end

return M
