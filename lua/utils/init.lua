local M = {}
local spec = { "lsp", { ".git", "lua" }, "cwd" }

function M.gitNorm(path)
    if path:sub(1, 1) == "~" then
        local home = vim.uv.os_homedir()
        if home:sub(-1) == "\\" or home:sub(-1) == "/" then
            home = home:sub(1, -2)
        end
        path = home .. path:sub(2)
    end
    path = path:gsub("\\", "/"):gsub("/+", "/")
    return path:sub(-1) == "/" and path:sub(1, -2) or path
end

function M.gitRealpath(path)
    if path == "" or path == nil then
        return nil
    end
    path = vim.uv.fs_realpath(path) or path
    return M.gitNorm(path)
end

function M.gitBufpath(buf)
    return M.gitRealpath(vim.api.nvim_buf_get_name(assert(buf)))
end

local detectors = {}

function detectors.cwd()
    return { vim.uv.cwd() }
end

function detectors.pattern(buf, patterns)
    patterns = type(patterns) == "string" and { patterns } or patterns
    local path = M.gitBufpath(buf) or vim.uv.cwd()
    local pattern = vim.fs.find(function(name)
        for _, p in ipairs(patterns) do
            if name == p then
                return true
            end
            if p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$") then
                return true
            end
        end
        return false
    end, { path = path, upward = true })[1]
    return pattern and { vim.fs.dirname(pattern) } or {}
end

function M.gitResolve(spec)
    if detectors[spec] then
        return detectors[spec]
    elseif type(spec) == "function" then
        return spec
    end
    return function(buf)
        return detectors.pattern(buf, spec)
    end
end

function M.gitDetect(opts)
    opts = opts or {}
    opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or spec
    opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

    local ret = {}
    for _, spec in ipairs(opts.spec) do
        local paths = M.gitResolve(spec)(opts.buf)
        paths = paths or {}
        paths = type(paths) == "table" and paths or { paths }
        local roots = {}
        for _, p in ipairs(paths) do
            local pp = M.gitRealpath(p)
            if pp and not vim.tbl_contains(roots, pp) then
                roots[#roots + 1] = pp
            end
        end
        table.sort(roots, function(a, b)
            return #a > #b
        end)
        if #roots > 0 then
            ret[#ret + 1] = { spec = spec, paths = roots }
            if opts.all == false then
                break
            end
        end
    end
    return ret
end

function M.gitInfo()
    local spec = type(vim.g.root_spec) == "table" and vim.g.root_spec or spec

    local roots = M.gitDetect({ all = true })
    local lines = {} ---@type string[]
    local first = true
    for _, root in ipairs(roots) do
        for _, path in ipairs(root.paths) do
            lines[#lines + 1] = ("- [%s] `%s` **(%s)**"):format(
                first and "x" or " ",
                path,
                type(root.spec) == "table" and table.concat(root.spec, ", ") or root.spec
            )
            first = false
        end
    end
    lines[#lines + 1] = "```lua"
    lines[#lines + 1] = "vim.g.root_spec = " .. vim.inspect(spec)
    lines[#lines + 1] = "```"
    return roots[1] and roots[1].paths[1] or vim.uv.cwd()
end

local cache = {}

function M.rootGet(opts)
    opts = opts or {}
    local buf = opts.buf or vim.api.nvim_get_current_buf()
    local ret = cache[buf]
    if not ret then
        local roots = M.gitDetect({ all = false, buf = buf })
        ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
        cache[buf] = ret
    end
    return ret
end

vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "DirChanged", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("lazyvim_root_cache", { clear = true }),
    callback = function(event)
        cache[event.buf] = nil
    end,
})


M.lazy = require("utils.lazy")
M.treesitter = require("utils.treesitter")

return M
