-- load defaults i.e lua_lsp
local map = vim.keymap.set
-- export on_attach & capabilities
local on_attach = function(client, bufnr)
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
    if
        client.supports_method("textDocument/inlayHints")
        and vim.api.nvim_buf_is_valid(bufnr)
        and vim.bo[bufnr].buftype == ""
    then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    vim.keymap.set("n", "<leader>lr", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })
    map({ "n", "v" }, "<space>la", vim.lsp.buf.code_action, opts("Code action"))
end

-- disable semanticTokens
local on_init = function(client, _)

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

-- local lspconfig = require("lspconfig")
local lspconfig = vim.lsp.config
lspconfig("lua_ls", {
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = on_init,
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
})
vim.lsp.enable("lua_ls")

lspconfig.fennel_language_server = {
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
    },
}


local servers = { "basedpyright", "clangd", "fennel_language_server" }

-- lsps with default config
for _, lsp in ipairs(servers) do
    lspconfig(lsp, {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
    vim.lsp.enable(lsp)
end


