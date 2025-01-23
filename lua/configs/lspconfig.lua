-- load defaults i.e lua_lsp
local map = vim.keymap.set
-- vim.opt.mousemoveevent = true
-- export on_attach & capabilities
local on_attach = function(_, bufnr)
    local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
    end
    map("n", "gd", require("snacks").picker.lsp_definitions, { desc = "Goto Definition" })
    map("n", "gr", require("snacks").picker.lsp_references, { nowait = true, desc = "References" })
    map("n", "gI", require("snacks").picker.lsp_implementations, { desc = "Goto Implementation" })
    map("n", "gy", require("snacks").picker.lsp_type_definitions, { desc = "Goto T[y]pe Definition" })

    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
    -- map("n", "<space>wl", function()
    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts("List workspace folders"))
    vim.keymap.set("n", "<leader>lr", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })
    map({ "n", "v" }, "<space>la", vim.lsp.buf.code_action, opts("Code action"))
    map("n", "gr", vim.lsp.buf.references, opts("Show references"))
end

-- disable semanticTokens
local on_init = function(client, _)
    if client.supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}
local x = vim.diagnostic.severity

vim.diagnostic.config({
    virtual_text = { prefix = "" },
    signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
    underline = true,
    float = { border = "single" },
})

-- Default border style
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

require("lspconfig").lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = on_init,

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
})
local lspconfig = require("lspconfig")

-- EXAMPLE
local servers = { "basedpyright", "clangd" }

-- lsps with default config
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
