local M = {}
function M.snippet_replace(snippet, fn)
    return snippet:gsub("%$%b{}", function(m)
        local n, name = m:match("^%${(%d+):(.+)}$")
        return n and fn({ n = n, text = name }) or m
    end) or snippet
end

function M.snippet_preview(snippet)
    local ok, parsed = pcall(function()
        return vim.lsp._snippet_grammar.parse(snippet)
    end)
    return ok and tostring(parsed)
        or M.snippet_replace(snippet, function(placeholder)
            return M.snippet_preview(placeholder.text)
        end):gsub("%$0", "")
end

function M.snippet_fix(snippet)
    local texts = {} ---@type table<number, string>
    return M.snippet_replace(snippet, function(placeholder)
        texts[placeholder.n] = texts[placeholder.n] or M.snippet_preview(placeholder.text)
        return "${" .. placeholder.n .. ":" .. texts[placeholder.n] .. "}"
    end)
end

function M.expand(snippet)
    local ok, _ = pcall(vim.snippet.expand, snippet)
    if not ok then
        local fixed = M.snippet_fix(snippet)
        ok = pcall(vim.snippet.expand, fixed)
    end
end

return M
