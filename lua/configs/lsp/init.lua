-- load defaults i.e lua_lsp
local M = {}
local map = vim.keymap.set
-- export on_attach & capabilities
M.on_attach = function(client, bufnr)
    local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
    end
    if Abalone.lazy.has("snacks.nvim") then
        map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
        map("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
        map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
        map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
    end

    map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
    map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))


    if
        client:supports_method("textDocument/codeLens")
        and vim.lsp.codelens
    then
        vim.lsp.codelens.refresh()
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
        })
    end

    -- if
    --     client:supports_method("textDocument/inlayHints")
    --     and vim.api.nvim_buf_is_valid(bufnr)
    --     and vim.bo[bufnr].buftype == ""
    -- then
    --     vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    -- end

    if client:supports_method("textDocument/foldingRange") then
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    vim.keymap.set("n", "<leader>cr", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Rename" })
    map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts("Code action"))
end

M.capabilities = {
    offsetEncoding = { "utf-16" },
    workspace = {
        fileOperations = {
            didRename = true,
            willRename = true,
        },
    },
}

local x = vim.diagnostic.severity

vim.diagnostic.config({
    virtual_text = false,
    signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
    underline = true,
    float = { border = "single" },
})

-- Default border style
---@type fun(contents: table, syntax: string|nil, opts: table|nil, ...): any
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
    opts = opts or {}
    opts.border = "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts)
end

M.setup = function(lsps)
    vim.lsp.config("*", {
        on_attach = M.on_attach,
        capabilities = M.capabilities,
    })
    for _, lsp_name in ipairs(lsps) do
        require("configs.lsp.servers." .. lsp_name).setup()
    end
end

return M
