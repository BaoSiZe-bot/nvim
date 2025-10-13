local M = {}

local on_attach = function(client, bufnr)
    local map = vim.keymap.set
    map({ "i", "n" }, "<M-]", function() vim.lsp.inline_completion.select({ count = 1 }) end,
        { desc = "Next Copilot Suggestion", buffer = bufnr })
    map({ "i", "n" }, "<M-[", function() vim.lsp.inline_completion.select({ count = -1 }) end,
        { desc = "Prev Copilot Suggestion", buffer = bufnr })
end

M.setup = function()
    vim.schedule(function()
        vim.lsp.inline_completion.enable()
    end)

    -- Accept inline suggestions or next edits
    -- LazyVim.cmp.actions.ai_accept = function()
    --   return vim.lsp.inline_completion.get()
    -- end

    vim.lsp.config("copilot", {
        on_attach = on_attach,
    })

    if not Abalone.lazy.has_extra("ai.sidekick") then
        vim.lsp.config("copilot", {
            handlers = {
                didChangeStatus = function(err, res, ctx)
                    if err then
                        return
                    end
                    if res.status == "Error" then
                        error("Please use `:LspCopilotSignIn` to sign in to Copilot")
                    end
                end,
            },
        })
    end
    vim.lsp.enable("copilot")
end

return M
