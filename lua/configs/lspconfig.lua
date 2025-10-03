-- load defaults i.e lua_lsp
local map = vim.keymap.set
-- export on_attach & capabilities
local on_attach = function(client, bufnr)
    local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
    end
    map("n", "gd", function() require("snacks").picker.lsp_definitions() end, { desc = "Goto Definition" })
    map("n", "gr", function() require("snacks").picker.lsp_references() end, { nowait = true, desc = "References" })
    map("n", "gI", function() require("snacks").picker.lsp_implementations() end, { desc = "Goto Implementation" })
    map("n", "gy", function() require("snacks").picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })

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
    vim.keymap.set("n", "<leader>cr", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Rename" })
    map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts("Code action"))
end


-- local capabilities = vim.lsp.protocol.make_client_capabilities()

-- capabilities.textDocument.completion.completionItem = {
--     offsetEncoding = { "utf-16" },
--     documentationFormat = { "markdown", "plaintext" },
--     snippetSupport = true,
--     preselectSupport = false,
--     insertReplaceSupport = true,
--     labelDetailsSupport = true,
--     deprecatedSupport = false,
--     commitCharactersSupport = false,
--     tagSupport = { valueSet = { 1 } },
--     insertTextModeSupport = { valueSet = { 1 } },
--     resolveSupport = {
--         properties = {
--             "documentation",
--             "detail",
--             "additionalTextEdits",
--             "command",
--             "data"
--         }
--     },
-- }]

local capabilities = {
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
    virtual_text = { prefix = "" },
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

local lsps = {
    "cpp",
    "lua",
    "python",
    "fennel",
}

for _, lsp_name in ipairs(lsps) do
    local success, config_module = pcall(require, "configs.lsp." .. lsp_name)

    if success and config_module and config_module.setup then
        config_module.setup(on_attach, capabilities)
    else
        print("Error loading or setting up LSP config for: " .. lsp_name)
    end
end
